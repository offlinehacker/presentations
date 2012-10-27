#!/bin/bash

if test $# = 2
then
    filename=$1
    slidecount=$2
    end=`expr $slidecount - 2`

    size="900x675"
    yoffset=40
    middleoffset="$size+995+$yoffset"
    prelastoffset="$size+485+$yoffset"
    lastoffset="$size+25+$yoffset"

    for x in `seq 1 $end`; 
    do
        cutycapt --url=file://$filename#$x --out=slide$x.bmp
        convert "slide$x.bmp[$middleoffset]" slide$x.bmp
    done

    x=`expr $slidecount - 1`
    cutycapt --url=file://$filename#$x --out=slide$x.bmp
    convert "slide$x.bmp[$prelastoffset]" slide$x.bmp

    x=$slidecount
    cutycapt --url=file://$filename#$x --out=slide$x.bmp
    convert "slide$x.bmp[$lastoffset]" slide$x.bmp

    convert $(find slide*.bmp  | sort --version-sort) -size 576x900 out.pdf
    rm slide*.bmp
else
	echo "Usage - $0   filename slide_count"
fi
