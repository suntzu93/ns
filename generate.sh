#!/bin/bash

# create_docker_compose.sh
# Usage: ./create_docker_compose.sh <number_of_instances>

if [ $# -ne 1 ]; then
    echo "Usage: $0 <number_of_instances>"
    echo "Example: $0 5"
    exit 1
fi

num_instances=$1

# Validate input is a positive number
if ! [[ "$num_instances" =~ ^[0-9]+$ ]] || [ "$num_instances" -lt 1 ]; then
    echo "Error: Please provide a positive number"
    exit 1
fi

# Create docker-compose.yml
cat > docker-compose.yml << EOF
version: '3.8'

services:
EOF

# Add services
for (( i=1; i<=$num_instances; i++ ))
do
cat >> docker-compose.yml << EOF
  nexus-instance$i:
    build: .
    environment:
      - NEXUS_HOME=/root/.nexus_$i
    volumes:
      - ./.nexus_$i:/root/.nexus_$i
    restart: unless-stopped
    command: /usr/local/bin/start.sh

EOF
done

# Create necessary directories
for (( i=1; i<=$num_instances; i++ ))
do
    mkdir -p .nexus_$i
done

echo "Created docker-compose.yml with $num_instances instances"
echo "Created necessary .nexus_* directories"
echo ""
echo "You can now run:"
echo "docker-compose up -d --build"

