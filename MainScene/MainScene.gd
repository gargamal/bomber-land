extends Spatial


func _ready():
	Game.registration([$Player.playerName, $IA_poopman.playerName, $IA_shoopy.playerName, $IA_Jose.playerName])
