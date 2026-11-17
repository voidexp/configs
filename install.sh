#!/usr/bin/env bash

root=$(pwd)

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
