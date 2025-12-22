#!/bin/bash

tmux new-session -d -s devtime -n main
tmux send-keys "cd ~/projects/" C-m
tmux split-window -h -t devtime
tmux split-window -v -t devtime
tmux new-window -n editor
HIGHLIGHT_COLOR="cyan"
BG_COLOR="black"
ACTIVE_COLOR="red"
tmux select-window -t devtime:0
tmux attach -t devtime
