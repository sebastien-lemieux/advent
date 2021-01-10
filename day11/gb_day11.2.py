import copy

array = [] # row, columns

for line in open('input.txt'):
    line = line.strip()
    array.append(list(line))

array_o = copy.deepcopy(array)
current_array = array
nrows = len(array)
ncols = len(array[0])

def get_seat_status(i,j):
    # first visible in all directions
    neighbors = []

    for ni in range(i+1, nrows):
        s = current_array[ni][j]
        if s!='.':
            neighbors.append((ni,j,s))
            break
    for ni in range(i-1, -1, -1):
        s = current_array[ni][j]
        if s!='.':
            neighbors.append((ni,j,s))
            break
    for nj in range(j+1, ncols):
        s = current_array[i][nj]
        if s!='.':
            neighbors.append((i,nj,s))
            break
    for nj in range(j-1, -1, -1):
        s = current_array[i][nj]
        if s!='.':
            neighbors.append((i,nj,s))
            break

    for n in range(1,nrows):
        if i+n<nrows and j+n<ncols:
            s = current_array[i+n][j+n]
            if s!='.':
                neighbors.append((i+n, j+n,s))
                break
    for n in range(1,nrows):
        if i-n>=0 and j-n>=0:
            s = current_array[i-n][j-n]
            if s!='.':
                neighbors.append((i-n, j-n,s))
                break

    for n in range(1,nrows):
        if i+n<nrows and j-n >= 0:
            s = current_array[i+n][j-n]
            if s!='.':
                neighbors.append((i+n, j-n,s))
                break
    
    for n in range(1,nrows):
       if i-n>=0 and j+n<ncols:
            s = current_array[i-n][j+n]
            if s!='.':
                neighbors.append((i-n, j+n,s))
                break

    return neighbors


def is_crowded(i,j, n=4):
    status = get_seat_status(i,j)
    return sum([e[2]=='#' for e in status if e[2]!='.'])>=n

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
        if is_crowded(i,j,n=5):
            new_array[i][j] = empty
            return 1
    return 0

def do_round():
    st = 0
    for i in range(nrows): # row
        for j in range(ncols): # cols
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



