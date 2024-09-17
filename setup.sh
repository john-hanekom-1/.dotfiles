#!/bin/bash
# Created by: John Hanekom
# Created on: Sept 2024
# setup.sh file

set -e  # Exit immediately on non-zero exit code

# Update and upgrade system packages (using apt)
echo "Updating and upgrading system..."
sudo apt update && sudo apt full-upgrade -y

# Install nala
echo "Installing nala..."
sudo apt install nala -y

# Use nala to update and upgrade
sudo nala update && sudo nala upgrade -y

# Remove w3m
echo "Removing w3m..."
sudo nala remove w3m -y

# Install additional tools
echo "Installing stow, neofetch, git, and gh..."
sudo nala install stow neofetch git gh -y

# Install fzf from source
echo "Installing fzf..."
git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --update-rc

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
curl --proto https https://sh.rustup.rs -sSf | sh -s -- --default-toolchain none

# Install nushell, zoxide, and oh-my-posh
source ~/.bashrc  # Ensure rustup is loaded
source ~/.cargo/env
echo "Installing nushell dependencies..."
sudo nala install pkg-config libssl-dev build-essential -y
echo "Installing nushell..."
cargo install nu
echo "Initializing nushell..."
nu
exit
echo "Installing zoxide and oh-my-posh..."
cargo install zoxide
curl -s https://ohmyposh.dev/install.sh | bash -s

# Configure oh-my-posh with JetBrains Mono font and agnosterplus theme
echo "Configuring oh-my-posh..."
export PATH=$PATH:/home/johnh/.local/bin
oh-my-posh font install JetBrainsMono
echo -e "\neval \"\$(oh-my-posh init bash)\"" >> ~/.bashrc
exec bash
oh-my-posh init bash --config 'https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/agnosterplus.omp.json'
oh-my-posh init nu --config 'https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/agnosterplus.omp.json'

# Add Aliases to .bashrc and Nushell config
echo "adding aliases..."
echo -e "\nsource ~/.bashrc_aliases" >> ~/.bashrc
echo -e "\nsource ~/.nu_aliases.nu" >> ~/.config/nushell/config.nu

# Final step
source ~/.bashrc

echo "Setup complete!"
