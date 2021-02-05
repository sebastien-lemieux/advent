# good code
# each allergen is found in exactly one ingredient 
# each ingredient contains zero or one allergen
# allergen are not always marked

# F contains 0 or 1 allergen
# A in 1 Food
# A can be missing

d = {}
all_ingredients = []
for line in open('input.txt','r'):
    toks = line.strip().split('(')
    ingredients = toks[0].strip().split(' ')
    allergens = toks[1].replace('contains ', '').replace(')', '')
    allergens = [a.strip() for a in allergens.split(',')]
    for allergen in allergens:
        d.setdefault(allergen, [])
        d[allergen].append(ingredients)
    all_ingredients += ingredients
        
#d = dict([(k,set(v)) for k,v in d.items()])

exclude = []
res = dict([[k, []] for k in d]) 
d = dict(sorted(d.items(), key=lambda item: -1*len(item[1])))

for k, vals in d.items():
    r = set(vals[0])-set(exclude)
    if len(vals)>1:
        for v in vals[1:]:
            r = r.intersection(v)
        if len(r)==1:
            exclude.append(list(r)[0])
    elif len(vals)==1:
        exclude.append(list(r)[0])
    #print(k, r)
    res[k] = r

res2 = dict([[k, []] for k in d]) 
res2 = dict(sorted(res.items(), key=lambda item: len(item[1])))
res2 = dict([(k, list(v)) for k,v in res2.items()])

while True:
    if all([len(v)==1  and v[0] is not None for v in res2.values()]):
        break
    for k, vals in res2.items():
        if len(vals)==1:
            exclude.append(vals[0])
        else:
            res2[k] = list(set(res2[k]) - set(exclude))
        
for k, vals in res2.items():
    if len(vals)==1:
        exclude.append(vals[0])
    else:
        res2[k] = list(set(res2[k]) - set(exclude))
        

free = set(all_ingredients) - set(exclude)
n = len([c for c in all_ingredients if c in free])
print('Nb occurences', n)
    

res2 = dict(sorted(res2.items(), key=lambda item: item[0]))
dangerous = [val[0] for val in res2.values()]
print('Dangerous ingredients:', ','.join(dangerous))