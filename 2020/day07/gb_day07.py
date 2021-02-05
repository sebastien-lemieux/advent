rules = {}
rules_p = {}
n = 0
for line in open('input.txt'):
    n += 1
    ix = line.strip().index('contain')
    parent = line[0:ix].strip().replace('bags', '').strip()
    children = line[ix+len('contain'):].strip()
    children = children.split(',')
    children = [c.replace('bags', '').replace('bag', '').replace('.', '').replace('no', '0').strip() for c in children]
    children = [(int(c.split(' ')[0]), ' '.join(c.split(' ')[1:])) for c in children]
    if parent in rules:
        print('parent already in rules')
        print(rules[parent])
    rules[parent] = children
    for c in children:
        if c[0] != 0:
            rules_p.setdefault(c[1], [])
            rules_p[c[1]].append(parent)

# Task one -----------------------
my_bag = 'shiny gold'
res = []
def find_col(col):
    global res
    if col in rules_p:
        for col in rules_p[col]:
            find_col(col)
            res.append(col)
        
find_col(my_bag)
colors = set(res)
print('Nb colors : ', len(colors))

# Task tow ----------------------------
counts = 0
def count_col(col):
    global counts
    if col in rules:
        c = 0
        for n, new_col in rules[col]:
            c += n + n*count_col(new_col)
        return c
    return 0

counts = count_col(my_bag)
print('Nb : ', counts)


