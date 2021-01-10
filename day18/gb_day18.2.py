#test = '1 + 2 * 3 + 4 * 5 + 6'
#test = '1 + (2 * 3) + (4 * (5 + 6))'
#test  ='2 * 3 + (4 * 5)'
#test = '5 + (8 * 3 + 9 + 3 * 4 * 3)'
#test = '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))'
#test = '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'
#test = '6+6*(8+9*6*7+4*8)*(3*2+8*(5*8+6*3*7+4))'
#lines = [test]
lines = open('input.txt', 'r').readlines()

operators = ['+', '*']

res = 0

def evaluate():
    #print('evaluate')
    op = opstack.pop()
    v2 = numstack.pop()
    v1 = numstack.pop()
    expr = f'{v1}{op}{v2}'
    #print('Expr', expr)
    new_val = eval(expr)
    numstack.append(str(new_val))

res = 0
for line in lines:
    line = line.strip().replace(' ', '')
    equation = list(line)
    i=0     
    numstack = []
    opstack = []

    while True:
        if len(numstack)>=2 and numstack[-1].isdigit() and numstack[-2].isdigit() and opstack[-1] =='+':
            evaluate()
            continue

        if len(numstack)>=3 and numstack[-1] ==')' and numstack[-3] =='(' :
            _ = numstack.pop()
            a = numstack.pop() 
            _ = numstack.pop()   
            numstack.append(a) 
            continue
    
        if i == len(equation) and len(numstack) == 1 and len(opstack) == 0:
            break

        if len(numstack)>1 and i==len(equation) and len(opstack) == 0:
            res_ = 1
            while True:
                if len(numstack)==0:
                    break
                a = numstack.pop() 
                if a=='(' :
                    break
                if a=='*':
                    continue
                res_ *= int(a)
                
            numstack.append(str(res_))
            break

        c = equation[i]
        i+=1
        if c =='+':
            opstack.append(c)
        elif c in ['(',  '*']:
            numstack.append(c)
        elif c == ')':
            res_ = 1
            
            while True:
                a = numstack.pop() 
                if a=='(':
                    break
                if a=='*':
                    continue
                res_ *= int(a)
            numstack.append(str(res_))

        else:
            numstack.append(c)

        #print('numstack:', numstack)
        #print('opstack:', opstack)
    
    res += int(numstack[0])
print('Number', res)





  