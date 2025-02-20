#!/bin/bash

# Create NEXUS_HOME directory
mkdir -p $NEXUS_HOME

# Clone network-api repository if it doesn't exist
if [ ! -d "$NEXUS_HOME/network-api" ]; then
    git clone https://github.com/nexus-xyz/network-api $NEXUS_HOME/network-api
    cd $NEXUS_HOME/network-api
    git checkout $(git rev-list --tags --max-count=1)
fi

# Execute the command passed to docker run
exec "$@"

