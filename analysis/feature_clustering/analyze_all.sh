for i in Y/*; do
	echo $i
	mkdir output_$i
	Rscript cluster.r $i output_$i/euc_ward_tree.svg
	python list_top.py --n 20 --Y $i --labels labels_detailed.csv > output_$i/major_elements.txt
	convert -density 100 output_$i/euc_ward_tree.svg output_$i/euc_ward_tree.png
done