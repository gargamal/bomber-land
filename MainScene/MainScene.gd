extends Spatial


func _ready():
	Game.registration([$Player.playerName, $IA_poopman.playerName, $IA_shoopy.playerName, $IA_Jose.playerName])
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_EndGame_timeout():
	Game.drawScore()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true


func _process(_delta):
	ifExit()


func ifExit():
	if (Input.is_action_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
