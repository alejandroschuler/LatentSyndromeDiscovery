#!~/local/bin/julia

# 'Usage: run.sh [-D n_lines | -d data_file_name] -m model_file -o output_dir -p n_processes -i init_algo'

using DataFrames

function data_filter(data::DataFrame)
    record_keys = readdlm("/home/aschuler/LatentSyndromes/data/delirium_keys.csv")
    delirium_set = Set(record_keys)
    cohort = data[!isna(data[:AGE]) & (data[:AGE].>18), :]; # remove kids
    delirium_index = Bool[in(cohort[:KEY][i], delirium_set) for i in 1:length(cohort[:KEY])] # make a boolean index of delirium records
    cohort = cohort[delirium_index, :]; # get only hospitalizations with delirium                                                    
    return cohort
end

println("Reading in data...")
@time data = DataFrames.readtable("/home/aschuler/LatentSyndromes/data/NIS_merged_CCS.csv.gz");

println("Filtering data...")
cohort = data_filter(data);

writetable("/home/aschuler/LatentSyndromes/data/delirium.csv", cohort)