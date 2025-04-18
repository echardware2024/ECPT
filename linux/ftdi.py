# read two lines of FTDI, write cfg-edit

def check_product(s):
    products = ['S2M2-S16', 'S2LP-S16', 'S2LP-D16']
    old_products = [' on S2M2']
    if s in products:
        return s
    elif s in old_products:
        return s[4:]  # remove " on "
    return 'Invalid product'
# End

def check_serial(s):
    if s.isdigit():
        return s
    return 'Invalid serial'
# End

with open('lsusb.ftdi', 'r') as f:
    lines = f.readlines()
print('tinyusb')
print (lines)

if len(lines) == 2 and 'iProduct' in lines[0] and 'iSerial' in lines[1]:
    product_stripped = lines[0].strip()
    prod = product_stripped[-8:]
    product = check_product(product_stripped[-8:])
    print(product + ' "' + prod + '"')

    serial_stripped = lines[1].strip()
    sn = serial_stripped [-8:]
    print(sn)
else:    
    print('Invalid FTDI settings')
