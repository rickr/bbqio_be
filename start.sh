#!/usr/bin/env bash

kill -9 $(ps -ef | grep '[n]ew-session -d -s be' | awk ' { print $2 } ')

source /usr/local/rvm/scripts/rvm
rvm use 2.1.5

tmux new-session -d -s default
tmux new-window -t default:1 -n 'src' 'ruby bbqio_be.rb'
