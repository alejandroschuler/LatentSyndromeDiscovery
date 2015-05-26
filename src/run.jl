output_dir = ARGS[1]
model_file = ARGS[2]
data_file = ARGS[3]

# loads DataFrames as df, LowRankModels as glrms
include(model_file) 

println("Reading in data...")
@time data = DataFrames.readtable(data_file);
# @time data = DataFrames.readtable("data/NIS_merged_CSS.csv.gz");
# @time data = DataFrames.readtable("data/test.gz"); #100000 lines
# @time data = DataFrames.readtable("data/tinytest.gz"); #1000 lines

fields = filter(x->x!=:KEY, names(data));
cohort = data[!df.isna(data[:AGE]) & (data[:AGE].>18), :]; # remove kids

X, Y, ch = fit_glrm(cohort[fields]);

writedlm(string(output_dir,"/X.csv"), X, ',')
writedlm(string(output_dir,"/Y.csv"), Y, ',')
writedlm(string(output_dir,"/labels.csv"), fields, ',')

