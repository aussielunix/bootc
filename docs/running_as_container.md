# Running with Podman

Given you are just baking a bootable container rather than booting it as the
main OS, you can run it as a container with podman or docker.  

* create a derivative Containerfile with a non-root user
```bash
FROM aussielunix/bootc-base:0.1
ARG UID=1000
ARG USERNAME=lunix
RUN useradd --uid "$UID" --user-group -G wheel --shell /bin/bash --create-home "$USERNAME"
USER "$USERNAME"
```
* Create new derivative container
```bash
podman build -t aussielunix/bootc-base-container:0.1 .
```
* Run container
```bash
podman run --rm -it aussielunix/bootc-base-container:0.1 /bin/bash
```

