
import pandas as pd
import numpy as np

# Task-1 Find 2 numbers summing to 2020 and multiply them
df = pd.read_csv('input.txt', sep='\t', header=None)
df['v'] = 2020 - df
df.columns = ['v1', 'v2']
o = df.loc[df.v2.isin(df.v1),:]
o = list(o.iloc[0,:])
print('Task1 : ', o[0]*o[1])

# Task-1 - less 'creative' option
y = 2020
values = list(df.v1.values)
n = len(values)
for i in range(n):
    for j in range(i,n):
        x1 = values[i]
        x2 = values[j]
        if x1+x2 == y:
            print(x1,x2)
            print('Task1 : ', x1*x2)
            break

# Find 3 numbers summing to 2020 and multiply them
#y = x1+x2+x3
y = 2020
values = list(df.v1.values)
n = len(values)
for i in range(n):
    for j in range(i,n):
        for k in range(j,n):
            x1 = values[i]
            x2 = values[j]
            x3 = values[k]
            if x1+x2+x3 == y:
                #print(x1,x2,x3)
                print('Task2 : ',x1*x2*x3)
                break

