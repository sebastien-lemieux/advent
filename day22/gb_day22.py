
player1 = []
player2 = []
players = [player1, player2]

i = -1
for line in open('input.txt' ,'r'):
    line = line.strip()
    if line=='':
        continue
    if 'Player' in line:
        i += 1
    else:
        players[i].append(int(line))

player1_o = player1.copy()
player2_o = player2.copy()

def play_combat(player1, player2):
    n = 0
    while True:
        n += 1
        card1 = player1[0]
        card2 = player2[0]
        player2.remove(card2)
        player1.remove(card1)
        if card1 > card2:
            player1 += [card1, card2]
        else:
            player2 += [card2, card1]

        if len(player1)==0 or len(player2)==0:
            break
    return n

rounds = play_combat(player1, player2)
print('Normal combat')
print('Number of rounds' , rounds)
winner = 0 if len(player1)>0 else 1
print('The winner is:', 'player%i' % (winner+1) )

n_cards = len(players[i])
points = list(range(n_cards, 0, -1))
score = sum([c*s for c,s in zip(players[i], points)])
print('Score:', score)
    

### ----- part2

def play_rcombat(player1, player2):
    global game
    game += 1
    local_game = game
    n = 0

    stack.setdefault(local_game, [])


    while True:
        if (player1, player2) in stack[local_game]:
            #print(local_game)
            #print('configuration seen')
            return 0
        else:
            stack[local_game].append((player1.copy(), player2.copy()))
        
        n += 1
        #print('game', local_game, 'round', n)
        #print('player1', player1)
        #print('player2', player2)
    
        # play
        card1 = player1[0]
        card2 = player2[0]
        #print('player1', card1)
        #print('player2', card2)
        player2.remove(card2)
        player1.remove(card1)
        
        if len(player1)>= card1 and len(player2)>=card2:
            w = play_rcombat(player1[0:card1].copy(), player2[0:card2].copy())
            if w==0:
                player1 += [card1, card2]
            else:
                player2 += [card2, card1]

        else:
            if card1 > card2:
                player1 += [card1, card2]
                #print('player1 wins')
            else:
                player2 += [card2, card1]
                #print('player2 wins')
        #print('---')
 
        if len(player1)==0:
            return 1
        if len(player2)==0:
            return 0
        

stack = {}
game = 0 
player1 = player1_o.copy()
player2 = player2_o.copy()
players = [player1, player2]
n = play_rcombat(player1, player2)

print('----------------')
print('Recursive combat')
print('Number of rounds' , n)
winner = 0 if len(player1)>0 else 1
print('The winner is:', 'player%i' % (winner+1) )

n_cards = len(players[i])
points = list(range(n_cards, 0, -1))
score = sum([c*s for c,s in zip(players[i], points)])
print('Score:', score)