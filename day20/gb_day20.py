import numpy as np
import copy
import sys

tiles = {}

# 10x10 squares
for line in open('input.txt', 'r'):
    line = line.strip()
    if line == '':
        continue
    elif 'Tile' in line:
        tile_id = int(line.split(' ')[-1].strip(':'))
        tiles[tile_id]=[]
    else:
        line = line.replace('.', '0').replace('#', '1')
        line = [int(s) for s in line]
        tiles[tile_id].append(line)

class Tile(object):
    def __init__(self, id, arr):
        self.ori = np.array(arr).copy()
        self.array = np.array(arr)
        self.id = id
        self.hflip = False
        self.vflip = False
        self.rotation = 0
        self.nin = [0,0,0,0]

        self.nin[0] = self.top.sum()
        self.nin[1] = self.bottom.sum()
        self.nin[2] = self.left.sum()
        self.nin[3] = self.right.sum()
        self.borders=['top', 'bottom', 'left', 'right']
        
    @property 
    def spec(self):
        return (self.id, self.hflip, self.vflip, self.rotation)

    @property
    def top(self):
        return self.array[0,:]

    @property
    def bottom(self):
        return self.array[-1,:]

    @property
    def left(self):
        return np.ravel(self.array[:,0])

    @property
    def right(self):
        return np.ravel(self.array[:,-1])
    
    def get_border(self, border):
        try:
            return eval('self.%s'%border)
        except:
            return None

    def flip_h(self):
        self.hflip = True
        self.array = np.fliplr(self.array)

    def flip_v(self):
        self.vflip = True
        self.array = np.flipud(self.array)

    def rotate(self):
        self.rotation += 90
        n = self.rotation % 90 +1
        self.array = np.rot90(self.array, k=n)

    def __repr__(self):
        return str(self.id)
        

tiles = [Tile(k,v) for k,v in tiles.items()]
n_tiles = int(np.sqrt(len(tiles)))
n_numbers = tiles[0].array.shape[0]


def match_border(tile, other):
    num = which_border(tile, other)
    return sum(num)

def which_border(tile, other):
    borders=['top', 'bottom', 'left', 'right']
    num = [0,0,0,0]
    tborders = np.array([tile.get_border(b) for b in borders])
    oborders = np.array([other.get_border(b) for b in borders])
    num[3] = int((tile.get_border('right')==other.get_border('left')).all())
    num[2] = int((tile.get_border('left')==other.get_border('right')).all())
    num[1]= int((tile.get_border('bottom')==other.get_border('top')).all())
    num[0] = int((tile.get_border('top')==other.get_border('bottom')).all())
    return num

# Generates conformation
tiles_o = copy.deepcopy(tiles)
tiles_ = copy.deepcopy(tiles_o)

_ = [other.flip_h() for other in tiles_]
tiles +=  [copy.deepcopy(other) for other in tiles_]
#print(len(tiles))

tiles_ = copy.deepcopy(tiles)
_ = [other.flip_v() for other in tiles_]
tiles +=  [copy.deepcopy(other) for other in tiles_]
#print(len(tiles))

tiles_ = copy.deepcopy(tiles)
_ = [other.rotate() for other in tiles_]
tiles +=  [copy.deepcopy(other) for other in tiles_]

print(len(tiles))
_ = [other.rotate() for other in tiles_]
tiles +=  [copy.deepcopy(other) for other in tiles_]
print(len(tiles))
_ = [other.rotate() for other in tiles_]
tiles +=  [copy.deepcopy(other) for other in tiles_]

print(len(tiles))

# Get possibilities of match
res = {}
for i,tile in enumerate(tiles):
    res.setdefault(tile.id,[])
    for j,other in enumerate(tiles[i+1:]):
        if tile.id != other.id:
            n = match_border(tile, other)
            if n > 0:
                res[tile.id] += [(i, j, other.id, n)]
   

# Identify corners
org = {} 
corners = []
for k,v in res.items():
    neighbors = set([(e[2],e[3]) for e in v])
    
    nb_neighbors = len(neighbors)
    s = 'corner' if nb_neighbors==2 else ''
    org[k] = [e[0] for e in neighbors]

    print(k, nb_neighbors, neighbors, s)
    if s=='corner':
        corners.append(k)

print(corners) #29293767579581
print(corners[0]*corners[1]*corners[2]*corners[3])


def find_corner(ix):
    borders=['top', 'bottom', 'left', 'right']
    for corner in corners:
        tiles1 =[t for t in tiles if t.id == corner]
        tiles2 =[t for t in tiles if t.id == org[corner][0]]
        tiles3 =[t for t in tiles if t.id == org[corner][1]]
        t1 = tiles1[ix]
        pos = np.array([0,0,0,0])
        for t2 in tiles2:
            num = which_border(t1,t2)
            if sum(num)!=0:
                print(t1.spec, t2.spec, num)
                pos += np.array(num)
        for t3 in tiles3:
            num = which_border(t1,t3)
            if sum(num)!=0:
                print(t1.spec, t3.spec, num)
                pos += np.array(num)
        print(corner, [b for i,b in enumerate(borders) if pos[i]!=0])

def litteral_border(num):
    borders=['top', 'bottom', 'left', 'right']
    return [b for i,b in enumerate(borders) if num[i]!=0]

def which_border_l(t1,t2):
    return litteral_border(which_border(t1,t2))

def get_tile_by_tid(tid):
    return [t for t in tiles if t.id == tid][0]

def get_tile_by_id(oid):
    return [t for t in tiles if id(t)== oid][0]

        

#Fixing corner and filling arrangement
find_corner(0)

def set_arrangement(i,j,tile):
    arrangement[i][j] = tile.id
    arrangement_[i][j] = id(tile)



def set_(tile0, i, j, how):
    c = i if how in ['left', 'right'] else j
    n = 0
    while c<(arrangement.shape[1]):
        for tid in org[tile0.id]: 
            tiles_next =[t for t in tiles if t.id == tid]
            for tnext in tiles_next:
                where = litteral_border(which_border(tile0,tnext))
                print(tnext.id, where, i,j)
                if len(where)==0:
                    continue
                if how=='left' and where[0] == 'left':
                    j = j - 1
                    set_arrangement(i,j,tnext)
                    tile0 = tnext
                    c = j
                    break
                elif how=='bottom' and where[0] == 'bottom':
                    i = i + 1
                    set_arrangement(i,j,tnext)
                    tile0 = tnext
                    c = i
                    break
                elif how=='top' and where[0] == 'top':
                    i = i - 1
                    set_arrangement(i,j,tnext)
                    tile0 = tnext
                    c = i
                    break
                elif how=='right' and where[0] == 'right':
                    j = j + 1
                    set_arrangement(i,j,tnext)
                    tile0 = tnext
                    c = j
                    break
            n += 1
        if n>30:
            break

      
corner =[t for t in tiles if t.id == corners[0]][0] # input
arrangement = np.array([[-1]*n_tiles]*n_tiles)
arrangement_ = np.array([[-1]*n_tiles]*n_tiles)

i = 0
j = n_tiles-1
set_arrangement(i,j,corner)

set_(corner, i, j, 'left')
set_(corner, i, j, 'bottom')

i=0
j=0
tile0 = [t for t in tiles if id(t)==arrangement_[i,j]][0]
set_(tile0, i, j, 'bottom')

for j in range(1,arrangement.shape[0]-1):
    tile0 = [t for t in tiles if id(t)==arrangement_[i,j]][0]
    set_(tile0, 0, j, 'bottom')

# need some manual intervention... 
# to do, fix this
i=11
j=0
tile0 = [t for t in tiles if id(t)==arrangement_[i,j]][0]
set_(tile0, i, j, 'right')

i=11
j=9
tile0 = [t for t in tiles if id(t)==arrangement_[i,j]][0]
set_(tile0, i, j, 'top')

i=10
j=11
tile0 = [t for t in tiles if id(t)==arrangement_[i,j]][0]
set_(tile0, i, j, 'left')

i=9
j=11
tile0 = [t for t in tiles if id(t)==arrangement_[i,j]][0]
set_(tile0, i, j, 'left')

i=10
j=3
tile0 = [t for t in tiles if id(t)==arrangement_[i,j]][0]
set_(tile0, i, j, 'left')


#t1 = get_tile_by_tid(1993)
#tiles2 = [t for t in tiles if t.id==2297]
#for t2 in tiles2:   
#     which_border(t1,t2))
#     print(which_border(t2,t1))



# Generate big image
image = None
for i in range(0,arrangement.shape[0]):
    row = None
    for j in range(0,arrangement.shape[1]):
        t = [t for t in tiles if id(t)==arrangement_[i,j]][0]      
        arr_t = t.array
        if row is  None:
            row = arr_t
        else:
            row = np.concatenate((row, arr_t), axis=1)
    if image is None :
        image = row
    else:
        image = np.concatenate((image, row), axis=0)
    
def print_array(arr, sep_n=n_numbers, sep=True, verbose=True):
    out = ''
    for i in range(arr.shape[0]):
        if sep and i % sep_n == 0:
            if verbose:
                print('')
            out += '\n'
        s = ''
        for j in range(arr.shape[1]):
            if sep and j % sep_n == 0:
               s += '_'
            s += str(arr[i,j])
        if verbose:
            print(s)
        out += s+'\n'
    return out
       
o = print_array(image, n_numbers, sep=False)

# cropped borders
image3 = None
for i in range(0,arrangement.shape[0]):
    row3 = None
    for j in range(0,arrangement.shape[1]):
        t = [t for t in tiles if id(t)==arrangement_[i,j]][0]      
        arr_t = t.array[1:-1,1:-1] 
        if row3 is  None:
            row3 = arr_t
        else:
            row3 = np.concatenate((row3, arr_t), axis=1)
    if image3 is None :
        image3 = row3
    else:
        image3 = np.concatenate((image3, row3), axis=0)

out3 = print_array(image3, 8, sep=False)




# Look for sea monsters
sea_monster_patt='''
                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
'''
patt = sea_monster_patt.split('\n')[1:-1]
n_spaces = image3.shape[0]-len(patt[0])
sea_monster = patt[0].lstrip()+' '*n_spaces+patt[1]+' '*n_spaces+patt[2].rstrip()
sea_monster_ix = [i for i in range(len(sea_monster)) if sea_monster[i]=='#']
sea_monster_ix = np.array(sea_monster_ix)

def count_monsters(img_monster, sea_monster_ix):
    n_monster = 0
    for i in range(len(img_monster)-len(sea_monster)):
        if img_monster[sea_monster_ix+i].sum() == len(sea_monster_ix):
            print(i)
            n_monster += 1
    return n_monster


img = image3
n = 0 
stop = False
for i in range(2):
    if stop:
        break
    for j in range(2):
        if stop:
            break
        for k in range(4):
            if i == 1:
                img = np.fliplr(img)
            if j == 1:
                img = np.flipud(img)
            img = np.rot90(img, k)
            out3 = print_array(img, 8, sep=False, verbose=False)
            out4 = out3.replace('\n', '')
            out4 = np.array(list(out4)).astype(int)
            n = count_monsters(out4, sea_monster_ix)
            print(i,j,k,n)
            if n!=0:
                stop = True
                break
        

       

# Compute number of active 

n_monster = count_monsters(out4, sea_monster_ix)


n_active = image3.sum()-n_monster*len(sea_monster_ix)
print('Number of monsters', n_monster)
print('Number of active', n_active) #1989
