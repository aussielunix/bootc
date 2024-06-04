# Air gapped updates

After baking a new OCI image how do you update in air-gapped environments ?
You can push your new image version to a private registry but what if you are
running devices on the edge that are completely disconnected ?

On your development workstation:

* mount usb drive
* copy new OCI artifact over
```bash
sudo skopeo copy containers-storage:localhost/bootc-user:test  dir:///mnt/usb0/updates`
```

On air-gapped Linux device:

* mount USB
```bash
mount /dev/sda1 /mnt/
```
* upgrade using OCI artifacts as the source
```bash
bootc switch --transport dir /mnt/updates
bootc upgrade --apply
```

If the update fails you can `bootc rollback` or select previous OCI container version from the grub boot menu.

## TODO

* Supply chain security
  * encrypt and sign OCI artifact on USB
  * copy OCI artifact to read-only storage - eg: dvd
