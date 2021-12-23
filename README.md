Aviand for Docker
===================

[![Docker Stars](https://img.shields.io/docker/stars/donnacc/aviand.svg)](https://hub.docker.com/r/donnacc/aviand/)
[![Docker Pulls](https://img.shields.io/docker/pulls/donnacc/aviand.svg)](https://hub.docker.com/r/donnacc/aviand/)

Docker image that runs the Avian aviand node in a container for easy deployment.

Requirements
------------

* Physical machine, cloud instance, or VPS that supports Docker (i.e. [Vultr](http://bit.ly/1HngXg0), [Digital Ocean](http://bit.ly/18AykdD), KVM or XEN based VMs) running Ubuntu 14.04 or later (*not OpenVZ containers!*)
* At least 2 GB to store the block chain files (and always growing!)
* At least 1 GB RAM 

Quick Start
-----------

1. Create a `aviand-data` volume to persist the aviand blockchain data, should exit immediately.  The `aviand-data` container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=aviand-data
        docker run -v aviand-data:/avian/.avian --name=aviand-node -d \
            -p 7895:7895 \
            -p 127.0.0.1:7894:7894 \
            donnacc/aviand

2. Verify that the container is running and aviand node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        donnacc/aviand:latest     "avn_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:7894->7894/tcp, 0.0.0.0:7895->7895/tcp   aviand-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f aviand-node

4. Install optional init scripts for upstart and systemd are in the `init` directory.


Documentation
-------------

* Additional documentation in the [docs folder](docs).
