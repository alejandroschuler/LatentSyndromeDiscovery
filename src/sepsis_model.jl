import DataFrames, DataArrays
df = DataFrames
import LowRankModels
glrms = LowRankModels

function fit_glrm(data::df.DataFrame)

	n_records = size(data,1)

	# Organize the features by their datatype
	boolean_features = [:FEMALE, :AWEEKEND, :ELECTIVE, :DIED]
	continuous_features = [:AGE, :TOTCHG, :LOS]
	categorical_features = [(:RACE, [1:6]), (:PAY1, [1:6]), (:DISPUNIFORM, [1:7,20,21,99]), (:ASOURCE, [1:5])]
	ordinal_features = [(:PL_NCHS2006, [1:6]), (:ZIPINC_QRTL, [1:4])]
	periodic_features = [(:AMONTH, [1:12])]

	# Reassign the categorical variables to bools at their various levels
	for (name, levels) in categorical_features
	for feature_name in names(data)
	    if ismatch(Regex(string("^",name)), string(feature_name))
	        push!(boolean_features, feature_name)
	    end
	end
	end

	# Initialize the losses as a dictionary. Later we'll turn this into an array.
	losses = Dict{Symbol, glrms.Loss}()

	# Assign hinge loss objects to all boolean elements
	for name in boolean_features
	    losses[name] = glrms.hinge()
	end

	# Assign Huber loss objects to continuous elements
	for name in continuous_features
	    losses[name] = glrms.quadratic()
	end

	# Assign ordinal loss objects losses to ordinal variables
	for (name, levels) in ordinal_features
	    losses[name] = glrms.ordinal_hinge(min(levels...), max(levels...))
	end

	for (name, levels) in periodic_features
	    losses[name] = glrms.periodic(min(levels...), max(levels...))
	end

	for name in names(data)
	# Assign scaled boolean losses to comorbidity variables
	    if ismatch(r"^CM", string(name))
	        losses[name] = glrms.imbalanced_hinge() # this is effectively the same as hinge()

	# Assign scaled boolean losses to diagnosis variables
	    elseif ismatch(r"^DXCCS", string(name)) 
	        # we could assign this confidence code-by-code if we like, perhaps based on false negative rate
	        losses[name] = glrms.imbalanced_hinge(case_weight_ratio=1)

	# Assign scaled boolean losses to procedure variables
	    elseif ismatch(r"^PRCCS", string(name))
	        losses[name] = glrms.imbalanced_hinge(case_weight_ratio=1)
	    end
	end

	losses_array = [losses[name] for name in names(data)]
	obs = glrms.observations(data)
	rx = glrms.nonnegative()
	ry = glrms.onereg()

	glrm, labels = glrms.GLRM(data, 10, losses=losses_array, rx=rx, ry=ry, scale=true, offset=true)
#	println("Initializing GLRM with a warm start")
#	@time glrms.init_svd!(glrm)
	@time X, Y, ch = glrms.fit!(glrm)
	return X, Y, ch, labels

end

function data_filter(data::df.DataFrame)
    cohort = data[!df.isna(data[:AGE]) & (data[:AGE].>18), :]; # remove kids
    record_keys = cohort[:KEY]  	               # get the IDs of the remaining records
    fields = filter(x->(x!=:KEY && x!=:DXCCS_2), names(data));       # get all the names of the coded features sans the ID and sepsis columns
    return cohort, fields, record_keys
end