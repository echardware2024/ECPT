# read two lines of FTDI, write cfg-edit

with open('lsusb.ftdi', 'r') as f:
    lines = f.readlines()

print('tinyusb')
print (lines)

if len(lines) == 2 and 'iProduct' in lines[0] and 'iSerial' in lines[1]:
    product_stripped = lines[0].strip()
    prod = product_stripped[-8:]
    print(prod)
    serial_stripped = lines[1].strip()
    sn = serial_stripped [-8:]
    print(sn)
else:    
    print('Invalid FTDI settings')
