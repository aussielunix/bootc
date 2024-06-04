# Install with ISO installer

This is mostly used for bare metal installs but could also be used for cloud
installs where you can not start from a qcow2 or raw image.

On your development workstation:
* Create bootable media from your OCI artifact, either locally stored or in a
  registry
```bash
sudo podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
  --security-opt label=type:unconfined_t \
  -v $(pwd)/output:/output \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  quay.io/centos-bootc/bootc-image-builder:latest \
  --rootfs ext4 \
  --type iso \
  --target-arch amd64 \
  --local aussielunix/bootc-base:latest
```
* Write the iso to USB
```bash
sudo dd status=progress \
  if=output/bootiso/install.iso \
  of=/dev/sda
```

On your new bare metal or VM boot from usb. **Beware, this will automatically take over the first hdd without
confirmation.**

## TODO

There is no users or passwords setup at this stage.  
Need to document how to create users however this is cloud-init enabled so in some circumstances you can create a username with cloud-init.
