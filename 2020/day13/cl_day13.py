def parseInfo(mes) :
	time = int(mes[0])
	bus1 = [int(i) for i in mes[1].split(',') if i != 'x']
	bus2 = [i for i in mes[1].split(',')]

	return time, bus1, bus2


### Get input from .txt
def readFile(fn) :
	with open(fn, 'r') as f :
		mes = f.readlines()

	tmp = [l.strip()  for l in mes ]

	return parseInfo(tmp)


### Solution to first problem
def firstProblem(time, bus) :
	time_stamp = time
	bus_dep = False

	while not bus_dep:

		tmp = [time_stamp%i for i in bus]
	    
		if 0 in tmp :
			print ('BUS FOUND :', bus[tmp.index(0)])
			print ('DEPARTURE TIME:', time_stamp)
			bus_dep = True
	        
		else :
			time_stamp += 1

	print ('Must wait: ', time_stamp - time, 'minutes')
	print ('Product: ', bus[tmp.index(0)] * (time_stamp - time))


### Solution to second problem
def getTimeBus(ts, idx) :
	#print ('%d%s%s = %d' % (ts, '%', idx, ))
	return ts%idx

def secondProblem(time, bus, bus_str) :
	### Time in minutes of bus departure from first bus
	time_after = [i for i in range(len(bus_str)) if bus_str[i] != 'x']

	### Find first time with bus1 departure
	first_time = time

	for i in range(bus[0]+1) :
		if first_time%bus[0] == 0 :
			break
		else :
			first_time = time + i
	        
	print ('Search starts at: ', first_time)

	### Start search
	time_stamp = first_time
	jump = bus[0]

	i = 1

	while i != len(bus) :
		#print ('Time: ', time_stamp, time_stamp+time_after[i], bus[i], getTimeBus(time_stamp+time_after[i], bus[i]))

		if getTimeBus(time_stamp+time_after[i], bus[i]) == 0 :
			print ('--- Bus ', bus[i], 'leaves at', time_stamp+time_after[i])
			jump = jump * bus[i]
			i += 1
			print ('--- New jump: ', jump)
	        
		else :
			time_stamp += jump
        
	print ('Bus ID', bus[0], 'departs at timestamp', time_stamp)



### Input
time, bus1, bus2 = readFile('day_13_input.txt')

### Test exemple
#mes = ['939', '7,13,x,x,59,x,31,19']
#time, bus1, bus2 = parseInfo(mes)


print ('----> First Problem')
firstProblem(time, bus1)
print ()

print ('----> Second Problem')
secondProblem(time, bus1, bus2)
print ()

