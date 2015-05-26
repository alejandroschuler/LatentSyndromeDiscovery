#!/usr/bin/env python

import argparse
import gzip
import sys

parser = argparse.ArgumentParser(description="Simple join of two HCUP .csv "
    "files. Assumes that relative ordering of rows is consistent between files.")

parser.add_argument("--inputs", nargs='+', required=True,
    help="Paths to at least two input .csv files to join. These can also be "
    ".gz files, in which case the file extension will be used to determine "
    "whether it is necessary to unzip. The output will retain rows from the "
    "first input.")

parser.add_argument("--output", help="Output .csv file.")

parser.add_argument("--keys", nargs='+', required=True,
    help="At least 1 key (column name) on which to join the two tables. If "
    "more than one key is specified, it must match the number of inputs.")

parser.add_argument("--discard_key", action="store_true",
    help="If specified, don't keep the key columns. Otherwise one of the key "
    "columns is retained.")

parser.add_argument('--gzip', action='store_true', help="If speficied, write output as "
    "a gzipped file on-the-fly (can be directly loaded into Julia).")

args = parser.parse_args()

# Open the input files
def open_detect(path):
    if path.endswith('.gz'):
        return gzip.open(path, 'r')
    return open(path)
inputs = [open_detect(path) for path in args.inputs]

# Read headers
headers = [handle.readline().rstrip().split(',') for handle in inputs]

# Get indices of keys
if len(args.keys) == 1:
    key = args.keys[0]
    key_indices = [header.index(key) for header in headers]
elif len(args.keys) == len(inputs):
    key_indices = [header.index(key) for header, key in zip(heder)]
else:
    print 'Error: specify either one key or one key for each input.'
    quit()

def skip(li, index):
    return [li[i] for i in range(len(li)) if i != index]

# Open file handle
if args.gzip:
    args.output_handle = gzip.open(args.output, 'wb')
else:
    args.output_handle = open(args.output, 'w')

# Output joined file
start = skip(headers[0], key_indices[0]) if args.discard_key else headers[0]
for header, key_index in zip(headers[1:], key_indices[1:]):
    start += skip(header, key_index)
args.output_handle.write(','.join(start) + '\n')

print 'Number of columns: %d' % len(start)
if len(start) != len(set(start)):
    print 'Warning: column names are not unique. Consider renaming.'

print '\nWriting output:'
nlines = 0
for left_line in inputs[0]:
    # Print an update on number of lines read
    nlines += 1
    if nlines % 10000 == 0:
        print '\r%d' % nlines,
        sys.stdout.flush()
    # Construct output line
    left_items = left_line.rstrip().split(',')
    left_key = left_items[key_indices[0]]
    out_line = skip(left_items, key_indices[0]) if args.discard_key else left_items
    for in_file, key_index in zip(inputs[1:], key_indices[1:]):
        # Read until matching ID found
        while True:
            line = in_file.readline()
            if len(line) == 0:
                print 'Error: files do not match. Quitting.'
                quit()
            items = line.rstrip().split(',')
            if items[key_index] == left_key: break
        # Add to output
        out_line += skip(items, key_index)
    args.output_handle.write(','.join(out_line) + '\n')
print '\r%d' % nlines
