#!/usr/bin/env bash

set -eux

session_exists=0
tmux has-session -t dev 2>/dev/null || session_exists=$?
if [ $session_exists != 0 ]; then
    tmux new-session -d -s 'dev' -n 'level' -c ~/code/level
    tmux send-keys -t 'level' nvim Space . Enter
    tmux new-window -n 'dotfiles' -c ~/dotfiles
    tmux send-keys -t 'dotfiles' nvim Space . Enter
fi
tmux attach-session -t 'dev':1
