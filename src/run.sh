model_file=$1
data_file=$2
nprocs=$3

call="$0 $@"
output_dir="models/$(date +%F::%T)"
mkdir $output_dir
cp $model_file $output_dir/model.jl
echo $call > $output_dir/call.sh

julia -p $nprocs run.jl $output_dir $model_file $data_file >"$output_dir/log" 2>"$output_dir/err" &

