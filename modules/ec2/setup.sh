#!/bin/bash
# Update and install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y

# Start Docker service
sudo service docker start

# Add ec2-user to Docker group and apply the new group settings
sudo usermod -aG docker ec2-user
newgrp docker

# Enable Docker service to start on boot
sudo systemctl enable docker

# Pull the InfluxDB Docker image
docker pull influxdb:latest

# Run the InfluxDB container
docker run -d --name=influxdb -p 8086:8086 influxdb:latest

# Wait for InfluxDB to start and be ready
sleep 20

# Set up InfluxDB organization, bucket, user, and password
docker exec -i influxdb influx setup -u admin -p thanh@123 -o sample_org -b sample_bucket -r 0 -f


# Configure InfluxDB container to restart automatically
docker update --restart unless-stopped influxdb

echo "InfluxDB setup complete."
