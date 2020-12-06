#  3 - lines  ---- (GB,LN)

seat_ids = [int(seat.strip().replace('F','0').replace('B','1').replace('R','1').replace('L','0'),2) for seat in open('input.txt', 'r')]
print('Max seat id: ', max(seat_ids))
print('My seat id: ', sum(range(min(seat_ids), max(seat_ids)+1)) - sum(seat_ids))



# OR wiht  more lines  --- (GB)

def find_(strseq, letter_lower, n):
    elems = list(range(0, n))
    for c in list(strseq):
        mid = int(len(elems)/2)
        start, stop = (0,mid) if c == letter_lower else (mid, len(elems))
        elems = elems[start:stop]
    return elems[0]
        
def find_row(seat):
    seat = seat[0:7]
    return find_(seat, 'F', 128)
    
def find_col(seat):
    seat = seat[-3:]
    return find_(seat, 'L', 8)

def find_seat_id(seat):
    r = find_row(seat)
    c = find_col(seat)
    seat_id = r * 8 + c
    return seat_id

seat_ids = [find_seat_id(line.strip()) for line in open('input.txt', 'r')]
print('Max seat id: ', max(seat_ids))

seat_ids = sorted(seat_ids)
seat_id = [seat_ids[i] for i in range(0, len(seat_ids)) if seat_ids[i]-seat_ids[i-1]!=1 and seat_ids[i]!=seat_ids[0]][0]-1
print('My seat id: ', seat_id)




