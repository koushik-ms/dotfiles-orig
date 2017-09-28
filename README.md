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



