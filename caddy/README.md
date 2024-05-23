# Caddy

A bootable container with cloud-config and running Caddy.
Supply a replacement for `/etc/caddy/Caddyfile` via cloud-init
move user creation from `config.toml` to cloud-init during provisioning and note
that config.toml is only to be used when creating an image that has no
cloud-init access.

## TODO

* What is the sdlc of this in Proxmox ?
