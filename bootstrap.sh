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
    local source_file="$2"
    local target_name="${3:-$(basename "$target_file")}"

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
        sudo mv "$target_file" "$BACKUP_DIR/"
    fi

    # Create symlink
    sudo ln -sfn "$source_file" "$target_file"
    echo "Linked $source_file -> $target_file"
}

install_keyd() {
    if command -v keyd >/dev/null 2>&1; then
        echo "keyd already installed"
        return
    fi

    # Try APT first
    if command -v apt >/dev/null 2>&1 && apt list keyd >/dev/null 2>&1; then
        echo "Installing keyd via apt"
        sudo apt update
        sudo apt install -y keyd
        return
    fi

    # Otherwise, build from upstream
    echo "Installing keyd from source"
    tmpdir="$(mktemp -d)"
    git clone https://github.com/rvaiya/keyd.git "$tmpdir/keyd"
    pushd "$tmpdir/keyd"
    make
    sudo make install
    popd
    rm -rf "$tmpdir"

    sudo systemctl enable --now keyd
}

# --------------------------------------------------
# Distro-specific logic
# --------------------------------------------------

# Manjaro
if [[ "$dist" == "manjaro" ]]; then
    move_and_link_file "$HOME/.zshrc" "$SCRIPT_DIR/.zshrc"
fi

# Ubuntu
if [[ "$dist" == "ubuntu" ]]; then
    move_and_link_file "$HOME/.bashrc" "$SCRIPT_DIR/.bashrc"
fi

# Fish
if command -v fish >/dev/null 2>&1; then
  move_and_link_file "$HOME/.config/fish/config.fish" "$SCRIPT_DIR/config.fish"
else
  echo "Fish is not installed!"
fi

# Vim
if command -v vim >/dev/null 2>&1; then
    move_and_link_file "$HOME/.vimrc" "$SCRIPT_DIR/.vimrc"

    # Root vimrc 
    move_and_link_file /root/.vimrc "$SCRIPT_DIR/.vimrc"
else
    echo "Vim is not installed!"
fi

# Wayland + keyd, remapping caps lock -> end
if [[ "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
    echo "Wayland detected, installing keyd if needed"
    install_keyd
    sudo mkdir -p /etc/keyd
    move_and_link_file "/etc/keyd/default.conf" "$SCRIPT_DIR/keyd.conf"
fi

