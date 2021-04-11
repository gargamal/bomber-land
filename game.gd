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
	var message = format("name", 15) + " " + format("kill", 4) + "  " + format("Suicide", 4) + "\n\n"
	for name in score:
		message += format(name, 15) + "   " + format(str(score[name][KILL]), 4) + "  " + format( str(score[name][AUTO_KILL]), 4) + "\n"
	return message

func format(word, size):
	var word_final = word
	if word.length() < size:
		for i in (size - word.length()):
			word_final += " "
	elif word.length() > size:
		word_final.substr(0, size)
		
	return word_final
