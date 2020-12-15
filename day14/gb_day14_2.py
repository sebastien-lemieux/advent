import itertools

def to_bitstring(arr):
    s = ['0']*36
    for i in arr:
        s[i] = '1'
    return ''.join(s)

def to_value(arr):
    return int(to_bitstring(arr),2)

def num_tobitix(num, n=36):
    # keeping only index of set bit (bit=1)
    bit = "{0:b}".format(num)
    bit = list(bit)[::-1]
    ix = [n-i-1 for i in range(len(bit)) if bit[i]!='0']
    return ix

def apply_mask(arr, mask):
    alt = [] # floating bits
    for i,c in enumerate(mask):
        if i not in arr and c=='1': 
            arr.append(i)
        if c=='X':
            alt.append(i)

    # generate all combinations of indexes from floating bits
    pos = []
    for n in range(len(alt)+1):
        pos += list(itertools.combinations(alt, n))
    
    # remove index from array found in alt
    # as it would not create alternative bits
    tmp = [x for x in arr if x not in alt]
    
    # add arr index to each possibilities
    pos = [list(p)+tmp for p in pos]
    return [to_value(p) for p in pos]
    
def set_value(pos, num, mask):
    global mem
    arr = num_tobitix(pos, n=36)
    pos_list = apply_mask(arr, mask)
    for pos in pos_list:
        mem[pos] = num

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
        set_value(pos, num, mask)


print(sum(mem.values()))
