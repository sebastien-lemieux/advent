
numbers = open('input.txt', 'r').readlines()
numbers = [int(l.strip()) for l in numbers]
n_i = 25

# Taks one-------------------
def find_pair(num, choices):
    o = [num-c for c in choices]
    return set(choices)&set(o)

for i in range(n_i, len(numbers)):
    start = i-n_i 
    stop = i

    window = numbers[start:stop]
    num = numbers[i]
    
    p = find_pair(num, window)
    if len(p) == 0 :
        break
print('Number is :',  num) # 393911906

# Taks two -------------------
sum_i = 0
found = False
for start in range(len(numbers)):
    for stop in range(start+1, len(numbers)+1):
        window = numbers[start:stop]
        if sum(window)==num and len(window)>1:
            #print(start, stop, window)
            found = True
            break
    if found :
        break


print('Second number is: ', min(window) + max(window) )       
