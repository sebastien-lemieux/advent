lines = open('input.txt', 'r').readlines()
line1 = lines[0].strip()
line2 = lines[1].strip()

buses_ = [b for b in line2.split(',') ]
buses = [int(b) for b in buses_ if b!='x']
minutes = [buses_.index(b) for b in buses_ if b!='x']

# Task1 -------------------------
earliest_time = int(line1)
start = earliest_time
found = False
while not found :
    for b in buses:
        if start % b == 0 :
            found = True
            break
    if found : break
    start = start + 1
    
wait_time = start-earliest_time
print('Number task1', wait_time * b)

# Task2 --------------------------
def is_valid(t, n):
    for i in range(n):
        m = buses[i]
        mod = (t % m + minutes[i] % m) % m  
        if mod != 0:
            return False
    return True

t = buses[0] 
num = buses[0] 
n = 2
o = []
c = 0 

while True:
    t += num
    if is_valid(t,n):
        c += 1
        o.append(t)
    if c > 2:
        c = 0
        n += 1
        num = o[1]-o[0]
        start = o[0]
        o = []
    if n==len(buses)+1:
        break

print('Number task 2: ', start)


