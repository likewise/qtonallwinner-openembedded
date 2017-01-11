#!/bin/sh

time tar -Ipixz -cf ../test.tar.pixz meta* openembedded-core build/conf build/Makefile doc scripts tmux.sh .config
