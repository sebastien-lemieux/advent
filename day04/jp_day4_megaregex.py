import re

hits = 0
passpt = ''
mega_regex = '^{} {}{} {} {} {} {} {}$'.format(
    'byr:({})'.format('|'.join([str(i) for i in range(1920, 2003)])),
    '(cid:[a-zA-Z0-9]+\s)?',
    'ecl:({})'.format('|'.join(['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'])),
    'eyr:({})'.format('|'.join([str(i) for i in range(2020, 2031)])),
    'hcl:(#[0-9a-f]{6})',
    'hgt:(({})cm|({})in)'.format(
        '|'.join([str(i) for i in range(150, 194)]),
        '|'.join([str(i) for i in range(59, 77)])
    ),
    'iyr:({})'.format('|'.join([str(i) for i in range(2010, 2021)])),
    'pid:[0-9]{9}'
)

print(mega_regex)

validation_re = re.compile(mega_regex)

with open('input.txt') as input:
    for line in input:
        line = line.strip()
        if line:
            passpt += line + ' '
        else:
            passpt = ' '.join(sorted(passpt.split()))
            if validation_re.match(passpt):
                hits += 1

            passpt = ''

# pesky last line
passpt = ' '.join(sorted(passpt.split()))
if validation_re.match(passpt):
    hits += 1

print(hits)
