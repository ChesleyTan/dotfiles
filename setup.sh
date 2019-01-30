#!/bin/bash
SCRIPT_DIR="$(dirname $(realpath "$0"))"
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
        ln -s $SCRIPT_DIR/vimrc $HOME/.vimrc
        printf "${GREEN}Linked ~/.vimrc${RESET}\n"
        ln -s $SCRIPT_DIR/vim $HOME/.vim
        printf "${GREEN}Linked ~/.vim/${RESET}\n"
    fi
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
    if [[ -a ~/.emacs.d/ ]]; then
        printf "${RED}~/.emacs.d/ already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/emacs.d $HOME/.emacs.d
        printf "${GREEN}Linked ~/.emacs.d/${RESET}\n"
    fi
fi

echo "Using GNU readline? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.inputrc ]]; then
        printf "${RED}~/.inputrc already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/inputrc $HOME/.inputrc
        printf "${GREEN}Linked ~/.inputrc${RESET}\n"
    fi
fi

echo "Using bash? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.bashrc ]]; then
        printf "${RED}~/.bashrc already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/bashrc $HOME/.bashrc
        printf "${GREEN}Linked ~/.bashrc${RESET}\n"
    fi
fi

echo "Using zsh? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.zshrc ]]; then
        printf "${RED}~/.zshrc already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/zshrc $HOME/.zshrc
        printf "${GREEN}Linked ~/.zshrc${RESET}\n"
    fi
    if [[ -a ~/.zsh/ ]]; then
        printf "${RED}~/.zsh/ already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/include/zsh $HOME/.zsh
        printf "${GREEN}Linked ~/.zsh/${RESET}\n"
        echo "Updating submodules...."
        git submodule init
        git submodule update
    fi
fi

echo "Using tmux? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.tmux.conf ]]; then
        printf "${RED}~/.tmux.conf already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/tmux.conf $HOME/.tmux.conf
        printf "${GREEN}Linked ~/.tmux.conf${RESET}\n"
    fi
    if [[ -a ~/.tmux/ ]]; then
        printf "${RED}~/.tmux/ already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/include/tmux $HOME/.tmux
        printf "${GREEN}Linked ~/.tmux/${RESET}\n"
        echo "Updating submodules...."
        git submodule init
        git submodule update
    fi
fi

echo "Using xmobar for system info? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.xmobarrc_bottom ]]; then
        printf "${RED}~/.xmobarrc_bottom already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/xmobarrc_bottom $HOME/.xmobarrc_bottom
        printf "${GREEN}Linked ~/.xmobarrc_bottom${RESET}\n"
    fi
fi

echo "Using xmobar for xmonad integration? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.xmobarrc_top ]]; then
        printf "${RED}~/.xmobarrc_top already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/xmobarrc_top $HOME/.xmobarrc_top
        printf "${GREEN}Linked ~/.xmobarrc_top${RESET}\n"
    fi
fi

echo "Using xmonad (y/n)"
read ans
if [[ $ans == "y" ]]; then
    if [[ -a ~/.xmonad/ ]]; then
        printf "${RED}~/.xmonad/ already exists!${RESET}\n"
    else
        ln -s $SCRIPT_DIR/xmonad $HOME/.xmonad
        printf "${GREEN}Linked ~/.xmonad/${RESET}\n"
    fi
fi

echo "Using fzf? (y/n)"
read ans
if [[ $ans == "y" ]]; then
    git submodule init
    git submodule update
    $SCRIPT_DIR/include/fzf/install
    printf "${GREEN}Installed fzf${RESET}\n"
fi

