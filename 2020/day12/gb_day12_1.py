filename = 'input.txt'
actions = [l.strip() for l in open(filename,'r')]
actions = [(l[0], int(l[1:])) for l in actions]
pos = [0,0]
cap = 'E'

def change_direction(cap, action):
    r = action[0]
    degree = action[1]
    choices_ = {'R' : ['E', 'S', 'W', 'N'],
                'L' : ['E', 'N', 'W', 'S']}
    choices  = choices_[r]
    o = int(degree/360*4)
    i = choices.index(cap)
    i = (i+o)%len(choices)
    return choices[i]

def move(action, pos):
    global cap
    d = action[0]
    n = action[1]
    if d=='F':
        d=cap

    if d=='N':
        pos[1] += n
    elif d=='S':
        pos[1] -= n
    elif d=='W':
        pos[0] -= n
    elif d=='E':
        pos[0] += n
    else:
        if d in ['R', 'L']:
            cap = change_direction(cap, action)
    return pos

for action in actions:
    #print(cap, pos, '-->', action, end =" ")
    pos = move(action, pos)
    #print('-->', pos)
    
print('Manhattan distance : ', sum([abs(n) for n in pos]))

    

       


