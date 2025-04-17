# read file
with open ('/home/ec/prodtest/bin/bar-stats', 'r') as f:
    lines = f.readlines()

product = ''  # blank to start with
node = '.A '  # first node
separator = ''
for rawline in lines:
    line = rawline.strip()
    if line.startswith('VAL,'):  # determine number of tokens
        info = line.split(',')  # S2M2=6, S2LP=??
        if len(info) == 6:
            product = product + separator + 'S2M2' + node
            node = '.B '  # for 2nd match (debug only, can't happen)
            separator = '| '  # for 2nd match (debug only, can't happen)
            p = 5
            t = 4
        elif len(info) == 17:
            product = product + separator + 'S2LP' + node
            node = '.B '  # for 2nd match
            separator = '| '  # for 2nd match
            p = 12
            t = 11
        else:
            product = 'Unknown Product'
            p = -1
            t = -1
    if line.startswith('MAX,') and p>0 and t>0:  # extract temperature and power
        info = line.split(',')
        product = product + info[p].strip() + ' W @ ' + info[t].strip().replace('.00', '') + ' C '

print(product)  # used by main script

# EOF
