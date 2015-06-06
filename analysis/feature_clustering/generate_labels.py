with open('labels.csv') as f:
	header = [line.strip() for line in f]

def codetable(handle, skip=4):
	for i in range(skip):
		handle.readline()
	result = {}
	for line in handle:
		if line[0] in '0123456789':
			code, desc = line.strip().split(None, 1)
			result[code] = desc
	return result

with open('AppendixASingleDX.txt') as f:
	dx = codetable(f)

with open('AppendixBSinglePR.txt') as f:
	pr = codetable(f)

newfields = []
for i in header:
	i = i.replace('"', "'")
	if i.startswith('DXCCS_'):
		key = i.split('_')[-1]
		newfields.append(i + ' ' + dx.get(key, ''))
	elif i.startswith('PRCCS_'):
		key = i.split('_')[-1]
		newfields.append(i + ' ' + pr.get(key, ''))
	else:
		newfields.append(i)

# print 'labels <- c("%s")' % '", "'.join(newfields)

with open('labels_detailed.csv', 'w') as o:
	for field in newfields:
		o.write('"%s"\n' % field)