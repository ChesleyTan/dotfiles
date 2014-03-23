#!/bin/bash                                                                                                   

SESSIONNAME="Coding"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ] 
then
    tmux new-session -s $SESSIONNAME -n main -d
    tmux clock
    tmux split-window -h
    tmux clock
    tmux new-window -n aux
    tmux clock
    tmux select-window -t 1
fi

tmux attach -t $SESSIONNAME
