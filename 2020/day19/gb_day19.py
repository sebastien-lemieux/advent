
lines = open('input.txt', 'r').readlines()
lines = [line.strip() for line in lines]

rules = {}
for i,line in enumerate(lines):
    if line=='':
        break
    toks = line.split(':')
    rule = toks[1].strip().replace('"', '').strip()
    rules[toks[0]] = [[c for c in r.split(' ') if c!=''] for r in rule.split('|') ]

messages = []
for i,line in enumerate(lines[i+1:]):
    messages.append(line)
    
def resolve(rstack, msg):
    if len(rstack) > len(msg):
        return False
    if len(msg)==0 and len(rstack)==0:
        return True
    if len(msg)==0 and len(rstack)!=0:
        return False
    if len(rstack)==0:
        return False
    if len(msg)==0:
        return False
    
    r = rstack[0]
    rstack = rstack[1:]
    #print('msg', msg)
    #print('rstack', rstack, r)
    
    if isinstance(r, str) and r.isalpha(): 
        c = msg[0]
        if c==r:
            #print('next_rule')
            valid = resolve(rstack.copy(), msg[1:]) 
            return valid
    else:
        
        follow_rules = rules[r]
        for o in follow_rules:
            next_rule = o + rstack.copy() 
            #print(next_rule)
            valid = resolve(next_rule, msg)
            if valid:
                return True
    return False
    

res = 0
for message in messages:
    rstack = rules['0'][0]
    valid = resolve(rstack, message)
    res += int(valid)
    #print(message, valid)
print('Number valid messages 1:', res)

res = 0
rules['8'] =[['42'],['42', '8']]
rules['11'] =[['42', '31'],['42', '11', '31']]
for message in messages:
    rstack = rules['0'][0]
    valid = resolve(rstack, message)
    res += int(valid)
    #print(message, valid)
print('Number valid messages 2:', res)




    




    

