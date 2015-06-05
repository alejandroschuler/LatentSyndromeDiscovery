#!~/local/bin/julia

using DataFrames
println("Reading in data...")
@time data = readtable("/home/aschuler/LatentSyndromes/data/NIS_merged_CCS.csv.gz");

writetable("/home/aschuler/LatentSyndromes/data/no_kids.csv", data[!isna(data[:AGE]) & (data[:AGE].>18), :])