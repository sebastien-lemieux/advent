# Task one ---------------------------
count = 0
answers = ''
lines = open('input.txt').readlines()
lines.append('\n')
for line in lines:
    line = line.strip()
    answers += line
    if line == '':
        count += len(set(list(answers)))
        answers = ''
print('Number of answers (1)', count)


# Task two  --------------------------
count = 0
answers = ''
nperson = 0
lines = open('input.txt').readlines()
lines.append('\n')

for line in lines:
    line = line.strip()
    if line == '':
        answers = list(answers)
        chars = set(list(answers))
        n = 0
        for c in chars:
            n += answers.count(c)==nperson
        count += n
        answers = ''
        nperson = 0  
    else:
        answers += line   
        nperson += 1   
print('Number of answers (2)', count)


