#!/bin/bash
cd "$(dirname "$0")"/target
nasm -f macho64 main.s
ld -macosx_version_min 10.7.0 -lSystem -o main main.o
./main
