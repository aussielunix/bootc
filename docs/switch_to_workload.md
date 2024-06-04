# Switch from Base to Workload  image

Switching from running a base image to a workload image:
* bake and publish workload container (eg caddy)
* ssh to host and switch to track new OCI artifact
  ```bash
  sudo bootc switch docker.io/aussielunix/bootc-caddy:latest
  ```
* reboot
  ```bash
  sudo systemctl reboot
  ```
* test workload - curl / browse to VM's IP address
  ```bash
  curl -i http://10.0.0.100 # replace IP
  ```

