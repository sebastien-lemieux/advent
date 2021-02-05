
#1. 3 cups after the current
#2. Select destination cup, current label minus one if not in the 3 cups
# if lower than the value will wrap
#3. Add back the 3 keeps clockwise
#4. Select new current cup : clockwise of the current cup


class Cup():
    def __init__(self, val):
        self.val = val 
        self.left = None
        self.right = None

    def __repr__(self):
        return str(self.val)

cups = [int(i) for i in list('784235916')]
nmax = 1000000
cups += list(range(max(cups)+1, nmax+1))
values_index = dict([(val, i) for i,val in enumerate(cups)])
cups = [Cup(val) for val in cups]

for i, cup in enumerate(cups):
    cup.left = cups[i-1]
    if i+1==len(cups):
        cup.right = cups[0]
    else:
        cup.right = cups[i+1]

def str_cups(n):
    s = ''
    cup = cups[-1]
    for i in range(n):
        cup = cup.right
        s += str(cup.val) +','
    s = s.strip(',')
    return s
 
icurrent = 0
current = cups[icurrent]
verbose = False

niter = 10000000
verbose = False
for i in range(niter):
    
    if verbose:
        print('-----------')
        print('move %i'%(i+1))
        print('current', current)
        print('cups',)
        print(str_cups(len(cups)))

    three = []
    three_vals = []
    right = current.right
    for i in range(3):
        three.append(right)
        three_vals.append(right.val)
        right = right.right

    dest_val = current.val - 1
    if dest_val < 1 :
            dest_val = nmax

    if verbose:
        print('pick up', three)
        print(dest_val)
        print(dest_val in [t for t in three_vals])

    while dest_val in three_vals:
        if dest_val < 1 :
            dest_val = nmax
        else:
            dest_val = dest_val-1
            if dest_val == 0:
                dest_val = nmax
                break


    def get_dest(dest_val):
        dest = cups[values_index[dest_val]]
        return dest
    dest = get_dest(dest_val)
    
    # Arrange new links/ left right neighbors
    current.right = three[-1].right
    block_left = dest
    block_right = dest.right
    dest.right = three[0]
    three[0].left = dest
    three[-1].right = block_right
    current = current.right

cup = cups[values_index[1]]
print('Cup 1', cup.left, cup.right, cup.right.right)
print('Number', cup.right.val*cup.right.right.val)

    