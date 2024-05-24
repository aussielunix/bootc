# Caddy

Bringing the cloud native worklow to VMs and baremetal thanks to [bootc](https://containers.github.io/bootable/) !

A bootable container with cloud-config and running Caddy.  
Supply a replacement for `/etc/caddy/Caddyfile` via cloud-init  
move user creation from `config.toml` to cloud-init during provisioning and note
that config.toml is only to be used when creating an image that has no
cloud-init access.

## SDLC

:TODO: This needs to be in a pipeline.

```bash
# Update build instructions
vim Containerfile

# build new OCI image
sudo podman build -t aussielunix/bootc-caddy:latest .

# test as a container
sudo podman run -p 80:80 --rm -ti aussielunix/bootc-caddy:latest bash

# publish
sudo podman push aussielunix/bootc-caddy:latest

# ssh to vm/metall
ssh ubuntu@10.0.0.1

# mark current OCI image as rollback, update OCI container, stage it & reboot VM/host into it
sudo bootc upgrade --apply

# to rollback to previous OCI container
sudo bootc rollback
```

Add the following to your Containerfile to setup auto update
```bash
systemctl enable --now bootc-fetch-apply-updates.timer
```
