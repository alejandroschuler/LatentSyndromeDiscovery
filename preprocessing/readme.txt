I've been running these scripts with Python 2.7.6; it probably will work with 
other Python 2 versions.

--------------
format_hcup.py
--------------

usage: format_hcup.py [-h] --input INPUT --output OUTPUT [--delim DELIM]
                      [--true TRUE] [--false FALSE]
                      [--keep_cols KEEP_COLS [KEEP_COLS ...]]
                      [--bool_cols BOOL_COLS [BOOL_COLS ...]]
                      [--cat_cols CAT_COLS [CAT_COLS ...]]
                      [--idlist_cols IDLIST_COLS [IDLIST_COLS ...]]
                      [--idlist_fill IDLIST_FILL] [--min_records MIN_RECORDS]
                      [--gzip]

Format HCUP data, choosing columns to keep and columns to reformat.

optional arguments:
  -h, --help            show this help message and exit
  --input INPUT         Input file with HCUP data.
  --output OUTPUT       Output database file.
  --delim DELIM         Delimiter for the database input. Default: ,
  --true TRUE           String representing true booleans. Default '1'
  --false FALSE         String representing false booleans. Default '-1'
  --keep_cols KEEP_COLS [KEEP_COLS ...]
                        List of regexes. Columns matching a regex in this list
                        are kept as-is. Regex matching starts at the beginning
                        of the column name; include '$' at end to match a full
                        name (e.g. FULLNAME$ to match only the column named
                        'FULLNAME', PARTIAL to match 'PARTIAL', 'PARTIALNAME',
                        'PARTIAL_NAME', etc.)
  --bool_cols BOOL_COLS [BOOL_COLS ...]
                        List of regexes. Columns matching a regex in this list
                        are kept as a column representing a singleboolean
                        variable (1 representing true, 0 representing false).
  --cat_cols CAT_COLS [CAT_COLS ...]
                        List of regexes. Columns matching a regex in this list
                        are treated a categorical data and expanded into a
                        series of boolean variables, one for each possible
                        value. Missing data will result in all the expanded
                        boolean variables being filled with empty strings
                        (read as NA in Julia).
  --idlist_cols IDLIST_COLS [IDLIST_COLS ...]
                        List of prefixes. For each prefix, all columns with
                        name PREFIX + (number) are treated as containing an
                        unordered list of IDs (e.g. diagnoses or procedures).
  --present PRESENT     Value indicating a feature is present. Default is '0'.
  --absent ABSENT       Value to fill with when expanding ID lists. Default is
                        '-1' to indicate feature (e.g. diagnosis) is absent.
  --min_records MIN_RECORDS
                        Minimum number of patients for a code to make it into
                        the final dataset. Default is 0 (keep every diagnosis
                        in the dataset).
  --gzip                If speficied, write output as a gzipped file on-the-
                        fly (can be directly loaded into Julia).

To format the HCUP data, using the CCS diagnoses and procedures:

./format_hcup.py --input 2010/NIS2010Core.csv \
    --output 2010/processed/NIS2010_formatted_CCS.csv.gz \
    --keep_cols KEY$ AGE$ TOTCHG$ LOS$ AMONTH$ ZIPINC_QRTL$ PL_NCHS2006$ \
    --bool_cols FEMALE$ AWEEKEND$ ELECTIVE$ DIED$ \
    --cat_cols RACE$ PAY1$ ASOURCE$ DISPUNIFORM$ \
    --idlist_cols DXCCS PRCCS \
    --min_records 0 \
    --true 1 --false -1 \
    --gzip

We will also need to format the severity data (containing comorbidity codes):
./format_hcup.py --input 2010/NIS_Severity.csv \
    --output 2010/processed/NIS_Severity_formatted.csv.gz \
    --keep_cols KEY$ \
    --bool_cols CM_ \
    --true 1 --false -1 \
    --gzip


Remove --gzip if you don't need a smaller file (total size will be ~8 GB if not
zipped)!

The --keep_cols, --bool_cols, and --cat_cols arguments are specified as Python 
regular expressions. '$' indicates the end of the column name, so all specified 
regexes match the full name except CM_, which matches all comorbidity columns. 
I included the KEY column since we might have to do some database joining later.

Prefixes for --idlist_cols are DXCCS and PRCCS, for CCS procedure codes. DX and PR
would work for the raw ICD-9 codes, producing a data file ~5x larger; I didn't
try filtering with --min_records but this could greatly cut down on the size.

I set --min_records to 0 since there aren't many CCS codes. The unzipped output
has 508 columns and a size of 8.1 GB. The gzipped file is much smaller at about 
223 MB; for larger datasets (like if we decide to use the ICD-9 codes) we should
be able to write the gzipped file and then directly load that into Julia using 
the readtable() function.

Processing data and writing the full gzipped file takes about 20 minutes on my
machine. Writing a non-gzipped file is about 15 minutes.




---------------
combine_hcup.py
---------------

usage: combine_hcup.py [-h] --inputs INPUTS [INPUTS ...] [--output OUTPUT]
                       --keys KEYS [KEYS ...] [--discard_key] [--gzip]

Simple join of two HCUP .csv files. Assumes that relative ordering of rows is
consistent between files.

optional arguments:
  -h, --help            show this help message and exit
  --inputs INPUTS [INPUTS ...]
                        Paths to at least two input .csv files to join. These
                        can also be .gz files, in which case the file
                        extension will be used to determine whether it is
                        necessary to unzip. The output will retain rows from
                        the first input.
  --output OUTPUT       Output .csv file.
  --keys KEYS [KEYS ...]
                        At least 1 key (column name) on which to join the two
                        tables. If more than one key is specified, it must
                        match the number of inputs.
  --discard_key         If specified, don't keep the key columns. Otherwise
                        one of the key columns is retained.
  --gzip                If speficied, write output as a gzipped file on-the-
                        fly (can be directly loaded into Julia).

To combine the HCUP data, do:

./combine_hcup.py --inputs 2010/processed/NIS_Severity_formatted.csv.gz \
        2010/processed/NIS2010_formatted_CCS.csv.gz
    --keys KEY --gzip
    --output 2010/processed/NIS_merged_CCS.csv.gz
