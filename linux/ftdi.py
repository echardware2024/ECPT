# read two lines of FTDI, write cfg-edit

def get_product(s):
    products = ['S2M2-S16', 'S2LP-S16', 'S2LP-D16']
    if s in products:
        return s
    return 'Invalid product'
# End

with open('lsusb.ftdi', 'r') as f:
    lines = f.readlines()
print('tinyusb')
print (lines)

if len(lines) == 2 and 'iProduct' in lines[0] and 'iSerial' in lines[1]:
    product_stripped = lines[0].strip()
    prod = product_stripped[-8:]
    print(prod)
    product = get_product(product_stripped[-8:])
    print(product)

    serial_stripped = lines[1].strip()
    sn = serial_stripped [-8:]
    print(sn)
else:    
    print('Invalid FTDI settings')
