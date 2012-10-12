#!/bin/bash

cd `dirname $0`
VERSION=`sed -ne "s/^.*JS_VERSION.*\"\(.*\)\"/\1/p" src/jsutils.h`
DIR=`pwd`
ZIPDIR=$DIR/zipcontents
rm -rf $ZIPDIR
mkdir $ZIPDIR

echo ------------------------------------------------------
echo                          Building Version $VERSION
echo ------------------------------------------------------

cd $DIR/../stm32/tinyjs

OLIMEX=1 make clean
OLIMEX=1 make 
cp main.bin  $ZIPDIR/espruino_${VERSION}_olimexino_stm32.bin

STM32VLDISCOVERY=1 make clean
STM32VLDISCOVERY=1 make 
cp main.bin  $ZIPDIR/espruino_${VERSION}_stm32vldiscovery.bin

STM32F4DISCOVERY=1 make clean
STM32F4DISCOVERY=1 make 
cp main.bin  $ZIPDIR/espruino_${VERSION}_stm32f4discovery.bin

cd $DIR

cp readme.txt $ZIPDIR
./extract_docs.sh > $ZIPDIR/functions.txt
awk '/\[CHANGELOG\]/{s=x}{s=s$0"\n"}/\[\/CHANGELOG\]/{print s}' src/jsutils.h >  $ZIPDIR/changelog.txt
awk '/\[TODO\]/{s=x}{s=s$0"\n"}/\[\/TODO\]/{print s}' src/jsutils.h >  $ZIPDIR/todo.txt

rm -f espruino_${VERSION}.zip 
cd zipcontents
zip $DIR/espruino_${VERSION}.zip *
