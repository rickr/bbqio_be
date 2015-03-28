#!/usr/bin/env bash

kill -9 $(ps -ef | grep '[n]ew-session -d -s be' | awk ' { print $2 } ')

source /usr/local/rvm/scripts/rvm
rvm use 2.2

tmux new-session -d -s be
tmux new-window -t be:1 -n 'src' 'ruby bbqio_be.rb'
