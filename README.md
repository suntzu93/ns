1. clone repo

git clone https://github.com/suntzu93/ns.git

3. change node id in start.sh
4. 

# Stop existing containers
docker-compose down

# Clean up
docker system prune -f

# Rebuild and start
docker-compose up -d --build

# Check logs
docker-compose logs -f
