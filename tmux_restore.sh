#!/bin/bash

SESSIONNAME="Coding"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ]
then
    echo "Choose a work profile: "
    echo "1) Home"
    echo "2) Work"
    read input

    tmux new-session -s $SESSIONNAME -n main -d
    tmux split-window -h -c "$PWD"
    tmux split-window -h -c "$PWD"
    tmux select-layout tiled

    tmux new-window -n alt
    tmux split-window -h -c "$PWD"
    tmux select-layout tiled

    # Set up custom arrangement for home
    if [[ $input == 1 ]]; then
        tmux new-window -n feeds
        tmux split-window -h -c "$PWD"
        tmux split-window -h -c "$PWD"
        tmux select-layout tiled
        tmux set-window-option -t:"feeds" monitor-activity off
        # Run pianobar if exists
        if hash pianobar 2> /dev/null ; then
            tmux respawn-pane -t "feeds".0 -k "pianobar"
        fi
        # Run newsbeuter if exists
        if hash newsbeuter 2> /dev/null ; then
            tmux respawn-pane -t "feeds".1 -k "newsbeuter"
        fi
        # Run mutt if exists
        if hash mutt 2> /dev/null ; then
            tmux respawn-pane -t "feeds".2 -k "mutt"
        fi
    fi
    # open clock in a window named aux
    tmux new-window -n aux
    tmux clock

    # return to first window
    tmux select-window -t 1
fi
tmux attach -t $SESSIONNAME

