# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=yes;;
#esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes
#
#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#	# We have color support; assume it's compliant with Ecma-48
#	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#	# a case would tend to support setf rather than setaf.)
#	color_prompt=yes
#    else
#	color_prompt=
#    fi
#fi

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# Recognize color support in terminal
if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
elif [ "$TERM" == "screen" ]; then
	export TERM=screen-256color
fi

############ Custom Bash Prompt ###############

function SensorTemp(){ 
	# Note on usage 1: you must prepend an escape character onto $(SensorTemp) so the prompt dynamically updates the temperature
	# Note on usage 2: modify the arguments for head and tail to select a specific temperature in the output 
	echo "$(sensors | grep -Eo '[0-9][0-9]\.[0-9]°C' | head -3 | tail -1)"
}
function GitBranch(){
	# Note on usage 1: you must prepend an escape character onto $(SensorTemp) so the prompt dynamically updates the temperature
	if [ -d ".git" ]; then # Checks if .git/ directory exists
		echo " $(tput setaf 34)($(git branch | grep '*' | grep -o ' '[A-Za-z]* | cut -c2-))$(tput sgr0)" # Extracts current git branch using grep and regexes and using cut to remove preceding space
	fi
}


#PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\@] \[$(tput setaf 2)\]\\u:\[$(tput setaf 6)\]\\w\[$(tput setaf 4)\] $\[$(tput sgr0)\] "
### 256 color version ###
PS1="\[$(tput bold)\]\[$(tput setaf 196)\][\@] \[$(tput setaf 166)\]<\[\$(SensorTemp)\]> \[$(tput setaf 118)\]\\u:\[$(tput setaf 39)\]\\w\$(GitBranch)\[$(tput setaf 15)\] $\[$(tput sgr0)\] "
############ Prompt With Hostname ###############
#PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\@] \[$(tput setaf 2)\]\\u@\H:\[$(tput setaf 6)\]\\w\[$(tput setaf 4)\] $\[$(tput sgr0)\] "
### 256 color version ###
#PS1="\[$(tput bold)\]\[$(tput setaf 196)\][\@] \[$(tput setaf 118)\]\\u\[$(tput setaf 243)\]@\H:\[$(tput setaf 39)\]\\w\[$(tput setaf 15)\] $\[$(tput sgr0)\] "

###############################################
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

function clearapachelog(){
	if [ "$(id -u)" != "0" ]; then
   		echo "This script must be run as root" 
	else
		echo "" > /var/log/apache2/error.log
	fi
}
function removeClassFiles(){
	if [ $# == 0 ]; then
		echo "No arguments given. Aborted."
	elif [ $# != 1 ]; then
		echo "Too many arguments."
	else
		files=$(find $1 | grep '.class')
		if [[ $files == "" ]]; then
			echo "No files to remove"
			return
		fi
		echo "Files to be removed:"
		echo "$files"
		echo "Are you sure want to delete these files? [y/n]"
		read ans
		if [ $ans == "y" ]; then
			rm -v $files
			echo "Files removed."
		else
			echo "Removal aborted."
		fi
	fi
}
# some more ls aliases
#alias sudo='sudo ' # Allow use sudo on aliases because aliases are only checked on the first word in the command
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -I'
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

function reminder(){
	PS1="$PS1\[$(tput setaf 7)\](Reminder: " # Add space to PS1, change text color
	for word in "$@"
	do
		PS1="$PS1$word "
	done
	PS1="${PS1:0:$[${#PS1}-1]})\[$(tput sgr0)\] " # Remove trailing space, reset font color, add close parentheses
	echo "Reminder set: $@"
}
function sourcebash(){
	source ~/.bashrc
}

