#!/usr/bin/env bash

# Created by: John Hanekom
# Created on: Sept 2024
# setup.sh file

# Setup a safe Bash scripting environment

set -o errexit # Exit immediately on non-zero exit code
set -o noclobber # Prevent files being deleted unless forced
set -o nounset # Can't remember what this does
set -o pipefail # Do not wait for piped commands to fail before failing

IFS=$'\n\r' # Set the input field separator
PATH="$(getconf PATH)"; export PATH

command unalias -a # Remove any aliases
hash -r # Clear the hashed command paths
# Set the default file permissions to user and group read/write/execute, etc.
umask 002

# Update and upgrade system packages (using apt)
echo "Updating and upgrading system..."
sudo apt update && sudo apt full-upgrade -y

# Install nala
echo "Installing nala..."
sudo apt install nala -y

# Use nala to update and upgrade
sudo nala upgrade --update -y

# Remove w3m
  echo "Removing w3m..."
if type -t w3m; then
  sudo nala remove w3m -y
else
  echo 'w3m did not need to be removed'
fi

# Install additional tools
echo "Installing additional tools..."
for f in 'build-essential' 'cmake' 'curl' 'default-jdk' 'gettext' \
    'git' 'git-lfs' 'gh' 'libssl-dev' 'neofetch' 'pkg-config' \
    'stow' 'unzip'; do
  if ! type -t "$f"; then
    sudo nala install "$f" -y
  else
    echo "$f already installed"
  fi
done

# Install fzf from source
echo "Installing fzf..."
if [[ -e ~/.fzf ]]; then
  echo '~/.fzf found so fzf not reinstalled'
else
  git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --key-bindings --completion --update-rc
fi

# Install NeoVim from source
echo "Installing NeoVim dependencies..."
if type -t ninja-build; then
  echo 'ninja-build already installed'
else
  sudo nala install ninja-build -y
  sudo nala upgrade --update -y
fi

echo "Installing NeoVim..."
if [[ -e '~/neovim' ]]; then
  echo '~/neovim found so fzf not reinstalled'
else
  git clone https://github.com/neovim/neovim
  (
    cd neovim
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
  )
fi

# Install Deno
echo "Installing Deno..."
# TODO do no do this if deno already installed
  curl -fsSL https://deno.land/install.sh | sh
  deno upgrade
  deno upgrade rc
  sudo nala upgrade --update -y


# Install Rust via rustup
echo "Installing Rust..."
if [[ -e '~/.cargo' ]]; then
  echo '~/.cargo found so rustup not reinstalled'
else
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  source ~/.cargo/env # Setup the Rust and Cargo environment
fi

# Install nushell, zoxide, and oh-my-posh
# source ~/.bashrc
echo "Installing nushell..."
if type -t nu; then
  echo 'nu already installed'
else
  cargo install nu
  echo -e "y\ny\n" | nu || true
fi
# exit

echo "Installing zoxide..."
if type -t zoxide; then
  echo 'zoxide already installed'
else
  cargo install zoxide
fi

echo 'Installing oh-my-posh...'
if type -t ohmyposh; then
  echo 'oh-my-posh already installed'
else
  curl -s https://ohmyposh.dev/install.sh | bash -s
fi

# Configure oh-my-posh with JetBrains Mono font and agnosterplus theme
echo "Configuring oh-my-posh..."
export PATH=$PATH:/home/johnh/.local/bin
# change this
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
