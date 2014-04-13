# General Configuration {{{
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Color support {{{
# Force color in terminal 
if [ -n "$DISPLAY" -a "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
elif [ "$TERM" == "screen" ]; then
	export TERM=screen-256color
fi
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# }}}
# }}}
# Custom Bash Prompt {{{

function SensorTemp() { 
	# Note on usage 1: you must prepend an escape character onto $(SensorTemp) so the prompt dynamically updates the temperature
	# Note on usage 2: modify the arguments for head and tail to select a specific temperature in the output 
	if [ $showSysInfo == true ]; then
        echo "<$(sensors | grep -Eo '[0-9][0-9]\.[0-9]°C' | head -1) | "
    fi
}
function GitBranch() {
	# Note on usage 1: you must prepend an escape character onto $(SensorTemp) so the prompt dynamically updates the temperature
    if [[ ! $(git status 2>&1) =~ "fatal" ]]; then
        echo " $(tput setaf 34)($(git branch | grep '*' | grep -o ' '[A-Za-z]* | cut -c2-) $(GitUpToDate))$(tput sgr0)" # Extracts current git branch using grep and regexes and using cut to remove preceding space
	fi
}
function GitUpToDate() {
    if [[ $(git status) =~ "Changes to be committed" ]]; then
        echo -e "\u2718"
    else
        echo -e "\u2714"
    fi
}
function ramUsage() {
	if [ $showSysInfo == true ]; then
	    echo "$(free -m | grep -Eo '[0-9]*' | head -7 | tail -1) MB | "
    fi
}
function batteryInfo() {
	if [ $showSysInfo == true ]; then
        data=$(acpi | grep -Eo "[0-9]*%|[0-9][0-9]:[0-9][0-9]:[0-9][0-9]")
        perc=$(echo $data | grep -Eo "[0-9]*%")
        batTime=$(echo $data | grep -Eo "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]")
        if [ "$batTime" == "" ]; then
            batTime="Full"
        fi
        echo "$perc ($batTime)> "
    fi
}
function CatchExitCode() {
    status=$?
}
function Sign() {
    if [ $UID == 0 ]; then
        echo "$(tput setaf 196) #"
    else
        if [[ $status == 0 ]]; then
            echo "$(tput setaf 15) $"
        else
            echo "$(tput setaf 196) $"
        fi
    fi
}

# Store last exit status code before generating a prompt
status=0
PROMPT_COMMAND="CatchExitCode"
############ Regular Prompt ###############
prompt1="\[$(tput bold)\]\[$(tput setaf 1)\][\D{%I:%M %P}] \[$(tput setaf 166)\]\[\$(SensorTemp)\]\$(ramUsage)\$(batteryInfo)\[$(tput setaf 2)\]\\u:\[$(tput setaf 6)\]\\w\$(GitBranch)\[$(tput setaf 4)\]\[\$(Sign)\]\[$(tput sgr0)\] \n>> "
### 256 color version ###
prompt2="\[$(tput bold)\]\[$(tput setaf 196)\][\D{%I:%M %P}] \[$(tput setaf 166)\]\$(SensorTemp)\$(ramUsage)\$(batteryInfo)\[$(tput setaf 118)\]\\u:\[$(tput setaf 39)\]\\w\$(GitBranch)\[$(tput setaf 15)\]\[\$(Sign)\]\[$(tput sgr0)\] \n>> "
############ Prompt With Hostname ###############
##prompt3="\[$(tput bold)\]\[$(tput setaf 1)\][\D{%I:%M %P}] \[$(tput setaf 2)\]\\u@\H:\[$(tput setaf 6)\]\\w\[$(tput setaf 4)\]\[\$(Sign)\]\[$(tput sgr0)\] "
### 256 color version ###
prompt4="\[$(tput bold)\]\[$(tput setaf 196)\][\D{%I:%M %P}] \[$(tput setaf 166)\]\$(SensorTemp)\$(ramUsage)\$(batteryInfo)\[$(tput setaf 118)\]\\u\[$(tput setaf 243)\]@\H:\[$(tput setaf 39)\]\\w\$(GitBranch)\[$(tput setaf 15)\]\[\$(Sign)\]\[$(tput sgr0)\] \n>> "

if [ "$TERM" == "linux" ]; then
	export PS1=$prompt1
else
	export PS1=$prompt2
fi

export showSysInfo=true
alias syson="export showSysInfo=true"
alias sysoff="export showSysInfo=false"

# }}}
# Custom xterm Title {{{
case "$TERM" in
xterm*)
    PS1="\[\e]0;[\u@\h]: \w\a\]$PS1"
    # Note \e expands to ASCII escape \033 and \a expands to ASCII bell \007
    ;;
*)
    ;;
esac
# }}}
# Global functions {{{
function back() {
    eval cd $(echo $OLDPWD | sed -r 's/[ ]+/\\ /g')
}
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
# }}}
# Global aliases {{{
#alias sudo='sudo ' # Allow use sudo on aliases because aliases are only checked on the first word in the command
alias ll='ls -alF'
alias la='ls -A'
alias lh='ls -ahl'
alias l='ls -CF'
alias rm='rm -I'
# }}}
# Local aliases {{{
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# }}}
# Bash completion {{{
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# }}}
# vim:fdm=marker
