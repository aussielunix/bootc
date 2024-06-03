build image:
  sudo podman build -t docker.io/aussielunix/{{image}}:latest \
    -f ./{{image}}/Containerfile \
    ./{{image}}

build-qcow2 image:
  mkdir -p .osbuild/{{image}}/output
  sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --platform linux/amd64 \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/.osbuild/{{image}}/output:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type qcow2 --rootfs ext4 \
    --target-arch amd64 \
    --local docker.io/aussielunix/{{image}}:latest

upload_image name version:
  scp .osbuild/{{name}}/output/qcow2/disk.qcow2 root@lab-01:/var/lib/vz/template/{{name}}-{{version}}.qcow2

create_template id name description image_name image_ver:
  #!/usr/bin/env bash
  set -euo pipefail
  ssh -q root@lab-01 <<'ENDSSH'
    # exit if vm exists and is NOT a template
    VMEXISTS=$(/usr/bin/pvesh get /cluster/resources --type vm --output-format json | jq '[.[] | select(.template==0).vmid | contains({{id}})] | any')
    if [[ ${VMEXISTS} == "true" ]]; then
      echo "{{id}} already exists and is not a template."
      echo "Aborting"
      sleep 2
      exit 0
    fi
  TVMEXISTS=$(/usr/bin/pvesh get /cluster/resources --type vm --output-format json | jq '[.[] | select(.template==1).vmid | contains({{id}})] | any')
    if [[ ${TVMEXISTS} == "true" ]]; then
      echo "Deleting existing template {{id}}"
      qm destroy {{id}} --purge 1
      sleep 2
    fi
    pvesh create /nodes/lab-01/qemu \
      --vmid={{id}} \
      --name={{name}} \
      --memory=1024 \
      --net0='virtio,bridge=vmbr1,tag=20' \
      --cores=1 \
      --sockets=1 \
      --cpu='cputype=host' \
      --description='{{image_name}}-{{image_ver}} template - {{description}}' \
      --kvm=1 \
      --agent=1 \
      --machine=q35 \
      --vga=virtio \
      --serial0=socket \
      --balloon=0 \
      --ostype=l26 \
      --ciupgrade=0 \
      --ide2='vmstore:cloudinit' \
      --pool=templates \
      --boot='order=virtio0' \
      --scsihw='virtio-scsi-pci'
    qm disk import {{id}} /var/lib/vz/template/{{image_name}}-{{image_ver}}.qcow2 vmstore --format qcow2
    qm set {{id}} --virtio0 vmstore:vm-{{id}}-disk-0
    qm template {{id}}
  ENDSSH
