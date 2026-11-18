#!/usr/bin/env bash

root=$(pwd)
projects_root=$HOME/Projects

# -- Check for programs --

# Python
python=$(which python3)
if [ -z $python ]; then
  echo "ERROR: 'python3' executable not found, aborting"
  exit 1
fi

# Helix
helix=$(which hx)
if [ -z $helix ]; then
  echo "ERROR: 'hx executable not found, aborting"
  exit 1
fi
export HELIX=$helix

# Kitty (warn only)
if [ -z $(which kitty) ]; then
  echo "WARNING: 'kitty' executable not found"
fi

# Replaces the {{NAME}} occurrences in the given file with the value of the
# export-ed NAME environment variable.
function replace_vars() {
  $python - $1 <<EOF
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

# -- Projects --
echo "Installing project configs..."
cd $root/Projects
for proj_dir in $(ls); do
  if [ -d $projects_root/$proj_dir ]; then
    for cfg_dir in $(ls $proj_dir); do
      dst_dir=$(echo $cfg_dir | sed 's/^_/./g')
      if [ -d $projects_root/$proj_dir/$dst_dir ]; then
        rm -r $projects_root/$proj_dir/$dst_dir
      fi
      cp -r $proj_dir/$cfg_dir $projects_root/$proj_dir/$dst_dir
    done
  fi
done

# -- Postprocessing --
echo "Patching files..."
files=(
  $HOME/.config/kitty/sessions/arctic-chill.kitty-session
  $HOME/.config/kitty/sessions/jsa.kitty-session
  $HOME/.config/kitty/sessions/yass-zig.kitty-session
  $HOME/.local/share/applications/jsa.desktop
  $HOME/.local/share/applications/arctic-chill.desktop
)
for file in "${files[@]}"; do
  replace_vars $file
done
