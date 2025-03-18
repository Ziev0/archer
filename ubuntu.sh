#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install Visual Studio Code via snap
echo "Installing Visual Studio Code..."
sudo snap install --classic code

# Install Git
echo "Installing Git..."
sudo apt install -y git

# Configure Git user details
echo "Configuring Git user..."
git config --global user.name "ziev0"
git config --global user.email "syedghazi34@gmail.com"

# Generate SSH key pair
echo "Generating SSH key pair..."
ssh-keygen -t ed25519 -C "syedghazi34@gmail.com"

# Start SSH agent
echo "Starting SSH agent..."
eval "$(ssh-agent -s)"

# Add SSH key to SSH agent
echo "Adding SSH key to agent..."
ssh-add ~/.ssh/id_ed25519

# SSH test connection with GitHub
echo "Testing SSH connection with GitHub..."
ssh -T git@github.com

# Clone the repository
echo "Cloning GitHub repository..."
git clone git@github.com:Ziev0/arenaX.git

# Change into the cloned directory
echo "Changing directory into arenaX..."
cd arenaX/

# Install curl if it's not installed yet
echo "Installing curl..."
sudo apt install -y curl

# Install Bun using curl if necessary
echo "Installing Bun using curl..."
curl -fsSL https://bun.sh/install | bash

# Source the bashrc file
echo "Reloading bash configuration..."
source ~/.bashrc

# Install Bun packages once more
echo "Installing Bun dependencies..."
bun install

echo "Post-installation setup complete!"
