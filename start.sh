#!/usr/bin/env bash

pkill -9 'tmux -d -s be'

source /usr/local/rvm/scripts/rvm
rvm use 2.2

tmux new-session -d -s be
tmux new-window -t be:1 -n 'src' 'ruby bbqio_be.rb'
