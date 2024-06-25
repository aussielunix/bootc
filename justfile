# build new OCI image locally
build image:
  sudo podman build -t docker.io/aussielunix/{{image}}:latest \
    -f ./{{image}}/Containerfile \
    ./{{image}}

# build new qcow2 image from local OCI image
build-qcow2 image:
  mkdir -p .osbuild/{{image}}
  sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --platform linux/amd64 \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/.osbuild/{{image}}:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type qcow2 --rootfs ext4 \
    --target-arch amd64 \
    --local docker.io/aussielunix/{{image}}:latest

#  build iso installer from local OCI image
build-iso image:
  mkdir -p .osbuild/{{image}}
  sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/.osbuild/{{image}}:/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage \
    -v $(pwd)/config.toml:/config.toml \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --rootfs ext4 \
    --type iso \
    --target-arch amd64 \
    --local docker.io/aussielunix/{{image}}:latest

# upload qcow2 disk image to homelab node
hl_upload_image name version:
  scp .osbuild/{{name}}/output/qcow2/disk.qcow2 root@lab-01:/var/lib/vz/template/{{name}}-{{version}}.qcow2

# create new VM template in homelab (proxmox)
hl_create_template id name description image_name image_ver:
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

# create new VM in homelab (proxmox)
# source id - destination id - destination name - description - destination pool - destination IP (last quad)
hl_create_vm sid did dname description dpool dip:
  #!/usr/bin/env bash
  set -euo pipefail
  cat ci.tmpl | sed "s/VMNAME/{{dname}}/g" > /tmp/$$.ci
  scp /tmp/$$.ci root@lab-01:/var/lib/vz/snippets/vm-{{did}}-user-data.yaml
  ssh -q root@lab-01 'qm clone {{sid}} {{did}} --description "{{description}}" --full 1 --name {{dname}} --pool {{dpool}} --target lab-01 --storage vmstore'
  AMAC=$(ssh -q root@lab-01 "pvesh get nodes/lab-01/qemu/{{did}}/config --output-format json | jq .net0 | grep -oE '([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})'")
  cat net.tmpl | sed "s/NEWMAC/$AMAC/g" | sed "s/NEWIP/{{dip}}/g" > /tmp/$$.net
  scp /tmp/$$.net root@lab-01:/var/lib/vz/snippets/vm-{{did}}-network.yaml
  rm /tmp/$$.ci /tmp/$$.net
  ssh -q root@lab-01 'qm set {{did}} --onboot 1 --cicustom "user=local:snippets/vm-{{did}}-user-data.yaml,network=local:snippets/vm-{{did}}-network.yaml" --memory 4096 --sockets 2'
  #qm start {{did}}

# create new libvirt template locally
lo_create_template name image_name image_ver:
  #!/usr/bin/env bash
  set -euo pipefail
  IMGSIZE=$(qemu-img info --output json {{image_name}} | jq -r .[\"virtual-size\"])
  IMGFMT=$(qemu-img info --output json {{image_name}} | jq -r .format)
  virsh vol-create-as --pool default {{name}}-{{image_ver}} ${IMGSIZE} --format ${IMGFMT}
  virsh vol-upload --pool default --vol {{name}}-{{image_ver}} {{image_name}}
  echo "{{name}}-{{image_ver}} from file {{image_name}} is ${IMGSIZE} bytes and is of type ${IMGFMT}"
  virsh vol-list --pool default | grep {{name}}

# create new VM locally
lo_newvm name template:
  #!/usr/bin/env bash
  set -euo pipefail
  #clone template disk
  virsh vol-clone --pool default --vol {{template}} --newname {{name}}
  #create ci-iso
  cat ci.tmpl | sed "s/VMNAME/{{name}}/g" > /tmp/$$.ci
  echo "instance-id: $(uuidgen || echo i-abcdefg)" > /tmp/$$.metadata
  cloud-localds {{name}}.seed.iso /tmp/$$.ci /tmp/$$.metadata
  IMGSIZE=$(qemu-img info --output json {{name}}.seed.iso | jq -r .[\"virtual-size\"])
  IMGFMT=$(qemu-img info --output json {{name}}.seed.iso | jq -r .format)
  virsh vol-create-as default {{name}}.seed.iso ${IMGSIZE} --format ${IMGFMT}
  virsh vol-upload --pool default {{name}}.seed.iso {{name}}.seed.iso
  #cleanup temp files
  rm /tmp/$$.ci /tmp/$$.metadata {{name}}.seed.iso
  #create vm
  virt-install --cpu host-passthrough --name {{name}} --vcpus 2 --memory 4096 --disk vol=default/{{name}}.seed.iso,device=cdrom --disk vol=default/{{name}},device=disk,size=20,bus=virtio,sparse=false --os-variant fedora40 --virt-type kvm --graphics spice --network network=default,model=virtio --autoconsole text --import

# delete local VM
lo_delvm name:
  #!/usr/bin/env bash
  set -euo pipefail
  virsh destroy --domain  {{name}}
  virsh undefine --domain {{name}}
  virsh vol-delete --pool default --vol {{name}}
  virsh vol-delete --pool default --vol {{name}}.seed.iso
