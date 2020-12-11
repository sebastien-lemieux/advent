# use every adapter
# distribution of the differences of joltage between
# charging outlet, adapters and device
# device = highest + 3
# adapters = difference of 1,2,3 lower than the rating

numbers = [int(l.strip()) for l in open('../../day10/input_day10.txt')]
device = max(numbers)+3
charging = 0

numbers += [charging, device]
numbers = sorted(numbers)

# Task one ---------------------
def get_diff(vals):
    diff = {}
    for i in range(len(vals)-1):
        d = vals[i+1]-vals[i]
        diff.setdefault(d, 0)
        diff[d] = diff[d] + 1
    return diff

diff = get_diff(numbers)   
#print(diff)
print('Number task 1:',diff[1]*diff[3])

# Task two ------------------------

parents_table = {0:[]}
children_table = {}

for i in range(1, len(numbers)):
    n = numbers[i]
    vals = [v for v in parents_table.keys() if n-v<=3 and v!=n]
    parents_table.setdefault(n, [])
    parents_table[n] = vals
    for val in vals:
        children_table.setdefault(val, [])
        children_table[val].append(n)

res = 1
valid = [0]

for i in range(1,len(numbers)):
    n = numbers[i]
    parents = parents_table[n]
    if len(parents)==1: # single path 
        o = 1
    else: 
        parents_prev = parents_table[numbers[i-1]]
        n2 = len(set(parents_prev)-set(parents))
        o = 2-n2*0.25
    res *= o
    
print('Number task 2', int(res))



# Too long, too much memory required
#valid = [0]
#for i in range(1, len(numbers)):
#    n = numbers[i]
#    valid = [v for v in valid if n-v <= 3 and n!=v]
#    valid += [n]*len(valid)
#res = len([v for v in valid if v==device])
#print('Number', int(res))


## Too long too
#def find_all_paths(graph, start, path=[]):
#    path = path + [start]
#    if start not in graph:
#        return [path]
#    paths = [path]
#    for node in graph[start]:
#        if node not in path:
#            newpaths = find_all_paths(graph, node, path)
#            for newpath in newpaths:
#                paths.append(newpath)
#    return paths
#p = find_all_paths(children_table, 0) 
#res = [v for v in p if v[-1]==device]
#print(len(res))