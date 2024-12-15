#!/bin/bash

src=$(find graphics/tiles/ -name \*.png)
#for f in $(find graphics/tiles/ -name \*.png); do
zools encode-tile graphics/tiles/*.png --encoding asm -o res/tiles.z80
#done

