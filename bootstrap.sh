#!/bin/bash
# Create symlinks and replace old files

# Define variables
OS="$(cat /etc/os-release | grep -E "^ID=" | cut -d= -f2- | tr -d '"')"

# Define functions
move_and_link_file(){
    # Define variables
    file="$1"
    folder="$HOME/.dotfiles.old"
    file_replace=$(basename $file)

    # Check if file exsists
    if [[ -e "$file" ]]; then

        # Check if folder exists, create it if it doesn't
        if [[ ! -d "$folder" ]]; then
            mkdir "$folder"
        fi

        # Move file to folder
        mv "$file" "$folder"
    fi
    # Link repo-file to file location
    ln -s "$(pwd)/$file_replace" $file

}

# Manjaro
if [[ "$OS" == "manjaro" ]]; then
    # zshrc
    move_and_link_file $HOME/.zshrc

fi

# Ubuntu
if [[ "$OS" == "ubuntu" ]]; then
    # bashrc
    move_and_link_file $HOME/.bashrc
fi

if command -v vim >/dev/null 2>&1; then
  move_and_link_file $HOME/.vimrc
  # Add for sudoedits
  sudo ln -s "$(pwd)/.vimrc" /root/.vimrc
else
  echo "Vim is not installed"
fi

