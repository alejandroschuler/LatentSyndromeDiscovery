import argparse
from math import sqrt

parser = argparse.ArgumentParser(description='List the top N components of a latent syndrome.')
parser.add_argument('--n', type=int, help='Number of components to list.')
parser.add_argument('--Y', type=argparse.FileType('r'), help='A .csv holding the Y matrix.')
parser.add_argument('--labels', type=argparse.FileType('r'), help='A .csv holding labels (vertical).')
args = parser.parse_args()

labels = [line.strip().strip('"') for line in args.labels]

cont = ['LOS', 'AGE', 'TOTCHG']

for i, line in enumerate(args.Y):
	elements = [float(x) for x in line.strip().split(',')]
	maxval = sqrt(sum([element * element for element, label in zip(elements, labels) if label not in cont]))
	print '\n%d' % i
	for label, element in sorted(zip(labels, elements), key=lambda x: x[1], reverse=True)[:args.n]:
		print '%s\t%f' % (label, element / maxval)