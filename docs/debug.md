# Debugging

## Things to Check

* RAM utilization -- aviand is very hungry and typically needs in excess of 1GB.  A swap file might be necessary.
* Disk utilization -- The avian blockchain will continue growing and growing and growing.  Then it will grow some more.  At the time of writing, 40GB+ is necessary.

## Viewing aviand Logs

    docker logs aviand-node


## Running Bash in Docker Container

*Note:* This container will be run in the same way as the aviand node, but will not connect to already running containers or processes.

    docker run -v aviand-data:/avian --rm -it donnacc/aviand bash -l

You can also attach bash into running container to debug running aviand

    docker exec -it aviand-node bash -l


