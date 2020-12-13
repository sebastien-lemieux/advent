filename = 'input.txt'
actions = [l.strip() for l in open(filename,'r')]
actions = [(l[0], int(l[1:])) for l in actions]

pos = [0,0]
cap = [10,1]

def rotate90(xy, clockwise=True):
    x, y = xy
    return [y,-x] if clockwise else [-y,x]
     
def change_direction(cap, action):
    r = action[0]
    degree = action[1]
    o = int(degree/90)
    for i in range(o):
        cap = rotate90(cap, r=='R')
    return cap

def move(action, pos):
    global cap
    d = action[0]
    n = action[1]
    if d=='F':
        pos[1] +=  cap[1]*n
        pos[0] +=  cap[0]*n
    
    if d=='N':
        cap[1] += n
    elif d=='S':
        cap[1] -= n
    elif d=='W':
        cap[0] -= n
    elif d=='E':
        cap[0] += n
    else:
        if d in ['R', 'L']:
            cap = change_direction(cap, action)
    return pos

for action in actions:
    #print(cap, pos, '-->', action, end =" ")
    pos = move(action, pos)
    #print('-->', cap, pos)
    
print('Manhattan distance : ', sum([abs(n) for n in pos]))

    

       



