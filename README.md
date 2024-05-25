# bootc

Experimenting with bootc for managing my Linux fleet with a cloud native workflow.

Ideas I am interested in:

* Can I use a Containerfile (Dockerfile) as the source of truth for all image types - containers, local VMs, bare metal, AWS ami's etc ?
* No more Packer ?
* cloud native development workflow and tooling for managing a fleet of Linux machines (bare metal, VMs or containers)
* Air gapped updates
* Over the air updates
* easy Roll backs
* supply chain security
* Can I get a bootc equipped LiveCD, boot any new baremetal/VM and the use `bootc` to switch the system over to it's purpose built bootable container and install to local disk ?

## Demo 1

* Create bootable media from `docker.io/aussielunix/bootc-base:latest`
```bash
sudo podman run --rm -it --privileged --pull=newer  --security-opt label=type:unconfined_t -v $(pwd)/output:/output -v /var/lib/containers/storage:/var/lib/containers/storage quay.io/centos-bootc/bootc-image-builder:latest --rootfs ext4 --type iso --target-arch amd64 docker.io/aussielunix/bootc-base:latest
sudo dd status=progress if=output/bootiso/install.iso of=/dev/sda
```
* Boot metal or VM  
  Note: This is cloud-init enabled so be sure to create a username etc but refrain from adding workloads via cloud-init
* ssh to host and switch to track new workload container image - Caddy and a basic website
  ```bash
  sudo bootc switch docker.io/aussielunix/bootc-caddy:latest
  sudo systemctl reboot
  ```
* test new workload - curl / browse to website

## Demo 2

* bake updated workload container
* ssh to host and initiate update
* reboot
* test update workload - curl / browse to website

## Demo 3

* air gapped bare metal install
* air gapped bare metal upgrade
* test

## Demo 4

* supply chain security

## Demo 5

* create ami
* create ec2 instance from base image
* ssh in and switch to workload container image
* reboot
* test

## Links

**SERVERS**

* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_image_mode_for_rhel_to_build_deploy_and_manage_operating_systems/managing-rhel-bootable-images_using-image-mode-for-rhel-to-build-deploy-and-manage-operating-systems#switching-the-container-image-reference_managing-rhel-bootable-images
* https://osbuild.org/docs/bootc/
* https://github.com/containers/bootc
* https://docs.fedoraproject.org/en-US/bootc/auto-updates/
* https://containers.github.io/bootable/what-needs-work.html
* https://github.com/osbuild/bootc-image-builder/tree/main
* https://gitlab.com/redhat/centos-stream/containers/bootc/-/tree/main?ref_type=heads
* https://docs.fedoraproject.org/en-US/bootc/podman-bootc-cli/
* https://centos.github.io/centos-bootc/usage/
* https://github.com/containers/podman-bootc
* https://gitlab.com/fedora/bootc/examples/-/tree/main?ref_type=heads

**WORKSTATIONS**

* [Issue](https://gitlab.com/Siosm/bootc-base-images-experimental/-/tree/fedora-kinoite) tracking the overal readiness of bootc for Atomic Desktops
* https://github.com/rsturla/fedora-bootc-base
* https://github.com/ublue-os/main-bootc
* https://gitlab.com/Siosm/bootc-base-images-experimental/-/tree/fedora-kinoite
