
# -- Task 1 ---
h = 3
v = 1
pos_x = 0 
pos_y = 0
number_trees = 0

lines = open('input.txt','r').readlines()
lines = [l.strip() for l in lines]
n = int(len(lines)/(len(lines[0]))*(h+1))
lines = [l*n for l in lines]
for line in lines:
    pos_x = pos_x + h
    pos_y = pos_y + v
    if pos_y == len(lines):
        break
    c = lines[pos_y][pos_x]
    
    if c == '#':
        number_trees += 1
print(F'Task1 - Nb of trees : {number_trees}')


# -- Task 2 ---
rules = [(1,1), (3,1), (5,1), (7,1), (1,2)]
max_h = 7

lines = open('input.txt','r').readlines()
lines = [l.strip() for l in lines]
n = int(len(lines)/(len(lines[0]))*(max_h+1))
lines = [l*n for l in lines]
numbers_trees = 1

for h,v in rules: 
    pos_x = 0 
    pos_y = 0
    number_trees = 0
    
    for line in lines:
        pos_x = pos_x + h
        pos_y = pos_y + v
        try:
            c = lines[pos_y][pos_x]
        except:
            break
    
        if c=='#':
            number_trees += 1

    numbers_trees = numbers_trees * number_trees
print(F'Task2 - Nb of trees : {numbers_trees}')
