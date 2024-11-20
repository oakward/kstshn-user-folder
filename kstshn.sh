#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

# Function to add lines to .bashrc
add_to_file() {
  local file="$HOME/$1"
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
  apt update

  echo "Installing required packages..."
  local packages=("git" "fzf") # Add your desired packages here
  apt install -y "${packages[@]}"

  echo "Installing zoxide..."
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  add_to_file .bashrc "eval "$(zoxide init --cmd cd bash)""

  source "$HOME/.bashrc"

  echo "Installing bun..."
  curl -fsSL https://bun.sh/install | bash
  echo "Packages installed successfully."
}
# Installing packages
install_packages

# Adding lines to .bashrc
add_to_file .bashrc "[ -f ~/.fzf.bash ] && source ~/.fzf.bash"
add_to_file .bashrc "export BUN_INSTALL="$HOME/.bun""
add_to_file .bashrc "export PATH=$BUN_INSTALL/bin:$PATH"
add_to_file .bash_aliases "alias b=bun"

# Apply changes to .bashrc
echo "Applying changes to bashrc..."
source "$HOME/.bashrc"

echo "Script execution completed!"
