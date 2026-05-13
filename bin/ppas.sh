#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking /home/astra/laz_proj/tr_src/bin/trevid-linux
OFS=$IFS
IFS="
"
/usr/bin/ld -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2     -L. -o /home/astra/laz_proj/tr_src/bin/trevid-linux -T /home/astra/laz_proj/tr_src/bin/link3389.res -e _start
if [ $? != 0 ]; then DoExitLink /home/astra/laz_proj/tr_src/bin/trevid-linux; fi
IFS=$OFS
