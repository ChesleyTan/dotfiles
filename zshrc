# General configuration {{{
# vim:fdm=marker

ZSH=~/.zsh

HIST_STAMPS="mm/dd/yyyy"
HISTFILE=~/.zsh_history
HISTSIZE=99999
SAVEHIST=99999
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# User configuration

export PATH="${PATH}:/bin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/vendor_perl:/usr/bin/core_perl"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

if hash nvim 2> /dev/null; then
    export EDITOR="nvim"
else
    export EDITOR="vim"
fi

setopt AUTO_CD
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt PUSHD_SILENT
setopt PUSHD_TO_HOME
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt ZLE
setopt VI
unsetopt EQUALS

# use cache when auto-completing
zstyle ':completion::complete:*' use-cache 1
# use case-insensitive auto-completing
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# graphical auto-complete menu
zstyle ':completion:*' menu select

# use automatic path prediction
# $predict-on to turn on and $predict-off to turn off
autoload predict-on
autoload predict-off
# use advanced completion system
autoload -U compinit && compinit

# Enable vi mode
bindkey -v

# Enable command line edit with v
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Plugin configuration {{{
if [[ "$ZSH_SYNTAX_HIGHLIGHTING_PLUGIN" == "" ]]; then
    source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_SYNTAX_HIGHLIGHTING_PLUGIN=1
fi
if [[ "$ZSH_AUTOSUGGESTIONS_PLUGIN" = "" ]]; then
    source $ZSH/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
    ZSH_AUTOSUGGESTIONS_PLUGIN=1
fi

# }}}

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

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=01;92:st=37;44:ex=01;04:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
export LS_COLORS

# }}}
# }}}
# Custom Prompt {{{

function GitBranch() {
# Note on usage 1: you must prepend an escape character onto $(SensorTemp) so the prompt dynamically updates the temperature
    if [[ ! $(git status 2>&1) =~ "fatal" ]]; then
        echo " $(tput bold)$(tput setaf 34)($(git branch | grep '* ' | cut -c3-) $(GitUpToDate)$(GitStashLength))$(tput sgr0)" # Extracts current git branch using grep and regexes
    fi
}
function GitUpToDate() {
    gitStatus=$(git status)
    if [[ $gitStatus =~ "Changes to be committed" ]]; then
        echo -ne "\u2718" # unicode character cross
    else
        echo -ne "\u2714" # unicode character check
    fi
    if [[ $gitStatus =~ "Changes not staged for commit" ]]; then
        echo -ne " \u0394" # unicode character delta
    fi
    echo -ne "\n"
}
function GitStashLength() {
    gitStashLength=$(git stash list | wc -l)
    if [[ "$gitStashLength" != "0" ]]; then
        echo -ne " \u26c1 $gitStashLength\n"
    else
        echo -ne ""
    fi
}
function SensorTemp() {
# Note on usage 1: you must prepend an escape character onto $(SensorTemp) so the prompt dynamically updates the temperature
# Note on usage 2: modify the arguments for head and tail to select a specific temperature in the output
    if [ $showSysInfo == true ]; then
        echo "$(tput bold)$(tput setaf 166)<$(sensors | grep -Eo '[0-9][0-9]\.[0-9]°C' | head -1) | $(tput sgr0)"
    fi
}
function ramUsage() {
    if [[ $showSysInfo == true ]]; then
        echo "$(tput bold)$(tput setaf 166)$(free -m | grep -Eo '[0-9]*' | head -6 | tail -1) MB | $(tput sgr0)"
    fi
}
function batteryInfo() {
    if [[ $showSysInfo == true ]]; then
        data=$(acpi | grep -Eo "[0-9]*%|[0-9][0-9]:[0-9][0-9]:[0-9][0-9]")
        perc=$(echo $data | grep -Eo "[0-9]*%")
        batTime=$(echo $data | grep -Eo "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]")
        if [ "$batTime" == "" ]; then
            batTime="Full"
        fi
        echo "$(tput bold)$(tput setaf 166)$perc% ($batTime)> $(tput sgr0)"
    fi
}
function CatchExitCode() {
    exitStatus=$?
}
function Sign() {
    if [[ $UID == 0 ]]; then
        echo "$(tput bold)$(tput setaf 9) #$(tput sgr0)"
    else
        if [[ $exitStatus == 0 ]]; then
            echo "$(tput bold)$(tput setaf 15) \$$(tput sgr0)"
        else
            echo "$(tput bold)$(tput setaf 9) \$$(tput sgr0)"
        fi
    fi
}
function Pwd() {
    if [[ $is256ColorTerm == true ]]; then
        color=39
    else
        color=6
    fi
    echo -n "$(tput bold)$(tput setaf $color)"
    if [[ $shortenPath == true ]]; then
        echo -n "$PWD" | sed -r "s|$HOME|~|g" | sed -r "s|/(.)[^/]*|/\1|g" # (.) holds the first letter and \1 recalls it
    else
        echo -n "$PWD" | sed -r "s|$HOME|~|g"
    fi
    echo "$(tput sgr0)"
}
function DateTime() {
    if [[ $showTime != true ]]; then
        return
    fi
    date=$(date "+%I:%M %P")
    if [[ $is256ColorTerm == false ]]; then
        echo "$(tput bold)$(tput setaf 1)[$date] $(tput sgr0)"
    else
        echo "$(tput bold)$(tput setaf 196)[$date] $(tput sgr0)"
    fi
}
function User() {
    if [[ $showUsername == true ]]; then
        if [[ $is256ColorTerm == true ]]; then
            color=118
        else
            color=2
        fi
        echo -n "$(tput bold)$(tput setaf $color)$USER$(tput sgr0)"
        if [[ $showHostname == true ]]; then
            echo -n "$(tput bold)$(tput setaf 24)@$(hostname)$(tput sgr0)"
        fi
        echo "$(tput bold)$(tput setaf $color):$(tput sgr0)"
    fi
}
function SuspendedJobs() {
    jobs_suspended="$(jobs | grep suspended | wc -l)"
    if [[ "$jobs_suspended" == "0" ]]; then
        return
    else
        echo -n "$(tput bold)$(tput setaf 35)(${jobs_suspended})$(tput sgr0) "
    fi
}

# Store last exit status code before generating a prompt
exitStatus=0
#PROMPT_COMMAND="CatchExitCode"
setopt prompt_subst
#Note: the prompt function is not allowed to globally change any variable values; only the PROMPT_COMMAND / precmd() is able
function precmd() { # zsh equivalent of PROMPT_COMMAND in bash
    CatchExitCode
}
if [[ "$TERM" =~ "256color" ]]; then
    is256ColorTerm=true
else
    is256ColorTerm=false
fi

prompt1="\$(DateTime)\$(SensorTemp)\$(ramUsage)\$(batteryInfo)\$(User)\$(Pwd)\$(GitBranch)\$(Sign)
\$(SuspendedJobs)>> "
PS1=$prompt1
#RPS1=""

#if [ "$TERM" == "linux" ]; then
#   export PS1=$prompt1
#else
#   export PS1=$prompt2
#fi

# Configuration options
showTime=true
showSysInfo=false
shortenPath=false
showHostname=false
showUsername=true
alias syson="export showSysInfo=true"
alias sysoff="export showSysInfo=false"

# }}}
# Global functions {{{
function mkcd() {
    mkdir $1
    cd $1
}

function back() {
    cd "$OLDPWD"
}

function swp() {
    TMP_FILE=$1.$RANDOM.$$
    mv $1 $TMP_FILE
    mv $2 $1
    mv $TMP_FILE $2
}

function reminder(){
    PS1="$PS1$(tput setaf 7)(Reminder: " # Add space to PS1, change text color
    for word in "$@"
    do
        PS1="$PS1$word "
    done
    PS1="${PS1:0:$[${#PS1}-1]})$(tput sgr0) " # Remove trailing space, reset font color, add close parentheses
    echo "Reminder set: $@"
}

function sourcezsh(){
    source ~/.zshrc
}
# }}}
# Global aliases {{{
alias ll='ls -alF'
alias la='ls -A'
alias lh='ls -ahl'
alias l='ls -CF'
alias rm='rm -I'
# import aliases from bash
if [[ -e $HOME/.bash_aliases ]]; then
    . $HOME/.bash_aliases
fi
# import zsh-specific aliases
if [[ -e $HOME/.zsh_aliases ]]; then
    . $HOME/.zsh_aliases
fi
# }}}
# Local aliases and rc {{{
# import bash-specific
if [[ -e $HOME/.bashrc_local ]]; then
    . $HOME/.bashrc_local
fi
# import zsh-specific
if [[ -e $HOME/.zshrc_local ]]; then
    . $HOME/.zshrc_local
fi
# }}}
