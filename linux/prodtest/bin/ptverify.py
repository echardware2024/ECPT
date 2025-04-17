# read file
with open ('/home/ec/.last_sn', 'r') as f:
    snfile = f.read()

nogo = False  # go/no-go result

required = {
    'EdgeCortix S2M2, variant S16NFN': [
        'rev 1.5', 'Secondary image, Revision 1.1.5',  # versions
        '2[DOT]02', '98+85+85',  # cfg edit
        'Device 1fdc:0001', 'A.LnkSta: Speed 8GT/s (ok), Width x4 (ok)',  # PCIe
        'M2EN_PG0 P105 00000007 out 1 low', 'M2EN_PG1 P106 00000007 out 1 low', 'M2EN_PG2 P111 00000007 out 1 low',  # CB
        ],
    'EdgeCortix S2LP, variant S16BHN': [
        'rev 1.5', 'Secondary image, Revision 1.1.5',  # versions
        '2[DOT]02', '98+85+85',  # cfg edit
        'Device 1fdc:0001', 'A.LnkSta: Speed 8GT/s (ok), Width x4 (ok)',  # PCIe
        'M2EN_PG0 P105 00000007 out 1 low', 'M2EN_PG1 P106 00000007 out 1 low', 'M2EN_PG2 P111 00000007 out 1 low',  # CB
        ],
}

speed_ranges = {
    'EdgeCortix S2M2, variant S16NFN': [
        ['3.3' ,'3.4', '3.5'],
        ['3.0' ,'3.1', '3.2'],
        ['3.3' ,'3.4', '3.5'],
        ['3.0' ,'3.1', '3.2']],
    'EdgeCortix S2LP, variant S16BHN': [
        ['3.3' ,'3.4', '3.5'],
        ['3.0' ,'3.1', '3.2'],
        ['3.3' ,'3.4', '3.5'],
        ['3.0' ,'3.1', '3.2']],
}

def NoGo():
    global nogo
    nogo = True
# End

def GetKey(lines):
    for k in required:
        for line in lines:
            if k in line:
                return k
    NoGo()
    return 'none'
# End

def CheckVal(v, lines):
    for line in lines:
        if v in line:
            return 'OK: ' + v
    NoGo()
    return 'Result not found: ' + v
# End

def CheckPFF(lines):
    for line in lines:
        lowerline = line.lower()
        if 'pass' in lowerline:
            pass  # print(line.strip())  # debug
        elif 'fail' in lowerline or 'error' in lowerline or 'fault' in lowerline:
            print(line.strip())
            NoGo()
# End

def CheckBMC(lines):
    for line in lines:
        if 'Primary' in line:  # should happen once if primary is loaded
            print('\033[1;31m- Load Secondary using xl2/power-cycle\033[0m')
# End

def Red(s):
    print('\033[1;31m' + s + '\033[0m')
# End

def Green(s):
    print('\033[1;32m' + s + '\033[0m')
# End

def CheckRdWr(k, lines):
    good_speeds = 0
    for line in lines:
        stripped = line.strip()
        if stripped.startswith('Trial'):
            # print(stripped)  # debug
            tokens = stripped.split(',')
            wr = tokens[1].strip()
            rd = tokens[3].strip()
            if wr.startswith('write speed = ') and wr.endswith('GB/s'):
                wr_result = wr[14:-4]
            else:
                wr_result = 'Incorrect format: ' + wr
            if rd.startswith('read speed = ') and rd.endswith('GB/s'):
                rd_result = rd[13:-4]
            else:
                rd_result = 'Incorrect format: ' + rd
            # print(wr_result + ' | ' + rd_result)  # debug
            if wr_result[0:3] in speed_ranges[k][0]:  # index 0 is write, pass
                good_speeds = good_speeds + 1
            elif wr_result[0:3] in speed_ranges[k][1]:  # index 1 is write, warning
                print('Warning: low speed "' + wr_result + '". Rerun test.')
                NoGo()
            else:
                Red('Error: unacceptable speed "' + wr_result + '". Quarantine.')
                NoGo()
            if rd_result[0:3] in speed_ranges[k][2]:  # index 2 is read, pass
                good_speeds = good_speeds + 1
            elif rd_result[0:3] in speed_ranges[k][3]:  # index 3 is read, warning
                print('Warning: low speed "' + rd_result + '". Rerun test.')
                NoGo()
            else:
                Red('Error: unacceptable speed "' + rd_result + '". Quaratine.')
                NoGo()
    if good_speeds == 20:
        Green('Speed check successful.')
    else:
        Red('Speed check failed, insufficient result count (' + str(good_speeds) + ').')
        NoGo()
# End

tokens = snfile.split()
if len(tokens) == 5:  # 'sn 12345 678 # timestamp'
    # print(tokens)  # debug
    fullpath = '/home/ec/prodtest/' + tokens[1] + '/' + tokens[1] + tokens[2] + '-0x' + tokens[4] + '.txt'
    # print(fullpath)  # debug
    with open (fullpath, 'r') as f:
        lines = f.readlines()
    # for line in lines:
        # print(line.strip())
    k = GetKey(lines)  # find the key that matches the lines provided
    if k in ['none','not found',]:  # error results
        Red('No valid board found')
    else:
        print('Checking required results for: ' + k)  # debug: required[k]
        for v in required[k]:
            status = CheckVal(v, lines)
            if status.startswith('Result not found:'):
                Red(status)
        CheckPFF(lines)
        CheckRdWr(k, lines)
    if nogo:
        Red('PRODTEST FAILED')
        CheckBMC(lines)
    else:
        Green('PRODTEST PASSED')
else:
    Red('Invalid or missing .last_sn file')
    print('Tokens:')
    print(tokens)  # debug

# EOF
