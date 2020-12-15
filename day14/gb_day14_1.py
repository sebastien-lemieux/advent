def to_bitstring(arr):
    s = ['0']*36
    for i in arr:
        s[i] = '1'
    return ''.join(s)

def to_value(arr):
    return int(to_bitstring(arr),2)

def apply_mask(pos, mask):
    global mem
    imask = [i for i in range(len(mask)) if mask[i]!='X']
    for ipos in imask:
        if ipos in mem[pos] and mask[ipos]=='0':
            mem[pos].remove(ipos) 
        if ipos not in mem[pos] and mask[ipos]=='1': 
            mem[pos].append(ipos)

def num_to_bitix(num, n=36):
    bit = "{0:b}".format(num)
    bit = list(bit)[::-1]
    ix = [n-i-1 for i in range(len(bit)) if bit[i]!='0']
    return ix

def set_value(pos,num, n=36):
    global mem
    mem.setdefault(pos, [])
    ix = num_to_bitix(num, n=36)
    mem[pos] = ix


mem = {}

mask = None
for line in open('input.txt', 'r'):
    toks = line.strip().split('=')
    if 'mask' in line:
        mask = toks[1].strip()
    else:
        pos = toks[0].strip().split('[')[1].replace(']', '')
        pos = int(pos)
        num = int(toks[1].strip())
        set_value(pos, num, len(mask))
        apply_mask(pos, mask)

print(sum([to_value(v) for v in mem.values()]))
