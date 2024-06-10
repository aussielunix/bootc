## local libvirt/qemu VM Template & VMs

```bash
lunix@astro]  (main) -> just -l
Available recipes:
    build image                                     # build new OCI image locally
    build-iso image                                 # build iso installer from local OCI image
    build-qcow2 image                               # build new qcow2 image from local OCI image
    lo_create_template name image_name image_ver    # create new libvirt template locally
    lo_newvm name template                          # create new VM locally
    lo_delvm name                                   # delete local VM
```
* build new base OCI artifact  
  `just build base`
* build new base qcow2 image  
  `just build-qcow2 base`
* create new libvirt disk template from qcow2  
  `just lo_create_template base .osbuild/base/qcow2/disk.qcow2 0.1
* create new VM  
  `just lo_newvm test-01 base-01`
* delete VM  
  `just lo_delvm test-01`
