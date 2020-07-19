#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Usage: $0 <input> <output>"
	exit 1
fi

if [ ! -f $1 ]; then
	echo "Could not find $1"
	exit 2
fi

pre_output=/tmp/pre-$RANDOM
rdrama-preprocessor $pre_output < $1

if [ $? -ne 0 ]; then
	exit $?
fi

symbols=/tmp/sym-$RANDOM
rdrama-resolver $symbols < $pre_output

if [ $? -ne 0 ]; then
	echo $pre_output
	exit $?
fi

rdrama-assembler $2 $symbols < $pre_output

if [ $? -ne 0 ]; then
	exit $?
fi
rm $pre_output
rm $symbols
