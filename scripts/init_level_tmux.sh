#!/usr/bin/env bash

set -eux

session_exists=$(tmux list-sessions | grep 'dev')
if [ "$session_exists" = "" ]
then
    tmux new-session -d -s 'dev' -n 'level' -c ~/code/level
    tmux new-window -n 'level-nvim' -c ~/code/level nvim .
    tmux new-window -n 'dotfiles' -c ~/dotfiles
    tmux new-window -n 'dotfiles-nvim' -c ~/dotfiles nvim .
fi
tmux attach-session -t 'dev':1
