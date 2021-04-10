extends Node

var score = {}

enum {KILL, AUTO_KILL}


func randArray(list :Array)-> Vector2:
	randomize()
	return list[randi() % list.size()]


func registration(playerName :Array):
	if score.size() == 0:
		for player in playerName:
			score[player] = [0, 0]


func addKill(killer : String, victim : String):
	if killer == victim:
		score[killer][AUTO_KILL] += 1
	else:
		score[killer][KILL] += 1


func drawScore():
	print("name\tkill\tauto kill")
	for name in score:
		print(name + "\t" + str(score[name][KILL]) + "\t" + str(score[name][AUTO_KILL]))
