#!/bin/sh

#gdb-multiarch --quiet "src/patches/discman_4-1/build/discman_4-1.elf" --eval "target remote localhost:3333" --eval "monitor reset halt"

d="build"
p="$(ls -1 $d/*.elf)"

gdb-multiarch --quiet "$p" -x tools/gdb.cfg

