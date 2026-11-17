#!/bin/bash

TITLE="Arctic Chill Dev"
WM_CLASS=ArcticChillDev
WORK_DIR=$HOME/Projects/arctic-chill
KITTY=$HOME/.local/bin/kitty
WID=`xdotool search --limit 1 --name "$TITLE"`

if [ -z $WID ]; then
  echo "No editor found, opening..."
  PID=$(kitty --session=~/.config/kitty/sessions/arctic-chill.kitty-session --class=$WM_CLASS --title="$TITLE" --start-as=fullscreen --working-directory=$WORK_DIR &)
  echo $PID

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
  xdotool key Control_L Shift_L F3
  xdotool type "goto_tab 1"
  xdotool key Return
fi
