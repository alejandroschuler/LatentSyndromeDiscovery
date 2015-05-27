output_dir = ARGS[1]
model_file = ARGS[2]
data_file = ARGS[3]

println("Loading code...")
include(model_file) 

println("Reading in data...")
@time data = DataFrames.readtable(data_file);

println("Filtering data...")
cohort, fields, record_keys = data_filter(data);

println("Setting up GLRM...")
X, Y, ch, labels = fit_glrm(cohort[fields]);

println("Saving output...")
writedlm(string(output_dir,"/X.csv"), X, ',')
writedlm(string(output_dir,"/Y.csv"), Y, ',')
writedlm(string(output_dir,"/labels.csv"), labels, ',')
writedlm(string(output_dir,"/record_keys.csv"), record_keys, ',')

