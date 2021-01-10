import re
import time
start = time.time()
colors = {0:'black', 1:'white'}
map_directions = { 'ne' : (1,0,-1), 
               'nw': (-0,+1,-1),
               'sw' : (-1,0,1), 
               'se': (0,-1,1),
                'e' : (1,-1,0), 
                'w': (-1,1,0)
            }



def _get_neighbor(coord, direction):
    offset = map_directions[direction]
    return (coord[0]+offset[0], coord[1]+offset[1], coord[2]+offset[2])

def get_neighbor(ref_coord, directions):
    coord = ref_coord
    for d in directions:
        coord = _get_neighbor(coord, d)
    return coord


tiles = {(0,0,0):0}


toggle_color = {0:1, 1:0}
ref_coord = (0,0,0)
tiles = {ref_coord:1}
tiles_n = {ref_coord:1}  
#ref = Hex(*ref_coord)

for line in open('input.txt', 'r'):
    line = line.strip()
    ref_coord = (0,0,0)
    directions = re.findall('se|e|ne|sw|w|nw', line)
    neighbor = get_neighbor(ref_coord, directions)
    
    if neighbor not in tiles:
        tiles.setdefault(neighbor, 0)
        tiles_n[neighbor] = 1
    else:
        tiles[neighbor] = toggle_color[tiles[neighbor]]
        tiles_n[neighbor] += 1
    
#directions = re.findall('se|e|ne|sw|w|nw', 'nwwswee')
#neighbor = get_neighbor(ref_coord, directions)
n_white = len([t for t in tiles.values() if t==1])
n_black = len([t for t in tiles.values() if t==0])
print('Number of tiles', len(tiles))
print('number of black tiles', n_black)
print('number of white tiles', n_white)

## part2


def art_flipping(coord, color):
    n_black = 0
    neighbors = [_get_neighbor(coord, direction) for direction in map_directions.keys()]
    blacks = [tiles.get(neighbor, 1) for neighbor in neighbors]
    n_black = sum([b==0 for b in blacks])

    if color == 0:
        # black
        if n_black == 0 or n_black>2:
            #print(coord, 'flip to black white')
            #tiles[coord] = 1
            return 1 
       
    elif color == 1:
        if n_black == 2:
            #print(coord, 'flip white to black')
            #tiles[coord] = 0
            return 0
    return color
    
def count_blacks(tiles):
    n_black = len([t for t in tiles.values() if t==0])
    return n_black


ndays = 100
for day in range(ndays):

    changes = {}
    black_tiles = dict([(t,c) for t,c in tiles.items() if c==0])

    for tile, color in black_tiles.items():
        new_color = art_flipping(tile, color)
        changes[tile] = new_color
        neighbors = [_get_neighbor(tile, direction) for direction in map_directions.keys()] 
        for ng_tile in neighbors:
            if ng_tile not in tiles:
                # tile not in list
                color = 1
            else:
                color = tiles[ng_tile]
            new_color = art_flipping(ng_tile, color)
            changes[ng_tile] = new_color
    tiles.update(changes)
    #print('day', day, count_blacks(tiles))
print('day', day, count_blacks(tiles))
print('Time %.4f second' % (time.time()-start)  )
   