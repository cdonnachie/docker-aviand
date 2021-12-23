aviand config tuning
======================

You can use environment variables to customize config ([see docker run environment options](https://docs.docker.com/engine/reference/run/#/env-environment-variables)):

        docker run -v aviand-data:/avian/.avian --name=aviand-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8332:8332 \
            -e DISABLEWALLET=1 \
            -e PRINTTOCONSOLE=1 \
            -e RPCUSER=mysecretrpcuser \
            -e RPCPASSWORD=mysecretrpcpassword \
            donnacc/aviand

Or you can use your very own config file like that:

        docker run -v aviand-data:/avian/.avian --name=aviand-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8332:8332 \
            -v /etc/myavian.conf:/avian/.avian/avian.conf \
            donnacc/aviand
