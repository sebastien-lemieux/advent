
#1. 3 cups after the current
#2. Select destination cup, current label minus one if not in the 3 cups
# if lower than the value will wrap
#3. Add back the 3 keeps clockwise
#4. Select new current cup : clockwise of the current cup

cups = [int(i) for i in list('784235916')]

icurrent = 0
current = cups[icurrent]

for i in range(100):
    #print('-----------')
    #print('move %i'%(i+1))
    #print('current', current, 'cups', cups)
    
    three = [cups[j%len(cups)] for j in range(icurrent+1,icurrent+4)]
    #print('pick up', three)

    for c in three:
        cups.remove(c)

    dest = current-1
    if dest < min(cups):
        dest = max(cups)
    while dest in three:
        if dest < min(cups):
            dest = max(cups)
        else:
            dest = dest -1
 
    
    #print('dest', dest)
    idest = (cups.index(dest)+1)%len(cups)
    new_cups = cups[0:idest]+three+cups[idest:]
    cups = new_cups
    icurrent = (cups.index(current)+1)%len(cups)
    current = cups[icurrent]
    
    
print('Cups order:', ''.join([str(i) for i in cups]))
sequence = [str(cups[(i+cups.index(1))%len(cups)]) for i in range(len(cups))][1:]
print('Cups after 1:', ''.join(sequence))

    
#53248976