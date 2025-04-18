# read two lines of FTDI, write cfg-edit

with open('lsusb.ftdi', 'r') as f:
    lines = f.readlines()

print('tinyusb')
print (lines)
