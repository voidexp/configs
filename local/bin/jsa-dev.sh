#!/bin/bash

HELIX={{HELIX}}
TITLE="JSA"
WM_CLASS=JSADev
WORK_DIR=$HOME/Projects/jsa
WID=`xdotool search --limit 1 --name "$TITLE"`

if [ -z $WID ]; then
  echo "No editor found, opening..."
  gnome-terminal --name=$TITLE --class=$WM_CLASS --title="$TITLE" --maximize --working-directory=$WORK_DIR -- $HELIX $1 &

  for i in {1..10}; do
    WID=`xdotool search --limit 1 --name "$TITLE"`
    if [ $WID ]; then break; fi
    sleep .1
  done
else
  echo "Existing \"$TITLE\" window found: $WID"
fi

xdotool windowactivate $WID

if [ $1 ]; then
  xdotool key Escape
  xdotool type ":o $1"
  xdotool key Return
fi
