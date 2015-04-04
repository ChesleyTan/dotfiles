#!/bin/bash
PWD=$(pwd)
# ANSI Escape Codes
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[m"

echo "Using vim? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.vimrc ]]; then
        printf "${RED}~/.vimrc already exists!${RESET}\n"
    elif [[ -a ~/.vim/ ]]; then
        printf "${RED}~/.vim/ already exists!${RESET}\n"
    else
        ln -s $PWD/vimrc $HOME/.vimrc
        printf "${GREEN}Linked ~/.vimrc${RESET}\n"
        ln -s $PWD/vim $HOME/.vim
        printf "${GREEN}Linked ~/.vim/${RESET}\n"
    fi
fi

echo "Using emacs? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.emacs.d/ ]]; then
        printf "${RED}~/.emacs.d/ already exists!${RESET}\n"
    else
        ln -s $PWD/emacs.d $HOME/.emacs.d
        printf "${GREEN}Linked ~/.emacs.d/${RESET}\n"
    fi
fi

echo "Using GNU readline? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.inputrc ]]; then
        printf "${RED}~/.inputrc already exists!${RESET}\n"
    else
        ln -s $PWD/inputrc $HOME/.inputrc
        printf "${GREEN}Linked ~/.inputrc${RESET}\n"
    fi
fi

echo "Using bash? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.bashrc ]]; then
        printf "${RED}~/.bashrc already exists!${RESET}\n"
    else
        ln -s $PWD/bashrc $HOME/.bashrc
        printf "${GREEN}Linked ~/.bashrc${RESET}\n"
    fi
fi

echo "Using zsh? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.zshrc ]]; then
        printf "${RED}~/.zshrc already exists!${RESET}\n"
    elif [[ -a ~/.zsh/ ]]; then
        printf "${RED}~/.zsh/ already exists!${RESET}\n"
    else
        ln -s $PWD/zshrc $HOME/.zshrc
        printf "${GREEN}Linked ~/.zshrc${RESET}\n"
        ln -s $PWD/zsh $HOME/.zsh
        printf "${GREEN}Linked ~/.zsh/${RESET}\n"
    fi
fi

echo "Using tmux? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.tmux.conf ]]; then
        printf "${RED}~/.tmux.conf already exists!${RESET}\n"
    else
        ln -s $PWD/tmux.conf $HOME/.tmux.conf
        printf "${GREEN}Linked ~/.tmux.conf${RESET}\n"
    fi
fi

echo "Using xmobar for system info? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.xmobarrc_bottom ]]; then
        printf "${RED}~/.xmobarrc_bottom already exists!${RESET}\n"
    else
        ln -s $PWD/xmobarrc_bottom $HOME/.xmobarrc_bottom
        printf "${GREEN}Linked ~/.xmobarrc_bottom${RESET}\n"
    fi
fi

echo "Using xmobar for xmonad integration? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.xmobarrc_top ]]; then
        printf "${RED}~/.xmobarrc_top already exists!${RESET}\n"
    else
        ln -s $PWD/xmobarrc_top $HOME/.xmobarrc_top
        printf "${GREEN}Linked ~/.xmobarrc_top${RESET}\n"
    fi
fi

echo "Using xmonad (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.xmonad/ ]]; then
        printf "${RED}~/.xmonad/ already exists!${RESET}\n"
    else
        ln -s $PWD/xmonad $HOME/.xmonad
        printf "${GREEN}Linked ~/.xmonad/${RESET}\n"
    fi
fi