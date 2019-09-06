#!/bin/bash
SCRIPT_DIR="$(dirname $(realpath "$0"))"
# ANSI Escape Codes
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[m"

backup_if_exists() {
    if [[ -a "$1" ]]; then
        printf "${RED}${1} already exists! Backing it up...${RESET}\n"
        mv "$1" "$1.bak"
    fi
}

update_submodules() {
    echo "Updating submodules...."
    git submodule init
    git submodule update
}

echo "Using vim? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    backup_if_exists ~/.vimrc
    backup_if_exists ~/.vim/
    ln -s $SCRIPT_DIR/vimrc ~/.vimrc
    printf "${GREEN}Linked ~/.vimrc${RESET}\n"
    ln -s $SCRIPT_DIR/vim ~/.vim
    printf "${GREEN}Linked ~/.vim/${RESET}\n"
fi

echo "Using nvim? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    ln -s ~/.vim ~/.config/nvim
    printf "${GREEN}Linked ~/.vim/${RESET}\n"
    ln -s ~/.vimrc ~/.config/nvim/init.vim
    printf "${GREEN}Linked ~/.vimrc${RESET}\n"
    mkdir -p ~/.local/share/nvim/shada
fi


echo "Using emacs? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    backup_if_exists ~/.emacs.d/
    ln -s $SCRIPT_DIR/emacs.d ~/.emacs.d
    printf "${GREEN}Linked ~/.emacs.d/${RESET}\n"
fi

echo "Using GNU readline? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    backup_if_exists ~/.inputrc
    ln -s $SCRIPT_DIR/inputrc ~/.inputrc
    printf "${GREEN}Linked ~/.inputrc${RESET}\n"
fi

echo "Using bash? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    backup_if_exists ~/.bashrc
    ln -s $SCRIPT_DIR/bashrc ~/.bashrc
    printf "${GREEN}Linked ~/.bashrc${RESET}\n"
fi

echo "Using zsh? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    backup_if_exists ~/.zshrc
    ln -s $SCRIPT_DIR/zshrc ~/.zshrc
    printf "${GREEN}Linked ~/.zshrc${RESET}\n"

    backup_if_exists ~/.zsh
    ln -s $SCRIPT_DIR/include/zsh ~/.zsh
    printf "${GREEN}Linked ~/.zsh/${RESET}\n"

    update_submodules
fi

echo "Using tmux? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    backup_if_exists ~/.tmux.conf
    ln -s $SCRIPT_DIR/tmux.conf ~/.tmux.conf
    printf "${GREEN}Linked ~/.tmux.conf${RESET}\n"

    backup_if_exists ~/.tmux/
    ln -s $SCRIPT_DIR/include/tmux ~/.tmux
    printf "${GREEN}Linked ~/.tmux/${RESET}\n"

    update_submodules
fi

echo "Using xmobar for system info? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    backup_if_exists ~/.xmobarrc_bottom
    ln -s $SCRIPT_DIR/xmobarrc_bottom ~/.xmobarrc_bottom
    printf "${GREEN}Linked ~/.xmobarrc_bottom${RESET}\n"
fi

echo "Using xmobar for xmonad integration? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    backup_if_exists ~/.xmobarrc_top
    ln -s $SCRIPT_DIR/xmobarrc_top ~/.xmobarrc_top
    printf "${GREEN}Linked ~/.xmobarrc_top${RESET}\n"
fi

echo "Using xmonad (y/n)"
read ans
if [[ $ans == "y" ]]; then
    backup_if_exists ~/.xmonad/
    ln -s $SCRIPT_DIR/xmonad ~/.xmonad
    printf "${GREEN}Linked ~/.xmonad/${RESET}\n"
fi

echo "Using fzf? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    update_submodules
    $SCRIPT_DIR/include/fzf/install
    printf "${GREEN}Installed fzf${RESET}\n"
fi

