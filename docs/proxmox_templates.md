## Proxmox VM Template


```bash
lunix@astro]  (main) -> just -l
Available recipes:
    build image
    build-qcow2 image
    create_template id name description image_name image_ver
    upload_image name version
```
* build new base OCI artifact  
  `just build base`
* build new base qcow2 image  
  `just build-qcow2 base`
* upload base qcow2 image to Proxmox host  
  `just upload_image base 0.1`
* create new VM template  
  `just create_template 7000 base-01 "Built by bootc" base 0.1`

