
instr = open('input.txt', 'r').readlines()
instr = [l.strip() for l in instr]
instr = [(l.split(' ')[0], int(l.split(' ')[1])) for l in instr]
instr_ori = instr.copy()

# Task one ----------------------
seen = []
acc = 0
i = 0
while True:
    if i in seen:
        break
    opr = instr[i][0]
    val = instr[i][1]
    seen.append(i)
    if opr == 'acc': 
        acc += val
        i += 1
    elif opr == 'jmp':
        i = i + val
    else : 
        i += 1
#print('seen:', seen)
print('Accumulator value:', acc)
print('---------')


## Task two --------------------------
def run_code(instr):
    seen = []
    acc = 0
    i = 0
    while True:
        if i in seen:
            #print('in seen')
            return -1
        if i > len(instr)-1:
            #print('End of instructions')
            return acc
        opr = instr[i][0]
        val = instr[i][1]
        seen.append(i)
        if opr == 'acc': 
            acc += val
            i += 1
        elif opr == 'jmp':
            i = i + val
        else : 
            i += 1

for ix in range(len(instr)):
    instr_o = instr_ori.copy()
    instr_i = instr_o[ix]
    if 'nop' in instr_i:
        instr_o[ix] = ('jmp', instr_i[1])
    elif 'jmp' in instr_i: 
        instr_o[ix] = ('nop', instr_i[1])
    else:
        continue
    acc = run_code(instr_o)
    if acc > -1:
        #print(ix)
        #print(instr_o[ix], instr_ori[ix])
        break
  
print('Accumulator value: ', acc)

    

