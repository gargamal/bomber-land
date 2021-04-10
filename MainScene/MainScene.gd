extends Spatial


func _ready():
	Game.registration([$Player.playerName, $IA_one.playerName, $IA_two.playerName, $IA_three.playerName, $IA_four.playerName])
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_EndGame_timeout():
	Game.drawScore()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true


func _process(_delta):
	ifExit()


func ifExit():
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	elif Input.is_action_pressed("ui_restart"): 
		var _err = get_tree().change_scene("res://MainScene/MainScene.tscn")
