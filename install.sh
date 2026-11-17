#!/usr/bin/env bash

root=$(pwd)

python=$(which python3)
if [ -z $python ]; then
  echo "ERROR: 'python3' not found, aborting"
  exit 1
fi

helix=$(which hx)
if [ -z $helix ]; then
  echo "ERROR: Helix executable 'hx' not found, aborting"
  exit 1
fi

function replace_vars() {
  env HELIX=$helix $python - $1 <<EOF
from sys import argv
from os import environ as env
filename = argv[1]
with open(filename, 'r') as fp:
  data = fp.read()
for key in env:
  data = data.replace('{{' + key + '}}', env[key])
with open(filename, 'w') as fp:
  fp.write(data)
EOF
}

# -- Icons --
echo "Installing icons..."
cd $root/local/share/icons
for file in $(ls *.png); do
  install -D -m 664 $file $HOME/.local/share/icons
done

# -- Application desktop files --
echo "Installing application files..."
cd $root/local/share/applications
for file in $(ls *.desktop); do
  install -D $file $HOME/.local/share/applications
done

# -- Scripts --
echo "Installing scripts..."
cd $root/local/bin
for file in $(ls *.sh); do
  install -D $file $HOME/.local/bin
done

# -- Configs --
echo "Installing configs..."
cd $root/config
for dir in $(ls); do
  for file in $(find $dir -type f); do
    install -D -m 664 $file $HOME/.config/$file
  done
done

# -- Postprocessing --
echo "Patching configs..."
cd $HOME/.config/kitty/sessions
for file in $(ls *.kitty-session); do
  replace_vars $file
done
