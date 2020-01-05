# Maturitätsarbeit Louis Eppler

This folder contains all files for the visual programming language and the instructions to run the program. 

## Installation

To be able to write and compile code, the following programs are required.

### Processing

Download Processing 3 from https://processing.org/download/ and install the program.

### Netwide Assembler

Nasm can be installed using Homebrew (see https://brew.sh) with:
```
brew install nasm
```

## Starting the editor

To open the code editor run the following command (on mac)
```
processing-java --sketch=$(pwd)/visual --run
```
or open the source code with the Processing editor and select run.
This will open the editor for the visual language. 
For more information on the visual programming language see maturarbeit.pdf Section 2.

## Loading Examples

There are several examples stored in the data folder.
To load an example press `s` and then select 'load from data folder'. Copy one of the following filenames to the clipboard.
```
dividingBy20.txt
biggestNumber.txt
fib.txt
primfactor.txt
soi.txt
pythagorasTripple.txt
geldautomat.txt
sort.txt
```
Then press `r` to reload the text editor and `ENTER` to load the code.


## Compiling and running the code

First compile from within the editor by pressing `ENTER`. Then run
```
./run.command
```
to compile the assembly code and run it. Note that compiling the assembly code only works on a mac.
