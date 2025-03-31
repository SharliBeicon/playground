#!/bin/zsh

OUT_DIR="build/desktop"
mkdir -p $OUT_DIR
odin build main_desktop -out:$OUT_DIR/game_desktop.bin
cp -R ./img/ ./$OUT_DIR/img/
echo "Desktop build created in ${OUT_DIR}"
