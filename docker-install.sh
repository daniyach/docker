#!/usr/bin/env bash

set -e
set -x

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Function to check if a command exists
function command_exists() {
    command -v "$1" &> /dev/null
}

# Check if Docker is already installed
if command_exists docker; then
  echo "Docker is already installed."
  exit 0
fi

# Check if the distribution is Ubuntu
if ! grep -q "Ubuntu" /etc/os-release; then
    echo "This script is only for Ubuntu."
    exit 1
fi

echo -e "\n Installing Docker \n"

# Remove any old versions of Docker
apt-get remove -y docker docker-engine docker.io containerd runc &> /dev/null

# Update the package index
apt-get update

# Install required packages
apt-get install -y ca-certificates curl gnupg

# Create the keyrings directory
install -m 0755 -d /etc/apt/keyrings

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set permissions for the GPG key
chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker's official APT repository
echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again
apt-get update

# Install Docker packages
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "\n Check users: \n"
echo "   - ${SUDO_USER}"
echo "   - ${USER}"
echo -e "\n"

# Add the current user to the docker group
usermod -aG docker "$SUDO_USER"

echo -e "\n Docker installation completed successfully. Please log out and log back in for changes to take effect."
