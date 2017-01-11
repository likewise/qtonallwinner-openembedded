#!/bin/sh

rm -f urls.txt
for a in m* o* bb; do (git -C ${a} remote get-url origin >>doc/urls.txt); done

