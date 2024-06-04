# Bootable Containers - bootc

Redhat have introduced, as a preview, using image mode for RHEL to build,
deploy, and manage operating systems. This "image mode" is based on bootable containers.

* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_image_mode_for_rhel_to_build_deploy_and_manage_operating_systems/managing-rhel-bootable-images_using-image-mode-for-rhel-to-build-deploy-and-manage-operating-systems#switching-the-container-image-reference_managing-rhel-bootable-images

This repo is my notes whilst experimenting with bootc for managing my Linux fleet with a cloud native workflow.

Ideas I am interested in:

* Can I use a Containerfile (Dockerfile) as the source of truth for all image types - containers, local VMs, bare metal, AWS ami's etc ?
* Does this mean no more Packer ?
* cloud native development workflow and tooling for managing a fleet of Linux machines (bare metal, VMs or containers)
* Air gapped updates
* Over the air updates
* easy Roll backs
* supply chain security for bare meta, VMs and containers

## Docs

I am collecting a bunch of notes in the [docs](docs/) directory.

## Links

Links collected during research and experimentation.

**SERVERS**

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
