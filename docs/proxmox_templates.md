## Proxmox VM Template

```bash
lunix@astro]  (main) -> just -l
Available recipes:
    build image                                                 # build new OCI image locally
    build-iso image                                             # build iso installer from local OCI image
    build-qcow2 image                                           # build new qcow2 image from local OCI image
    hl_upload_image name version                                # upload qcow2 disk image to homelab node
    hl_create_template id name description image_name image_ver # create new VM template in homelab (proxmox)
```
* build new base OCI artifact  
  `just build base`
* build new base qcow2 image  
  `just build-qcow2 base`
* upload base qcow2 image to Proxmox host  
  `just hl_upload_image base 0.1`
* create new VM template  
  `just hl_create_template 7000 base-01 "Built by bootc" base 0.1`
