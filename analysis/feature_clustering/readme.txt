To get started, copy labels.csv (file with the column names) into the 
directory. Make two subdirectories: Y, output_Y. Move (or link) the 
desired inputs into Y. Run generate_labels.py to generate the detailed
column labels. Now run analyze_all.sh to analyze all input matrices.

------------------
generate_labels.py
------------------

Run this to add detailed annotations (based on AppendixASingleDX.txt
and AppendixBSinglePR.txt) to the column names in labels.csv, 
outputting to labels_detailed.csv.


---------
cluster.r
---------
Usage:
	Rscript cluster.r INPUT.csv OUTPUT.svg

Perform hierarchical clustering on matrix in INPUT.csv using Ward's method and Euclidean distances, and output the resulting tree to 
OUTPUT.svg.


-----------
list_top.py
-----------
usage: list_top.py [-h] [--n N] [--Y Y] [--labels LABELS]

List the top N components of a latent syndrome.

optional arguments:
  -h, --help       show this help message and exit
  --n N            Number of components to list.
  --Y Y            A .csv holding the Y matrix.
  --labels LABELS  A .csv holding labels (vertical).


--------------
analyze_all.sh
--------------
Analyze all input CSV files in Y/ and output to a subdirectory of 
outputs_Y/ named after the input file. Perform clustering and list the
top elements of the latent syndromes.