#!/bin/bash
# Update and install Docker
yum update -y
amazon-linux-extras install docker -y

# Start Docker service
service docker start

# Add ec2-user to Docker group
usermod -aG docker ec2-user

# Enable Docker service to start on boot
systemctl enable docker

# Install Docker Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Git
yum install -y git

# Set up SSH for Git clone
mkdir -p /home/ec2-user/.ssh

# Create a new SSH key on the server
su - ec2-user -c "ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_git -N ''"

# Set up SSH configuration
cat > /home/ec2-user/.ssh/config << 'EOF'
Host github.com
  IdentityFile ~/.ssh/id_rsa_git
  StrictHostKeyChecking no
EOF

chmod 600 /home/ec2-user/.ssh/config
chown ec2-user:ec2-user /home/ec2-user/.ssh/config

# Print the public key to add to GitHub repository
echo "===== PUBLIC KEY (Add this key to GitHub deploy keys) ====="
cat /home/ec2-user/.ssh/id_rsa_git.pub
echo "===== END OF PUBLIC KEY ====="

# Save the public key to a file for easy access later
cat /home/ec2-user/.ssh/id_rsa_git.pub > /home/ec2-user/github_deploy_key.pub
chmod 644 /home/ec2-user/github_deploy_key.pub
chown ec2-user:ec2-user /home/ec2-user/github_deploy_key.pub
