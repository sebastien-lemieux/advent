
# First task
success = []
failed = []
for line in open('input.txt','r'):
    toks = line.strip().split(':')
    rule = toks[0].strip()
    rule_parts = rule.split(' ')
    passw  = toks[1].strip()

    minl = int(rule_parts[0].split('-')[0])
    maxl = int(rule_parts[0].split('-')[1])
    lett = rule_parts[1]

    n = passw.count(lett)
    if n <= maxl and n>= minl:
        success.append(line)
    else:
        failed.append(line)
print(F'Task1 - Nb successes : {len(success)}')


# Second task
success = []
failed = []
for line in open('input.txt','r'):
    line = line.strip()
    toks = line.split(':')
    rule = toks[0].strip()
    rule_parts = rule.split(' ')
    passw  = toks[1].strip()

    minl = int(rule_parts[0].split('-')[0])
    maxl = int(rule_parts[0].split('-')[1])
    lett = rule_parts[1]
   
    if (passw[minl-1] == lett and passw[maxl-1]!= lett) or \
       (passw[minl-1] != lett and passw[maxl-1]== lett) :
        success.append(line)
    else:
        failed.append(line)

print(F'Task2 - Nb successes : {len(success)}')

