#!/usr/bin/env bash

source /usr/local/rvm/scripts/rvm
rvm use 2.2

tmux new-session -d -s default
tmux new-window -t default:1 -n 'src' 'ruby bbqio_be.rb'
