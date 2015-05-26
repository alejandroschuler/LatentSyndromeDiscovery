#!/usr/bin/env python

import argparse
import re
import gzip
import sys
from collections import defaultdict

#######################
# Parse input arguments
#######################

parser = argparse.ArgumentParser(description="Format HCUP data, choosing "
    "columns to keep and columns to reformat.")

parser.add_argument('--input', type=str, required=True, help="Input file "
    "with HCUP data.")
parser.add_argument('--output', type=str, required=True, help="Output "
    "database file.")
parser.add_argument('--delim', default=',', help="Delimiter for the database input. "
    "Default: ,")

parser.add_argument('--true', default='0', 
    help="String representing true booleans. Default '0'")
parser.add_argument('--false', default='-1', 
    help="String representing false booleans. Default '-1'")

parser.add_argument('--keep_cols', default=[], nargs='+', help="List of regexes. "
    "Columns matching a regex in this list are kept as-is. Regex matching starts "
    "at the beginning of the column name; include '$' at end to match a full name (e.g. "
    "FULLNAME$ to match only the column named 'FULLNAME', PARTIAL to match 'PARTIAL', "
    "'PARTIALNAME', 'PARTIAL_NAME', etc.)")

parser.add_argument('--bool_cols', default=[], nargs='+', help="List of regexes. "
    "Columns matching a regex in this list are kept as a column representing a single"
    "boolean variable (1 representing true, 0 representing false).")

parser.add_argument('--cat_cols', default=[], nargs='+', help="List of regexes. "
    "Columns matching a regex in this list are treated a categorical data and "
    "expanded into a series of boolean variables, one for each possible value. "
    "Missing data will result in all the expanded boolean variables being "
    "filled with empty strings (read as NA in Julia).")

parser.add_argument('--idlist_cols', default=[], nargs='+', help="List of prefixes. "
    "For each prefix, all columns with name PREFIX + (number) are treated as "
    "containing an unordered list of IDs (e.g. diagnoses or procedures).")

parser.add_argument('--present', default='0', help="Value indicating a feature is present. "
    "Default is '0'.")
parser.add_argument('--absent', default='-1', help="Value to fill with when "
    "expanding ID lists. Default is '-1' to indicate feature (e.g. diagnosis) is absent.")

parser.add_argument('--min_records', type=int, default=0, help="Minimum number of "
    "patients for a code to make it into the final dataset. Default is 0 (keep every "
    "diagnosis in the dataset).")

parser.add_argument('--gzip', action='store_true', help="If speficied, write output as "
    "a gzipped file on-the-fly (can be directly loaded into Julia).")

args = parser.parse_args()


##################################
# Determine which columns to ouput
##################################

args.input_handle = open(args.input, 'r')
header = args.input_handle.readline()
fieldnames = header.rstrip().split(args.delim)

# Determine column indices of as-is columns
keep_cols = []
for i, name in enumerate(fieldnames):
    for regex in args.keep_cols:
        # Match by regex, starting from beginning
        if re.match(regex, name) is not None:
            keep_cols.append(i)
            break

# Determine column indices of boolean columns
bool_cols = []
for i, name in enumerate(fieldnames):
    for regex in args.bool_cols:
        # Match by regex, starting from beginning
        if re.match(regex, name) is not None:
            bool_cols.append(i)
            break

# Determine column indices of categorical columns
cat_cols = []
cat_col_names = []
for i, name in enumerate(fieldnames):
    for regex in args.cat_cols:
        # Match by regex, starting from beginning
        if re.match(regex, name) is not None:
            cat_cols.append(i)
            cat_col_names.append(name)
            break


# Determine sets of column indices to treat as containing list of IDs
out_groups = []
for prefix in args.idlist_cols:
    indices = []
    for i, name in enumerate(fieldnames):
        # Match if name is (prefix) + (number)
        if re.match(re.escape(prefix) + "[0-9]+$", name) is not None:
            indices.append(i)
    out_groups.append(indices)

print "Outputting as-is:"
print ','.join([fieldnames[i] for i in keep_cols])

print "Outputting boolean columns:"
print ','.join([fieldnames[i] for i in bool_cols])

print "\nOutputting categorical columns:"
print ','.join([fieldnames[i] for i in cat_cols])

print "\nOutputting groups:"
for prefix, indices in zip(args.idlist_cols, out_groups):
    names = [fieldnames[i] for i in indices]
    print "%s: %s" % (prefix, ','.join(names))


############################
# Determine expanded columns
############################

# Read through the file, counting codes and determining
# values of categorical variables
print "\nReading file to determine represented codes:"
nlines = 0 # Track lines so user can see progress
cat_value_sets = [set() for i in cat_cols]
count_dicts = [defaultdict(int) for i in out_groups]
for line in args.input_handle:
    # Print an update on number of lines read
    nlines += 1
    if nlines % 10000 == 0:
        print '\r%d' % nlines, # Update every 10000 lines
        sys.stdout.flush()
    # Tokenize input
    items = line.rstrip().split(args.delim)
    # Iterate through categoricals, using set to track values
    for index, value_set in zip(cat_cols, cat_value_sets):
        if items[index] != '':
            value_set.add(items[index])
    # Iterate through id list groups, using appropriate dict to count
    for indices, counts in zip(out_groups, count_dicts):
        for index in indices:
            # Ignore empty field
            if items[index] == '':
                continue
            # Increment counter
            counts[items[index]] += 1
print '\r%d' % nlines

# Determine which codes need columns in the output
id_lists = []
for indices, counts in zip(out_groups, count_dicts):
    codes = []
    # Sort right-justified (for proper sorting of numerical strings)
    max_len = max(len(s) for s in counts.keys())
    for code in sorted(counts.keys(), key=lambda s: s.rjust(max_len)):
        if counts[code] >= args.min_records:
            codes.append(code)
    id_lists.append(codes)

# Sort the values for the diagnoses
cat_value_lists = []
for indices, values in zip(cat_cols, cat_value_sets):
    if len(values) > 0:
        max_len = max(len(s) for s in values)
        cat_value_lists.append(sorted(values, key=lambda s: s.rjust(max_len)))
    else:
        cat_value_lists.append(list())

cat_value_lists
print "\nSelecting diagnoses above threshold:"
for prefix, counts, codes in zip(args.idlist_cols, count_dicts, id_lists):
    print "%s: %d / %d total" % (prefix, len(codes), len(counts))


#####################
# Write out new table
#####################

# Open file handle
if args.gzip:
    args.output_handle = gzip.open(args.output, 'wb')
else:
    args.output_handle = open(args.output, 'w')

# Write new header
out_header = [fieldnames[i] for i in keep_cols]
out_header += [fieldnames[i] for i in bool_cols]
for name, values in zip(cat_col_names, cat_value_lists):
    out_header += [name + "=" + value for value in values]
for prefix, codes in zip(args.idlist_cols, id_lists):
    out_header += [prefix + "=" + code for code in codes]
args.output_handle.write(','.join(out_header) + '\n')
print "\nElements per row: %d" % len(out_header)

# Make dictionaries mapping from categorical value -> index
cat_value_index_dicts = []
for cat_values in cat_value_lists:
    tmp_dict = {}
    for i, code in enumerate(cat_values):
        tmp_dict[code] = i
    cat_value_index_dicts.append(tmp_dict)

# Make dictionaries mapping from diag. code -> index
id_index_dicts = []
for ids in id_lists:
    tmp_dict = {}
    for i, code in enumerate(ids):
        tmp_dict[code] = i
    id_index_dicts.append(tmp_dict)

# Reset the handle for the input file
args.input_handle.close()
args.input_handle = open(args.input, 'r')
header = args.input_handle.readline()

# Iterate through rows to output cleaned version
print "\nFormatting and writing output:"
nlines = 0
for line in args.input_handle:
    # Print an update on number of lines read
    nlines += 1
    if nlines % 10000 == 0:
        print '\r%d' % nlines,
        sys.stdout.flush()
    # Tokenize input
    items = line.rstrip().split(args.delim)

    # Write the output
    # Add as-is columns
    out_items = [items[i] for i in keep_cols]
    # Add boolean columns
    for i in bool_cols:
        value = items[i]
        if value == '0':
            out_items.append(args.false)
        elif value == '1':
            out_items.append(args.true)
        else:
            out_items.append('')
    # Add categorical columns
    for index, index_dict in zip(cat_cols, cat_value_index_dicts):
        value = items[index]
        if value == '':
            new_items = [''] * len(index_dict)
        else:
            new_items = [args.false] * len(index_dict)
            new_items[index_dict[value]] = args.true
        out_items += new_items
    # Add id columns
    for grouped_cols, id_index_dict in zip(out_groups, id_index_dicts):
        new_items = [args.absent] * len(id_index_dict)
        for col in grouped_cols:
            code = items[col]
            if code in id_index_dict:
                new_items[id_index_dict[code]] = args.present
        out_items += new_items
    args.output_handle.write(args.delim.join(out_items) + '\n')
print '\r%d' % nlines
