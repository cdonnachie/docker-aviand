Building
========

The image can be built from source by running:

        docker build .

A recommended security practice is to add an additional unprivileged user to run the daemon as on the host. For example, as a privileged user, run this on the host:

        useradd aviand

To build an image which uses this unprivileged user's id and group id, run:

        docker build --build-arg USER_ID=$( id -u aviand ) --build-arg GROUP_ID=$( id -g aviand ) .

Now, when the container is run with the default options, the aviand process will only have the privileges of the aviand user on the host machine. This is especially important for a process such as aviand which runs as a network service exposed to the internet.
