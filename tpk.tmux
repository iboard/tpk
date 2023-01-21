#!/bin/bash

# =======================================================
# TMUX SCRIPT TO START A TMUX SESSION FOR TPK DEVELOPMENT
# =======================================================
# 
# required environment
#
# - $PREFIX ................. root repository        just the git root
# - $PREFIX/tpk_common ...... tpk_common repository  a git submodule
# - $PREFIX/tpk_otp ......... tpk_otp repository     a git submodule
# - $PREFIX/tpk_examples .... tpk_example repository another git submodule

PREFIX=$(pwd)
echo "Starting TMUX environment for TPK development"
echo "PREFIX=$PREFIX"

SESSION=TPKdev

function start_tmux_session {
  echo "START TMUX SESSION $session"
  export TMUX_SESSION_RUNNING=1

  # create three windows
  tmux new-session -d -c $PREFIX -s $SESSION -n 'tpk-root'
  tmux new-window -t $SESSION -n 'tpk-common'
  tmux new-window -t $SESSION -n 'tpk-examples'

  # split all windows
  tmux split-window -t $SESSION:1.0
  tmux split-window -t $SESSION:2.0
  tmux split-window -t $SESSION:3.0

  # resize panes
  tmux resize-pane -t $SESSION:1.1 -D 10
  tmux resize-pane -t $SESSION:2.1 -D 10
  tmux resize-pane -t $SESSION:3.1 -D 10

  # cd into the proper path in each window
  tmux send-keys -t $SESSION:1.0 'clear; figlet TPK; ./test_all;git status' C-m
  tmux send-keys -t $SESSION:1.1 'clear; pwd' C-m
  tmux send-keys -t $SESSION:2.0 'cd tpk_common && fig tpk_common' C-m
  tmux send-keys -t $SESSION:2.1 'cd tpk_common && fig tpk_common' C-m
  tmux send-keys -t $SESSION:3.0 'cd tpk_examples && fig tpk_examples' C-m
  tmux send-keys -t $SESSION:3.1 'cd tpk_examples && fig examples server' C-m

  # pretype the proper command for each pane
  tmux send-keys -t $SESSION:1.0 'nvim' C-m
  #tmux send-keys -t $SESSION:1.1 'iex -S mix phx.server' C-m
  tmux send-keys -t $SESSION:2.0 'nvim' C-m
  tmux send-keys -t $SESSION:2.1 'mix test --trace --seed 0' C-m
  tmux send-keys -t $SESSION:3.0 'nvim' C-m
  tmux send-keys -t $SESSION:3.1 'iex -S mix phx.server' C-m
}

## main
running_session=$(tmux list-sessions | grep $SESSION)

if [ -z "$running_session" ]
then
  start_tmux_session
  tmux attach -t $SESSION:1.0
  tmux attach -t $SESSION:2.0
  tmux attach -t $SESSION:3.0
else
  echo "$running_session"
  echo "Session already running. Use tmux attach"
fi

