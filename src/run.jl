#!~/local/bin/julia

# 'Usage: run.sh [-D n_lines | -d data_file_name] -m model_file -o output_dir -p n_processes -i init_algo'

using ArgParse

s = ArgParseSettings()
@add_arg_table s begin
    "--data_file", "-d"
        help = "path to the data file"
        required = true
    "--model_file", "-m"
        help = "path to the .jl file containing the model specifications"
        required = true
    "--output_dir", "-o"
        help = "the directory in which to put the output"
        required = true
    "--init_algo", "-i"
        help = "the algorithm used to initialize the glrm: 'svd' or 'kmeanspp'"
end
args = parse_args(s)

println("Arguments:")
println(string(args))

println("Loading code...")
include(args["model_file"]) 

println("Reading in data...")
@time data = DataFrames.readtable(args["data_file"]);

println("Filtering data...")
cohort, fields, record_keys = data_filter(data);

println("Setting up GLRM...")
glrm, labels = make_glrm(cohort[fields]);

if args["init_algo"] != nothing
    println(string("Finding a warm start using ", args["init_algo"], "..."))
    if args["init_algo"]=="svd"
        @time glrms.init_svd!(glrm)
    elseif args["init_algo"]=="kmeanspp"
        @time glrms.init_kmeanspp!(glrm)
    end
end

println("Fitting...")
@time X, Y, ch = glrms.fit!(glrm, params=glrms.Params(0.1,1000,0.000001,0.001))
println("###### Convergance ######")
println("Objective\tTime")
for (o,t) in zip(ch.objective, ch.times)
    println(string(o, "\t", t))
end

output_dir = args["output_dir"]
if !isdir(output_dir)
    mkdir(output_dir)
end
writedlm(string(output_dir,"/X.csv"), X, ',')
writedlm(string(output_dir,"/Y.csv"), Y, ',')
writedlm(string(output_dir,"/labels.csv"), labels, ',')
writedlm(string(output_dir,"/record_keys.csv"), record_keys, ',')
cp(args["model_file"], string(output_dir,"/model.jl"))

