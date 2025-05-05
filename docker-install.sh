#!/usr/bin/env bash
set -e
set -x

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

function command_exists() {
    command -v "$1" &> /dev/null
}

# Check if Docker is already installed
if command_exists docker; then
  echo "Docker is already installed."
  exit 0
fi

# Verify OS
. /etc/os-release
if [[ "$ID" != "ubuntu" || "$VERSION_ID" != "22.04" ]]; then
    echo "This script is only for Ubuntu 22.04."
    exit 1
fi

echo -e "\n Installing Docker \n"

apt-get remove -y docker docker-engine docker.io containerd runc &> /dev/null
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

TARGET_USER="${SUDO_USER:-$USER}"
echo -e "\n Adding user ${TARGET_USER} to docker group \n"
usermod -aG docker "$TARGET_USER"

echo -e "\n Docker installation completed successfully."
echo "Please log out and log back in for group changes to take effect."
docker --version
docker compose version
