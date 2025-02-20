# Use an appropriate base image
FROM ubuntu:latest

# Install necessary tools and libraries
RUN apt-get update && \
    apt-get install -y curl wget unzip git build-essential pkg-config libssl-dev


# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Update the PATH environment variable for Rust and Cargo
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup target add riscv32i-unknown-none-elf


# NEXUS_HOME will be overridden by docker-compose
ENV NEXUS_HOME="/root/.nexus"

# Install Protocol Buffers
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v21.12/protoc-21.12-linux-x86_64.zip && \
    unzip protoc-21.12-linux-x86_64.zip -d /usr/ && \
    rm protoc-21.12-linux-x86_64.zip

# Copy the start script
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Create an entrypoint script
RUN echo '#!/bin/bash\n\
# Create NEXUS_HOME directory\n\
mkdir -p $NEXUS_HOME\n\
\n\
# Clone or update network-api\n\
if [ ! -d "$NEXUS_HOME/network-api" ]; then\n\
    echo "Cloning network-api to $NEXUS_HOME/network-api"\n\
    git clone https://github.com/nexus-xyz/network-api $NEXUS_HOME/network-api\n\
    cd $NEXUS_HOME/network-api\n\
    git checkout $(git rev-list --tags --max-count=1)\n\
    cd clients/cli\n\
    cargo build --release\n\
fi\n\
\n\
cd $NEXUS_HOME/network-api/clients/cli\n\
exec "$@"' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

