import copy
import sys
import numpy as np

#test = '''.#.
#..#
####'''
#lines = test.split('\n')

lines = open('input.txt').readlines()
positions = np.array([[list(l) for l in lines]])

n_cycle = 6
n_neighbors = 26
max_z = len(positions)
max_x = len(positions [0])
max_y = len(positions [0][1])

d = {}
for z in range(max_z):
    for x in range(max_x):
        for y in range(max_y):
            d[(x,y,z)] = positions[z][x][y]

def find_neighbors_coords(pos):
    x,y,z = pos
    neighbors = []
    for ix in range(x-1, x+2):
        for iy in range(y-1, y+2):
            for iz in range(z-1, z+2):
                coord = np.array([ix,iy,iz])
                if any(coord!=pos):
                    neighbors.append(tuple(coord.tolist()))
    if len(neighbors)!=n_neighbors : 
        sys.exit(1)
    return neighbors


def count_active_neighbors(neighbors):
    return len([1 for n in neighbors if d.get(n, '.')=='#'])


def get_new_state(state, n_active):
    if state=='#': # active
        return '#' if n_active in [2,3] else '.'
    else:
        return '#' if n_active==3 else '.'


for n in range(n_cycle) :
    if n > 0:
        d = new_d.copy()
    new_d = {}
    for pos, state in d.items():
        pos_neighbors = find_neighbors_coords(pos)
        n_active = count_active_neighbors(pos_neighbors)
        new_state = get_new_state(state, n_active)
        for neighbor in pos_neighbors:
            if neighbor not in d:
                # infinite , state = '.'
                neighbor_neighbors = find_neighbors_coords(neighbor)
                n_active = count_active_neighbors(neighbor_neighbors)
                neighbor_state = get_new_state('.', n_active)
                new_d[neighbor] = neighbor_state
        new_d[pos] = new_state



    n_total_active = sum([1 for v in new_d.values() if v=='#'])
    print('Iter:', n, 'Number:', n_total_active)





    

