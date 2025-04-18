# read two lines of FTDI, write cfg-edit
from datetime import datetime

def check_product(s):
    products = ['S2M2-S16', 'S2LP-S16', 'S2LP-D16']
    old_products = [' on S2M2']
    if s in products:
        return s
    elif s in old_products:
        return s[4:] + '-S16'  # remove " on " and add S16
    return 'Invalid product'
# End

def check_serial(s):
    if s.isdigit():
        return s
    return 'Invalid serial'
# End

# Start of script
date = datetime.now().strftime("%Y%m%d")

with open('lsusb.ftdi', 'r') as f:
    lines = f.readlines()
# print('tinyusb')  # debug
# print (lines)  # debug

if len(lines) == 2 and 'iProduct' in lines[0] and 'iSerial' in lines[1]:
    product_stripped = lines[0].strip()
    prod = product_stripped[-8:]
    product = check_product(prod)
    # print(product)

    serial_stripped = lines[1].strip()
    sn = serial_stripped [-8:]
    serial = check_serial(sn)
    # print(serial)
    print('Writing cfg-edit using ' + product + ' ' + serial + ' ' + date)
    serialint = int(serial)
    if serialint < 10000000:  # has leading zero, do nothing
        cfgedit = ''
    elif serialint >= 10000000 and serialint < 20000000:  # 10000 10014 10015
        print('1x serial')
        cfglist = ['cfg -unlock', 'cfg edit', 'S2M2', 'S16NFN', serial[0:5] + '-EC-' + serial[5:8], serial, '1', '5', '1066', '2.01',  date, date, '1', '0', '2', '800', '1', '0', '550', '2', '0', '1', '97', '85', '85', '1', '1', 'C']
        cfgedit = '\n'.join(cfglist) + '\n'
    elif serialint >= 20000000 and serialint < 30000000:  # 10000 10014 10015
        print('2x serial')
    elif serialint >= 30000000 and serialint < 40000000:  # 10000 10014 10015
        print('3x serial')
    elif serialint >= 40000000 and serialint < 50000000:  # 10000 10014 10015
        print('4x serial')
    # write file
    if len(cfgedit) > 0:  # make sure it contains chars
        print(cfgedit)
        with open('cfg.edit', 'w') as f:
            f.write(cfgedit) 
    else:
        print('Failed to generate cfg-edit')
else:    
    print('Invalid FTDI settings')

# End
