extends Spatial


func _ready():
	Game.registration([$Player.playerName, $IA_one.playerName, $IA_two.playerName, $IA_three.playerName, $IA_four.playerName])
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Player.spawn()
	$IA_one.spawn()
	$IA_two.spawn()
	$IA_three.spawn()
	$IA_four.spawn()
	get_tree().paused = false
	$menu/title.visible = false
	$menu/vbox_btn.visible = false
	$menu/vbox_score.visible = false


func _on_EndGame_timeout():
	menu_screen()


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		menu_screen()


func menu_screen():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$menu/title.visible = true
	$menu/vbox_btn.visible = true
	$menu/vbox_score.visible = true
	$menu/vbox_score/score.text = Game.drawScore()


func _on_new_pressed():
	var _err = get_tree().change_scene("res://MainScene/MainScene.tscn")


func _on_quit_pressed():
	get_tree().quit()
