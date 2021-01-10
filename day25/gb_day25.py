

denom = 20201227

def set_val(val, subject_num):
    val = val * subject_num
    val = val % denom
    return val

def find_loopsize(key, subject_num):
    i = 0
    val = 1
    while True:
        if key==val:
            break
        val = set_val(val, subject_num)
        i += 1
    return i

card_key = 5290733 # 8184785 # 5290733 # 5764801
door_key = 15231938 #5293040 # 15231938 #17807724
subject_num = 7
loop_size_card = find_loopsize(card_key, subject_num)
loop_size_door = find_loopsize(door_key, subject_num)
print(loop_size_card)
print(loop_size_door)

def encrypt(loop_size, subject_num):
    val = 1
    for i in range(loop_size):
       val = set_val(val, subject_num)
    return val

encryption_key = encrypt(loop_size_card, door_key)
print(encryption_key)

#6198540
