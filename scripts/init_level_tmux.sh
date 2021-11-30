#!/usr/bin/env bash

set -eux

session_exists=0
tmux has-session -t dev 2>/dev/null || session_exists=$?
if [ $session_exists != 0 ]; then
    tmux new-session -d -s 'dev' -n 'level' -c ~/code/level
    tmux new-window -n 'level-nvim' -c ~/code/level nvim .
    tmux new-window -n 'dotfiles' -c ~/dotfiles
    tmux new-window -n 'dotfiles-nvim' -c ~/dotfiles nvim .
fi
tmux attach-session -t 'dev':1
