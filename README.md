# dotfiles

This repository is for saving all the configuration files.

## Contents

As of now below are contents planned.

1. .config/i3/config
2. .config/i3blocks/*
3. .config/i3status/*
4. .zshrc
5. .bashrc

## Structure

Typically the structure inside this repo mirrors the structure in the
home directory with some exceptions:
1. The .config folder is named .config


The idea behind this structure is to make it easier to write an
install.sh that makes symlinks from every item inside a top-level
folder (like .config) that begins with a "."

(This is the hypothesis to be tested)

Where relevant this repo also captures the documentation on
dependencies and (links to) install instructions.

## i3 setup

This setup was done on linux mint using the instructions in setupi3.

Below is the concise list of dependencies:
1. i3lock
2. i3status (installed by default on mint with i3)
3. i3blocks (apt-get)
4. fonts-fontawesome (apt-get or automatically installed)
8. feh, rofi, libgtk-3-dev, compton (apt-get)
5. Arc GTK Theme
6. Arc firefox Theme (breaks some preferences, sync and download dialogs)
7. San Francisco Display font
8. ... wallpapers.

