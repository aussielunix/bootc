# bootc

Experimenting with bootc for a cloud native workflow of my Linux fleet.

Ideas I am interested in:

* Can I use a Containerfile (Dockerfile) as the source of truth for all image types - containers, local VMs, laptop installs, AWS ami's etc ?
* No more Packer ?
* cloud native development workflow and tooling for managing a fleet of Linux machines (bare metal, VMs or containers)
* Air gapped updates
* Over the air updates
* easy Roll backs
* supply chain security

## Notes

* build new container image
```bash
sudo podman build --build-arg "sshpubkey=$(cat /home/myuser/.ssh/id_rsa.pub)" -t localhost/bootc-user:test .
```

* build new installer-iso from baked container image
```bash
sudo podman run --rm -it --privileged --pull=newer  --security-opt label=type:unconfined_t -v $(pwd)/output:/output -v /var/lib/containers/storage:/var/lib/containers/storage quay.io/centos-bootc/bootc-image-builder:latest --type iso --target-arch amd64 --local localhost/bootc-user:test
```

## Air gapped updates

* mount usb drive
* copy OCI artifacts over
```bash
sudo skopeo copy containers-storage:localhost/bootc-user:test  dir://run/media/lunix/1f5f80f1-07f5-4257-b463-8be038de7ed1/updates`
```
* on Linux device mount USB and upgrade using OCI artifacts as the source
```bash
mount /dev/sda1 /mnt/
bootc switch --transport dir /mnt/updates
bootc upgrade --apply
```
:TODO: encrypt and sign OCI artifact on USB

If that fails you can `bootc rollback` to previous OCI container version.

## Links

* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_image_mode_for_rhel_to_build_deploy_and_manage_operating_systems/managing-rhel-bootable-images_using-image-mode-for-rhel-to-build-deploy-and-manage-operating-systems#switching-the-container-image-reference_managing-rhel-bootable-images
* https://github.com/osbuild/bootc-image-builder/tree/main
* https://osbuild.org/docs/bootc/
* https://gitlab.com/fedora/bootc/examples/-/tree/main?ref_type=heads
* https://github.com/containers/podman-bootc
* https://docs.fedoraproject.org/en-US/bootc/podman-bootc-cli/
* https://docs.fedoraproject.org/en-US/bootc/auto-updates/
* https://centos.github.io/centos-bootc/usage/
* https://github.com/CentOS/centos-bootc
* https://containers.github.io/bootable/what-needs-work.html
* https://github.com/ublue-os/main-bootc
* https://github.com/rsturla/fedora-bootc-base
