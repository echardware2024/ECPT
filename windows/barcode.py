import sys
import msvcrt

separator = '-EC-'
write_files = False  # write files

def getbarcode():
    bc = ""
    n = 8  # default length
    while len(bc) < n:
        c = msvcrt.getwch() # reads one unicode char at a time
        bc += c  # add to string
        if len(bc) == 6:  # the sixth char might be special
            if bc[5].isdigit():
                n = 8
            elif bc[5] in '-_':  # separators for n=12, dash or underscore
                n = 12
            else:
                pass  # could add more checks
    return bc
# End

def validate(bc):
    if bc.startswith('00'):
        return 'Cannot have leading zeroes'
    elif bc.startswith('0'):
        return 'Cannot have a leading zero'
    elif len(bc) == 8:
        if not bc.isdigit():
            return 'Must contain only decimal digits [0-9]'
    elif len(bc) == 12:
        if not bc[0:5].isdigit():
            return 'Lot code must contain only decimal digits [0-9]'
        elif not bc[9:12].isdigit():
            return 'Serial must contain only decimal digits [0-9]'
        elif bc[5:9] != separator:
            return 'Separator must be "' + separator + '"'
    return ''
# End

# Template:

template = """<?xml version="1.0" encoding="utf-16"?>
<FT_EEPROM>
  <Chip_Details>
    <Type>FT X Series</Type>
  </Chip_Details>
  <USB_Device_Descriptor>
    <VID_PID>0</VID_PID>
    <idVendor>0403</idVendor>
    <idProduct>6015</idProduct>
    <bcdUSB>USB 2.0</bcdUSB>
  </USB_Device_Descriptor>
  <USB_Config_Descriptor>
    <bmAttributes>
      <RemoteWakeupEnabled>false</RemoteWakeupEnabled>
      <SelfPowered>false</SelfPowered>
      <BusPowered>true</BusPowered>
    </bmAttributes>
    <IOpullDown>false</IOpullDown>
    <MaxPower>90</MaxPower>
  </USB_Config_Descriptor>
  <USB_String_Descriptors>
    <Manufacturer>FTDI</Manufacturer>
    <Product_Description>FT230X on ABCD</Product_Description>
    <SerialNumber_Enabled>true</SerialNumber_Enabled>
    <SerialNumber>9876543210</SerialNumber>
    <SerialNumberPrefix>99999</SerialNumberPrefix>
    <SerialNumber_AutoGenerate>false</SerialNumber_AutoGenerate>
  </USB_String_Descriptors>
  <Hardware_Specific>
    <USB_Suspend_VBus>false</USB_Suspend_VBus>
    <RS485_Echo_Suppress>false</RS485_Echo_Suppress>
    <Port_A>
      <Hardware>
        <Device>FT230X/FT231X/FT234X (UART)</Device>
      </Hardware>
      <Driver>
        <D2XX>false</D2XX>
        <VCP>true</VCP>
      </Driver>
    </Port_A>
    <Battery_Charge_Detect>
      <Enable>false</Enable>
      <Power_Enable>false</Power_Enable>
      <Deactivate_Sleep>false</Deactivate_Sleep>
    </Battery_Charge_Detect>
    <Invert_RS232_Signals>
      <TXD>false</TXD>
      <RXD>false</RXD>
      <RTS>false</RTS>
      <CTS>false</CTS>
      <DTR>false</DTR>
      <DSR>false</DSR>
      <DCD>false</DCD>
      <RI>false</RI>
    </Invert_RS232_Signals>
    <CBUS_Signals>
      <C0>GPIO</C0>
      <C1>GPIO</C1>
      <C2>GPIO</C2>
      <C3>GPIO</C3>
    </CBUS_Signals>
    <IO_Pins>
      <DBUS>
        <SlowSlew>false</SlowSlew>
        <Schmitt>false</Schmitt>
        <Drive>4mA</Drive>
      </DBUS>
      <CBUS>
        <SlowSlew>false</SlowSlew>
        <Schmitt>false</Schmitt>
        <Drive>4mA</Drive>
      </CBUS>
    </IO_Pins>
  </Hardware_Specific>
</FT_EEPROM>"""

# End of template, start of script

print()  # blank line
if len(sys.argv) == 2:  # exactly one arg
    barcode = sys.argv[1]  # barcode is only arg
    print('[' + barcode + '] ', end ='')
else:
    print('Scan barcode to continue')
    barcode = getbarcode()  # read from input
bcerror = validate(barcode)
if bcerror == '':  # no error
    if len(barcode) == 8:
        print('Writing files for: ' + barcode[0:5] + separator + barcode[5:8])
        ftdi = barcode  # use as is, numeric
        write_files = True
    elif len(barcode) == 12:
        print('Writing files for: ' + barcode)
        ftdi = barcode[0:5] + barcode[9:12]  # extract numeric portion
        write_files = True
    else:
        print('Invalid barcode length')
else:  # returned error
    print('Invalid input (' + barcode + ') | ' + bcerror)

if write_files:
    # get product type
    if barcode[0] == '1':  # 1xxx_xxxx
        product = 'S2M2-S16'
    elif barcode[0] == '2':  # 2xxx_xxxx
        product = 'S2M2-S16'
    elif barcode[0] == '3':  # 3xxx_xxxx
        product = 'S2LP-S16'
    elif barcode[0] == '4':  # 4xxx_xxxx
        product = 'S2LP-D16'
    elif barcode[0] == '5':  # 5xxx_xxxx
        product = 'Proto, use non-barcode method'
    else:
        product = 'Invalid'
    print('Card: ' + product)
    # write
    with open('ftdi.xml', 'w', encoding="utf-16") as f:  # generic filename
        f.write(template.replace('ABCD', product).replace('9876543210', ftdi).replace('99999', ftdi[0:5]))  # programmed value is number


# EOF
