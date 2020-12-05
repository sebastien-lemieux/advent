
import re

optional_ = ['cid']
required_ = ['ecl', 'pid', 'eyr', 'hcl', 'byr', 'iyr', 'hgt']

def is_valid(entry):
    # required field
    c_fields = [e.split(':')[0] for e in entry.split(' ')]
    o = set(required_) - set(c_fields) - set(optional_)
    return len(o)==0

def is_valid_date(e, start, stop):
    try:
        year = int(e)
        return year >= start and year <= stop
    except Exception as ex:
        print(ex)
        return False

def is_valid_byr(e) :
    # four digits; at least 1920 and at most 2002.
    return is_valid_date(e, 1920, 2002)

def is_valid_iyr(e) :
    # four digits; at least 2010 and at most 2020.
    return is_valid_date(e, 2010, 2020)
 
def is_valid_eyr(e):
    # four digits; at least 2020 and at most 2030.
    return is_valid_date(e, 2020, 2030)
 
def is_valid_hgt(e):
    #hgt (Height) - a number followed by either cm or in:
    #If cm, the number must be at least 150 and at most 193.
    #If in, the number must be at least 59 and at most 76.
    if 'cm' in e:
        val = int(e.replace('cm','').strip())
        return val <= 193 and val >= 150
    elif 'in' in e:
        val = int(e.replace('in','').strip())
        return val <= 76 and val >=  59
    else:
        return False

def is_valid_hcl(e): 
    #hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    return len(e)==7 and re.match('#[0-9a-f]', e) != None

def is_valid_ecl(e):
    return e in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']

def is_valid_pid(e):        
    #a nine-digit number, including leading zeroes.
    return len(e)==9 and re.match('[0-9]+', e)!=None

def is_valid_cid(e):
    return True

def is_valid2(entry):
    toks = [e.split(':') for e in entry.strip().split(' ')]
    for f,v in toks:
        valid = eval('is_valid_%s' %f )(v)
        #print(f, v, valid)
        if valid==False:
            break
    return valid

# -- Main--- 

lines = open('input.txt', 'r').read()
lines = lines.split('\n')
entry = ''

n_valid = 0
count = 0
for j,line in enumerate(lines):
    if line!= '':
        entry += ' '+line
    else:
        count += 1
        
        #n_valid += is_valid(entry) ## --task 1--
        if is_valid(entry) and is_valid2(entry):
            n_valid += 1
        entry = ''

#n_valid += is_valid(entry) ## --task 1--
if is_valid(entry) and is_valid2(entry):
    n_valid += 1

print('Nb valid:', n_valid)
