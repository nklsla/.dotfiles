#!/bin/bash
# Create symlinks and replace old files

set -euo pipefail

# --------------------------------------------------
# Resolve base directory (directory of this script)
# --------------------------------------------------
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/.dotfiles.old"

# --------------------------------------------------
# Get distro
# --------------------------------------------------
dist="$(grep -E '^ID=' /etc/os-release | cut -d= -f2- | tr -d '"')"

# --------------------------------------------------
# Functions
# --------------------------------------------------
move_and_link_file() {
    local target_file="$1"
    local filename
    filename="$(basename "$target_file")"
    local source_file="$SCRIPT_DIR/$filename"

    # Sanity check: source file must exist
    if [[ ! -e "$source_file" ]]; then
        echo "Source file not found: $source_file"
        return 1
    fi
    
    # Ensure parent directory exists
    mkdir -p "$(dirname "$target_file")"

    # Backup existing target
    if [[ -e "$target_file" || -L "$target_file" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target_file" "$BACKUP_DIR/"
    fi

    # Create symlink
    ln -sfn "$source_file" "$target_file"
}

# --------------------------------------------------
# Distro-specific logic
# --------------------------------------------------

# Manjaro
if [[ "$dist" == "manjaro" ]]; then
    move_and_link_file "$HOME/.zshrc"
fi

# Ubuntu
if [[ "$dist" == "ubuntu" ]]; then
    move_and_link_file "$HOME/.bashrc"
    move_and_link_file "$HOME/.Xmodmap"
fi

# Fish
if command -v fish >/dev/null 2>&1; then
  move_and_link_file "$HOME/.config/fish/config.fish"
else
  echo "Fish is not installed!"
fi

# Vim
if command -v vim >/dev/null 2>&1; then
    move_and_link_file "$HOME/.vimrc"

    # Root vimrc (idempotent)
    sudo ln -sfn "$SCRIPT_DIR/.vimrc" /root/.vimrc
else
    echo "Vim is not installed!"
fi
