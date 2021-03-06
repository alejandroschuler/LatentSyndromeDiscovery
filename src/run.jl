#!~/local/bin/julia

# 'Usage: run.sh [-D n_lines | -d data_file_name] -m model_file -o output_dir -p n_processes -i init_algo'

using ArgParse
using DataFrames
using LowRankModels

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
    "--rank", "-k"
        help = "the desired rank for the GLRM"
        required = true
        arg_type = Int
end
args = parse_args(s)

output_dir = args["output_dir"]
if !isdir(output_dir)
    mkdir(output_dir)
end
cp(args["model_file"], string(output_dir,"/model.jl"))
log_file = open(string(output_dir, "/log"), "w")

write(log_file, "Arguments:\n")
write(log_file, string(args, "\n"))
write(log_file, "Loading code...\n")
include(args["model_file"]) 

write(log_file, "Reading in data...\n")
data = DataFrames.readtable(args["data_file"]);
record_keys = data[:KEY] # save the keys here
fields = filter(x->(x!=:KEY), names(data)); # remove the KEY identifier column

write(log_file, "Setting up GLRM...\n")
glrm, labels = make_glrm(data[fields], args["rank"]);

if args["init_algo"] != nothing
    write(log_file, string("Finding a warm start using ", args["init_algo"], "...\n"))
    if args["init_algo"]=="svd"
        @time glrms.init_svd!(glrm)
    elseif args["init_algo"]=="kmeanspp"
        @time glrms.init_kmeanspp!(glrm)
    end
end

write(log_file, "Fitting...\n")
X, Y, ch = glrms.fit!(glrm, params=glrms.Params(0.1,50,0.0001,0.001))
write(log_file, "###### Convergance ######\n")
write(log_file, "Objective\tTime\n")
for (o,t) in zip(ch.objective, ch.times)
    write(log_file, string(o, "\t", t, "\n"))
end

convergence = DataFrame()
convergence[:time] = vec(ch.times)
convergence[:obj] = vec(ch.objective)

writetable(string(output_dir,"/ch.csv"), convergence)
writedlm(string(output_dir,"/X.csv"), X, ',')
writedlm(string(output_dir,"/Y.csv"), Y, ',')
writedlm(string(output_dir,"/labels.csv"), labels, ',')
writedlm(string(output_dir,"/record_keys.csv"), record_keys, ',')
close(log_file)