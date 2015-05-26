output_dir = ARGS[1]
model_file = ARGS[2]
data_file = ARGS[3]

# loads DataFrames as df, LowRankModels as glrms
include(model_file) 

println("Reading in data...")
@time data = DataFrames.readtable(data_file);

cohort = data[!df.isna(data[:AGE]) & (data[:AGE].>18), :]; # remove kids
record_keys = cohort[:KEY]  	     		       	   # get the IDs of the remaining records
fields = filter(x->x!=:KEY, names(data)); 		   # get all the names of the coded features sans the ID column

X, Y, ch, labels = fit_glrm(cohort[fields]);

writedlm(string(output_dir,"/X.csv"), X, ',')
writedlm(string(output_dir,"/Y.csv"), Y, ',')
writedlm(string(output_dir,"/labels.csv"), labels, ',')
writedlm(string(output_dir,"/record_keys.csv"), record_keys, ',')

