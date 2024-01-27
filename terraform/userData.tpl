#!/bin/bash
# # ================= install docker ===============
sudo apt-get update -y
sudo apt-get install -y\
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo chmod 777 /var/run/docker.sock


# ================= install awscli ===============
sudo apt install awscli -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install --update


# ================= install kubectl ===============
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.10/2023-01-30/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin


# ================= install Node ===============
sudo apt update -y
sudo apt install npm -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install 18.17.0
 nvm use 18.17.0


# ================= install jq command ===============
sudo apt-get install jq -y



# ================= install Helm ===============
# Create a directory for Helm
mkdir helm

# Change into the Helm directory
cd helm

# Download the Helm binary (replace VERSION with the desired version)
wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz

# Extract the downloaded archive
tar xvf helm-v3.9.3-linux-amd64.tar.gz

# Move the Helm binary to a directory in your PATH
sudo mv linux-amd64/helm /usr/local/bin

# Verify Helm installation
helm version
