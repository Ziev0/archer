#!/bin/bash

# Exit on error
set -e

# Update system
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install essential packages
echo "Installing Git, curl, openssh..."
sudo pacman -S --noconfirm git curl openssh

# Install yay if it's not installed (for AUR packages like VS Code)
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
fi

# Install Visual Studio Code (AUR version)
echo "Installing Visual Studio Code..."
yay -S --noconfirm visual-studio-code-bin

# Configure Git
echo "Configuring Git..."
git config --global user.name "ziev0"
git config --global user.email "syedghazi34@gmail.com"

# Generate SSH key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "syedghazi34@gmail.com"

# Start SSH agent
echo "Starting SSH agent..."
eval "$(ssh-agent -s)"

# Add SSH key
echo "Adding SSH key..."
ssh-add ~/.ssh/id_ed25519

# Test GitHub SSH connection
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com || echo "You may need to add the key to your GitHub account."

# Clone your repo
echo "Cloning your GitHub repo..."
git clone git@github.com:Ziev0/arenaX.git

cd arenaX/

# Install Bun
echo "Installing Bun..."
curl -fsSL https://bun.sh/install | bash

# Reload shell (assumes Bun adds to bashrc or zshrc)
echo "Reloading shell configuration..."
source ~/.bashrc 2>/dev/null || source ~/.zshrc 2>/dev/null

# Install Bun packages
echo "Installing Bun dependencies..."
bun install

echo "🎉 Post-installation setup complete!"
