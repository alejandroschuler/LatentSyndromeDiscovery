# LatentSyndromeDiscovery
Using Generalized Low Rank Models to discover structure in NIS-HCUP hospitalization records.

Organization:
`scr` contains the julia files used to set up and run the low rank models. These are decently documented, but require some understanding of `LowRankModels.jl`.
`preprocessing` contains scripts used to preprocess the raw NIS data into a useful format. Well documented.
`analysis` contains scripts used to analyse the output of our low rank models, perform clustering, and do some validation.
