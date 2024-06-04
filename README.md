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
  * boot [Fedora CoreOS Live ISO](https://docs.fedoraproject.org/en-US/fedora-coreos/live-booting/) and run
  `podman run --rm --privileged --pid=host -v /var/lib/containers:/var/lib/containers --security-opt label=type:unconfined_t docker.io/aussielunix/bootc-caddy:latest bootc install to-disk /dev/vda`

## Demo

* bake updated workload container
* ssh to host and initiate update
* reboot
* test update workload - curl / browse to website

## Demo

* air gapped bare metal install
* air gapped bare metal upgrade
* test

## Demo

* create ami
* create ec2 instance from base image

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
* https://github.com/UntouchedWagons/Ubuntu-CloudInit-Docs/blob/main/samples/ubuntu/ubuntu-noble-cloudinit.sh

**WORKSTATIONS**

* [Roadmap for Fedora 41](https://gitlab.com/fedora/bootc/tracker/-/issues/11)
* [Roadmap to Fedora Bootable Containers](https://gitlab.com/fedora/ostree/sig/-/issues/26)
* [Issue](https://gitlab.com/Siosm/bootc-base-images-experimental/-/tree/fedora-kinoite) tracking the overal readiness of bootc for Atomic Desktops
* https://github.com/rsturla/fedora-bootc-base
* https://github.com/ublue-os/main-bootc
* https://gitlab.com/Siosm/bootc-base-images-experimental/-/tree/fedora-kinoite
