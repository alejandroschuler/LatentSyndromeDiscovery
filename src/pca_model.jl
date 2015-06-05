import DataFrames, DataArrays
df = DataFrames
import LowRankModels
glrms = LowRankModels

function make_glrm(data::df.DataFrame, rank::Integer)
    losses_array = [glrms.quadratic() for name in names(data)]
    rx = glrms.zeroreg()
    ry = glrms.zeroreg()

    glrm, labels = glrms.GLRM(data, rank, losses=losses_array, rx=rx, ry=ry, scale=true, offset=true)
    return glrm, labels
end

# function data_filter(data::df.DataFrame)
#     cohort = data[!df.isna(data[:AGE]) & (data[:AGE].>18), :]; # remove kids
#     record_keys = cohort[:KEY]                         # get the IDs of the remaining records
#     fields = filter(x->(x!=:KEY), names(data));       # get all the names of the coded features sans the ID column
#     return cohort, fields, record_keys
# end
