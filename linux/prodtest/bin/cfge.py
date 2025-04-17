# cfg4pt reads the info file and generates a dictionary the original cfg.edit string
# 2025-04-04: change cfgpath and filename for linux

import os

# constants
pcount = 27  # total parameters displayed by cfg
pmax = 25  # parameters you can enter in cfg edit

# pseudo #defines
WINDOWS = os.name == 'nt'
LINUX = os.name == 'posix'
do_pause = True  # for timer at end

# set path based on OS
if WINDOWS:
    cfgpath = 'C:\\EdgeCortix\\'
elif LINUX:
    cfgpath = '/home/ec/prodtest/bin'
else:
    print('Unknown OS')
    cfgpath = '.'

# containers
params = []
for i in range(pcount):
    params.append('MISSING: ' + str(i))
# debug: print(params)

# FUNCTIONS

def GetIndex(s):
    indices = {
        'Board Name': 0,
        'Variant': 1,
        'Serial (text)': 2,
        'Serial Number': 3,
        'Board Revision': 4,
        'ECN Level': 5,
        'DDR Type': 6,
        'Sakura Version': 7,
        'Mfg Date': 8,
        'ECN DATE': 9,
        'P0V8_LDO Enbl': 10,
        'P3V3_3 Enable': 11,
        'CBLimit': 12,
        'PLL Freq MHz': 13,
        'PCIe Lane Setting': 14,
        'pMode': 15,
        'vCore (mV)': 16,
        'CBEnableA': 17,
        'CBEnableB': 18,
        'CBDelay (mS)': 19,
        'BMC max temp C': 20,
        'Sakura max temp C': 21,
        'Board max temp C': 22,
        'powerUp Enable': 23,
        'Sakura Enable': 24,
        'powerUp Start': 25,
        'PowerUp BIST': 26,
    }
    try:
        index = indices[s]
    except:
        index = -1
    return index
# End

# END FUNCTIONS

# read cfg.edit
with open (os.path.join(cfgpath,'foo-cfge'), 'r') as f:
    lines = f.readlines()

for rawline in lines:
    line = rawline.strip()
    # print(line)
    kv = line.split('=')  # good lines are k = v
    if len(kv) == 2:
        k = kv[0].strip()
        v = kv[1].strip()
        i = GetIndex(k)  # get list index for this key
        if i < 0:  # error
            print('Key not found: ' + k)
        else:
            v = v.split('(')[0].strip()  # remove any trailing (x) text
            if v.endswith(' C'):
                v = v[:-2]  # remove space C
            datecode = v.split('.')
            if len(datecode) == 3:
                v = v.replace('.', '')  # is datecode, replace dot with nothing
            else:
                v = v.replace('.', '[DOT]')  # is not datecode, replace dot with script version
            v = v.replace('-', '[DASH]')  # replace dash with script version
            params[i] = v
        # debug: print(k + '=' + v) 
    elif len(line) > 0:
        pass  # debug: print('Discarding: ' + line)
    else:
        pass  # blank line
prefix = 'cfg.edit+'
config = '+'.join(params[:pmax])
suffix = '+C'
print(prefix + config + suffix)

if WINDOWS and do_pause:
    os.system('timeout /t 60')  # windows only, keep window open, keystroke ends it instantly        

# EOF
