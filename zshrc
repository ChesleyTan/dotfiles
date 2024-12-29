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

# bind keys for history search
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
# bind keys for line navigation
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

# User configuration

export PATH="${PATH}:/bin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin"

if type nvim > /dev/null; then
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
function _style() {
    echo "%{$(tput $@)%}"
}

BOLD="$(_style bold)"
RESET="$(_style sgr0)"

function _prompt_git_branch() {
    if ! $show_git_info; then
        return
    fi
    output="$(git rev-parse --is-inside-work-tree 2>&1)"
    if [[ "$output" == "true" ]]; then
        output="$(git status 2>&1)"
        branch="$(git branch | grep '* ' | cut -c3-)"
        echo " ${BOLD}$(_style setaf 34)(${branch} $(_git_up_to_date "$output")$(_git_stash_length))${RESET}"
    fi
}

function _git_up_to_date() {
    git_status="$1"
    if [[ $git_status =~ "Changes to be committed" ]]; then
        echo -ne "\u2718" # unicode character cross
    else
        echo -ne "\u2714" # unicode character check
    fi
    if [[ $git_status =~ "Changes not staged for commit" ]]; then
        echo -ne " \u0394" # unicode character delta
    fi
    echo -ne "\n"
}

function _git_stash_length() {
    git_stash_length=$(git stash list | wc -l)
    if [[ "$git_stash_length" != "0" ]]; then
        echo -ne " \u26c1 $git_stash_length\n"
    fi
}

function _prompt_sensor_temp() {
# Note on usage 1: you must prepend an escape character onto $(_prompt_sensor_temp) so the prompt dynamically updates the temperature
# Note on usage 2: modify the arguments for head and tail to select a specific temperature in the output
    echo "${BOLD}$(_style setaf 166)<$(sensors | grep -Eo '[0-9][0-9]\.[0-9]°C' | head -1) | ${RESET}"
}

function _prompt_ram_usage() {
    echo "${BOLD}$(_style setaf 166)$(free -m | grep -Eo '[0-9]*' | head -6 | tail -1) MB | ${RESET}"
}

function _prompt_battery_info() {
    data="$(acpi | grep -Eo "[0-9]*%|[0-9][0-9]:[0-9][0-9]:[0-9][0-9]")"
    perc="$(echo "$data" | grep -Eo "[0-9]*%" | grep -o "[0-9]*" | paste -sd "/")"
    bat_time="$(echo "$data" | grep -Eo "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]")"
    if [ "$bat_time" == "" ]; then
        bat_time="Full"
    fi
    echo "${BOLD}$(_style setaf 166)$perc%% ($bat_time)> ${RESET}"
}

function _prompt_sys_info() {
    if $show_sys_info; then
        echo "$(_prompt_sensor_temp)$(_prompt_ram_usage)$(_prompt_battery_info)"
    fi
}

function _prompt_catch_exit_code() {
    exit_status=$?
}

function _prompt_sign() {
    if [[ $UID == 0 ]]; then
        echo "${BOLD}$(_style setaf 9) #${RESET}"
    else
        if [[ $exit_status == 0 ]]; then
            echo "${BOLD}$(_style setaf 15) \$${RESET}"
        else
            echo "${BOLD}$(_style setaf 9) \$${RESET}"
        fi
    fi
}

function _prompt_pwd() {
    if $is_256_color_term; then
        color=39
    else
        color=6
    fi
    echo -n "${BOLD}$(_style setaf $color)"
    if $shorten_path; then
        echo -n "$PWD" | sed -r "s|$HOME|~|g" | sed -r "s|/(.)[^/]*|/\1|g" # (.) holds the first letter and \1 recalls it
    else
        echo -n "$PWD" | sed -r "s|$HOME|~|g"
    fi
    echo "${RESET}"
}

function _prompt_datetime() {
    if ! $show_time; then
        return
    fi
    date="$(date "+%I:%M %P")"
    if ! $is_256_color_term; then
        echo "${BOLD}$(_style setaf 1)[$date] ${RESET}"
    else
        echo "${BOLD}$(_style setaf 196)[$date] ${RESET}"
    fi
}

function _prompt_user() {
    if $show_username; then
        if $is_256_color_term; then
            color=118
        else
            color=2
        fi
        echo -n "${BOLD}$(_style setaf $color)${USER}${RESET}"
        if $show_hostname; then
            echo -n "${BOLD}$(_style setaf 24)@${HOST}${RESET}"
        fi
        echo "${BOLD}$(_style setaf $color):${RESET}"
    fi
}

function _prompt_suspended_jobs() {
    jobs_suspended="${#jobstates}"
    if [[ "$jobs_suspended" == "0" ]]; then
        return
    else
        echo -n "${BOLD}$(_style setaf 35)(${jobs_suspended})${RESET} "
    fi
}

# Store last exit status code before generating a prompt
exit_status=0
setopt prompt_subst
#Note: the prompt function is not allowed to globally change any variable values; only the PROMPT_COMMAND / precmd() is able
function precmd() { # zsh equivalent of PROMPT_COMMAND in bash
    _prompt_catch_exit_code
}

is_256_color_term=false
if [[ "$TERM" =~ "256color" ]]; then
    is_256_color_term=true
fi

prompt1="\$(_prompt_datetime)\$(_prompt_sys_info)\$(_prompt_user)\$(_prompt_pwd)\$(_prompt_git_branch)\$(_prompt_sign)
\$(_prompt_suspended_jobs)>> "
PS1=$prompt1
#RPS1=""

# Configuration options
show_time=true
show_sys_info=false
shorten_path=false
show_hostname=false
# Show hostname if inside ssh session
if [[ -n "$SSH_TTY" || -n "$SSH_CLIENT" || -n "$SSH_CONNECTION" ]]; then
    show_hostname=true
fi
show_username=true
show_git_info=true

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

function reminder() {
    PS1="$PS1$(_style setaf 7)(Reminder: " # Add space to PS1, change text color
    for word in "$@"; do
        PS1="$PS1$word "
    done
    PS1="${PS1:0:$[${#PS1}-1]})${RESET} " # Remove trailing space, reset font color, add close parentheses
    echo "Reminder set: $@"
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
# Plugin configuration {{{
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}
