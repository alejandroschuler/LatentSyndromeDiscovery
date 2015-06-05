#!/bin/bash

usage () {
    echo 'Usage: sample_data.sh -n N_LINES -o OUTPUT_NAME -f INPUT_FILE [-z]'
    exit 1
}

while getopts f:n:o:hz name
do
    case $name in 
	f)in=$OPTARG;;
	n)n_lines=$OPTARG;;
	o)outf=$OPTARG;;
	h)usage;;
	z)zipped=1;;
    esac
done

dir="/home/aschuler/LatentSyndromes/data"
if [ -z $n_lines ]; then
    usege
fi
if [ -z $outf ]; then
    outf="${dir}/sample_${n_lines}"
fi
echo "printing to ${outf}"

if [ ! -z $zipped ]; then
    # write the header
    gzip -cd $in | head -1 > $outf
    # write n random lines (excluding the header)
    gzip -cd $in | sed '1d' | shuf -n $n_lines >> $outf
else 
    # write the header
    head -1 $in > $outf
    # write n random lines (excluding the header)
    sed '1d' $in | shuf -n $n_lines >> $outf
fi
