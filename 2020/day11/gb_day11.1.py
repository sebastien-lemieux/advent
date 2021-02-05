import copy

array = [] # row, columns

for line in open('input.txt'):
    line = line.strip()
    array.append(list(line))

array_o = copy.deepcopy(array)
current_array = array

def get_seat_status(i,j,ni=1,nj=1):
    status = []
    ixs = [i-ni, i, i+nj]
    jxs = [j-nj, j, j+nj]
    for ix in ixs:
        for jx in jxs:
            if ix>=0 and jx>=0:
                if i==ix and jx==j:
                    pass
                else:
                    try:
                        status.append((ix, jx, current_array[ix][jx]))
                    except:
                        pass
    return status

def is_crowded(i,j):
    status = get_seat_status(i,j)
    return sum([e[2]=='#' for e in status if e[2]!='.'])>=4

def all_empty(i,j):
    status = get_seat_status(i,j)
    return all([e[2]=='L' for e in status if e[2]!='.'])

def print_array(array):
    print('\n'.join([''.join(line) for line in array]))

def apply_rules(i,j):
    empty = 'L'
    occupied = '#'
    seat = current_array[i][j]
    if seat==empty:
        if all_empty(i,j):
            new_array[i][j] = occupied
            return 1
    if seat==occupied:
        if is_crowded(i,j):
            new_array[i][j] = empty
            return 1
    return 0

def do_round():
    st = 0
    for i in range(len(current_array)): # row
        for j in range(len(current_array[i])): # colv
            st +=  apply_rules(i,j)
            #print_array(new_array)
            #print('----')
    return st

new_array = copy.deepcopy(current_array)
c = 0
st = -1
while st!=0:
    c += 1
    new_array = copy.deepcopy(current_array)
    st = do_round()
    current_array = copy.deepcopy(new_array)
    if c > 100:
        break

n_occupied = len(sum([[x for x in l if x=='#'] for l in new_array], []))
print('Nb occupied:', n_occupied)



