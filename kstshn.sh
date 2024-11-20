#!/bin/bash

# Function to add lines to .bashrc
add_to_file() {
  local file="/home/kstshn/$1"
  local line="$2"

  # Check if the line already exists to prevent duplicates
  if ! grep -qxF "$line" "$file"; then
    echo "$line" >>"$file"
    echo "Added '$line' to $file"
  else
    echo "Line '$line' already exists in $file"
  fi
}

# Function to install packages
install_packages() {
  echo "Updating package list..."
  sudo apt update

  echo "Installing required packages..."
  local packages=("git" "fzf") # Add your desired packages here
  sudo apt install -y "${packages[@]}"

  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  add_to_file .bashrc "eval "$(zoxide init --cmd cd bash)""

  source "/home/kstshn/.bashrc"

  echo "Installing bun..."
  curl -fsSL https://bun.sh/install | bash
  echo "Packages installed successfully."

  # nvim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
}
# Installing packages
install_packages

# Adding lines to .bashrc
# fzf
add_to_file ".bashrc" "[ -f /home/kstshn/.fzf.bash ] && source ~/.fzf.bash"

# nvim
add_to_file ".bashrc" 'export PATH="$PATH:/opt/nvim-linux64/bin\"'

# bun
add_to_file ".bashrc" 'export BUN_INSTALL="/home/kstshn/.bun"'
add_to_file ".bashrc" "export PATH=$BUN_INSTALL/bin:$PATH"

# nvim settings
mkdir "/home/kstshn/.config"
mkdir "/home/kstshn/.config/nvim"
git clone https://github.com/oakward/nvim.git /home/kstshn/.config/nvim

# Aliases
add_to_file ".bash_aliases" "alias b=bun"
add_to_file ".bash_aliases" "alias la='ls -a'"

# Apply changes to .bashrc
echo "Applying changes to bashrc..."
source "/home/kstshn/.bashrc"

echo "Script execution completed!"
