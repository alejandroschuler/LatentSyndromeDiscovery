#!/bin/bash

usage()
{
    echo 'Usage: run.sh [-D n_lines | -d data_file_name] -m model_file -o output_dir -p n_processes'
}

if [ "$#" -ne 8 ]; then
    usage
    exit 1
fi

app_home="/home/aschuler/LatentSyndromes"
my_path=$(pwd)

while getopts D:d:m:o:p: name
do
    case $name in 
	D)n_lines=$OPTARG;;
	d)data_file_name="${my_path}/${OPTARG}";;
	m)model_file="${my_path}/${OPTARG}";;
	o)output_dir="${my_path}/$OPTARG";;
	p)nprocs=$OPTARG;;
    esac
done

if [ ! -z $n_lines ]; then
    data_file="${app_home}/data/sample_${n_lines}"
    # write the header
    gzip -cd "${app_home}/data/NIS_merged_CCS.csv.gz" | head -1 > $data_file
    # write n random lines
    gzip -cd "${app_home}/data/NIS_merged_CCS.csv.gz" | shuf -n $n_lines >> $data_file
elif [ ! -z $data_file_name ]; then
    data_file="${data_file_name}"
fi

call="$0 $@"

mkdir $output_dir
cp $model_file $output_dir/model.jl
echo $call > $output_dir/call.sh

julia -p $nprocs ${app_home}/src/run.jl $output_dir $model_file $data_file >"${output_dir}/log" 2>"${output_dir}/err"

