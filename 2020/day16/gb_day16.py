
lines = open('input.txt').readlines()

# Parse rules
rules = {}
for ix, line in enumerate(lines):
    line = line.strip()
    if line =='':
        break
    toks = line.split(':')
    field = toks[0].strip()
    rules.setdefault(field, [])
    ranges = toks[1].split('or')
    for r in ranges:
        r = r.strip()
        i = int(r.split('-')[0])
        j = int(r.split('-')[1])
        rules[field] += list(range(i,j+1))


# Task1
all_rules = sum(rules.values(), [])
res = 0
valid_tickets = []
offset = 5
for i, line in enumerate(lines[ix+offset:]):
    numbers = line.strip().split(',')
    numbers = [int(n) for n in numbers]
    not_valid = set(numbers)- set(all_rules) 
    res += sum(not_valid)
    if len(not_valid)==0:
        valid_tickets.append(numbers)

print('Number task 1: ', res)

# Task2
# Extract the possible position for each field
nfields = len(valid_tickets[0])
o = {}
for n in range(nfields):
    numbers_i = [v[n] for v in valid_tickets] 
    for field,rule in rules.items():
        o.setdefault(field, [])
        not_valid = set(numbers_i)- set(rule) 
        if len(not_valid) == 0:
            o[field].append(n)

# Find the field position
field_pos = {}
keys_sorted = sorted(o, key=lambda k: len(o[k]))
for k in keys_sorted:
    vals = o[k]
    if len(vals)==1:
        v0 = vals[0]
        field_pos[k] = v0
        del o[k]
        for k1,v1 in o.items():
            if v0 in v1:
                o[k1].remove(v0)

# Get my ticket
for i,line in enumerate(lines):
    if 'your ticket' in line:
        break
myticket = lines[i+1].strip().split(',')

# Compute the required number
res = 1
for k,v in field_pos.items():
    if 'departure' in k:
        res *= int(myticket[v])
print('Number task 2:',res) #410460648673