# Source and provisioning for infynyxx.com

This repo contains source for my static site (https://infynyxx.com) and ansible provisioning scripts. My weekend project to use ansible, docker, letsencrypt and little bit of golang to host / deploy my site in Linode.

* A golang based HTTP server that reads from a given static directory
* That app is packaged into a docker container. See [Dockerfile](./Dockerfile) for more info
* `ansible` directory contains provisioning scripts
  * `config.ini` file is required for providing root ssh pulic key, linode API key and root password
  * Provision `linode1024` instance if `linode_id` is not provided
  * Install docker and run image `infynyxx/infynyxxcom_http_server` from DockerHub in port 8080
  * Install Nginx and LetsEncrypt / Certbot binaries
  * Configure TLS reverse proxy

## Running locally

``` bash
$ docker-compose build && docker-compose up
```

## ToDos

- [ ] Configure cron to renew LetsEncrypt cert
- [ ] Write tests for `main.go`
- [ ] Write ansible tests
