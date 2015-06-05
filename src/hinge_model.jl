import DataFrames, DataArrays
df = DataFrames
import LowRankModels
glrms = LowRankModels

function make_glrm(data::df.DataFrame)
    n_records = size(data,1)
    println("Setting up GLRM")

    losses_array = [glrms.hinge() for name in names(data)]
    rx = glrms.onereg()
    ry = glrms.quadreg()

    println("Setting up GLRM...")
    glrm, labels = glrms.GLRM(data, 21, losses=losses_array, rx=rx, ry=ry, scale=true, offset=true)
    return glrm, labels
end

function data_filter(data::df.DataFrame)
    cohort = data[!df.isna(data[:AGE]) & (data[:AGE].>18), :]; # remove kids
    record_keys = cohort[:KEY]                         # get the IDs of the remaining records
    fields = filter(x->(x!=:KEY), names(data));       # get all the names of the coded features sans the ID column
    return cohort, fields, record_keys
end
