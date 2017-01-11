#!/bin/dash

SESSIONNAME=bridgemate
DIR=$PWD
BUILDDIR=build
BUILDTMP=tmp-glibc

tmux start-server

#tmux kill-session -t ${SESSIONNAME}

mkdir -p ${DIR}/${BUILDDIR}
mkdir -p ${DIR}/${BUILDDIR}/${BUILDTMP}/work
mkdir -p ${DIR}/${BUILDDIR}/${BUILDTMP}/deploy
mkdir -p ${DIR}/${BUILDDIR}/${BUILDTMP}/deploy/images

tmux has-session -t ${SESSIONNAME}
if [ $? -gt 0 ]; then
  echo "Session ${SESSIONNAME} not found. Creating new session in 3 seconds..."
  tmux new-session -d -s ${SESSIONNAME}

  # CTRL-D will exit the shell only after three consecutive CTRL-D
  # Typically the user wants to detach (CTRL-B d) instead of closing the shell.
  tmux set-environment -g 'IGNOREEOF' 3

  tmux new-window -d -k -t ${SESSIONNAME}:0 -n source -c ${DIR}
  tmux new-window -d -k -t ${SESSIONNAME}:1 -n build -c ${DIR}
  tmux send-keys -t ${SESSIONNAME}:build ". ./openembedded-core/oe-init-build-env ${BUILDDIR}/" C-m
  tmux new-window -d -k -t ${SESSIONNAME}:2 -n work -c ${DIR}/${BUILDDIR}/${BUILDTMP}/work
  tmux new-window -d -k -t ${SESSIONNAME}:3 -n deploy -c ${DIR}/${BUILDDIR}/${BUILDTMP}/deploy
  tmux new-window -d -k -t ${SESSIONNAME}:3 -n images -c ${DIR}/${BUILDDIR}/${BUILDTMP}/deploy/images
else
  echo "Attaching to existing session."
fi

tmux list-clients -t ${SESSIONNAME}

#if [ "$DISPLAY" != "" ]; then
#  gnome-terminal \
#    --tab --title=source -e tmux attach-session -t ${SESSIONNAME}:0 \
#    --tab --title=build -e tmux attach-session -t ${SESSIONNAME}:1
#else
  :
  tmux attach-session -t ${SESSIONNAME}
#fi
