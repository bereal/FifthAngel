#!/bin/bash

for f in $(find graphics/tiles/ -name \*.png); do
  zools encode-sprite $f --size 16x16 --invert -o res/tiles/$(basename -- $f .png).bin
done

