#!/bin/bash
# Created by: John Hanekom
# Created on: Sept 2024
# setup.sh file

set -e  # Exit immediately on non-zero exit code

# Update and upgrade system packages (using apt)
echo "Updating and upgrading system..."
sudo apt update && sudo apt upgrade -y

# Install nala
echo "Installing nala..."
sudo apt install nala -y

# Use nala to update and upgrade
nala update && nala upgrade -y

# Remove w3m
echo "Removing w3m..."
sudo nala remove w3m -y

# Install additional tools
echo "Installing stow, neofetch, git, and gh..."
sudo nala install stow neofetch git gh -y

# Install fzf from source
echo "Installing fzf..."
git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Install NeoVim from source
echo "Installing NeoVim dependencies..."
sudo nala install ninja-build gettext cmake unzip curl build-essential -y
echo "Installing NeoVim..."
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..

# Install Bun and Java
echo "Installing Bun and Java..."
curl https://setup.bun.sh | bash
sudo nala install default-jdk -y

# Install Rust via rustup
echo "Installing Rust..."
curl --proto https https://sh.rustup.rs -sSf | sh
source ~/.bashrc

# Install zoxide, nushell, and oh-my-posh
echo "Installing zoxide, nushell, and oh-my-posh..."
source ~/.bashrc  # Ensure rustup is loaded
cargo install zoxide
curl -L https://install.nushell.sh | sh
curl -L https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/master/installer.sh | sh

# Configure oh-my-posh with JetBrains Mono font and agnosterplus theme
echo "Configuring oh-my-posh..."
omp theme agnosterplus
omp font install JetBrainsMono

# Add Aliases to .bashrc and Nushell config
echo -e "\nsource ~/.bashrc_aliases" >> ~/.bashrc
echo -e "\nsource ~/.nu_aliases.nu" >> ~/.config/nushell/config.nu

# Reload bash profile to apply oh-my-posh configuration
source ~/.bashrc

echo "Setup complete!"
