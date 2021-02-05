d = {}
myinput = [0,14,6,20,1,4]
for i,num in enumerate(myinput[:-1]):
    d[num] = i+1
    
max_n =  30000000  # task1 max_n = 2020
n = len(myinput)
next_num = myinput[-1]

while True:
    if n > max_n:
        break
    num = next_num
    if num not in d.keys():
        next_num = 0
    else:
        next_num = n - d[num]
    d[num] = n
    n += 1
print('Number task:', num)

 





    
    