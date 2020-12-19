extends "res://Character/Character.gd"


var speed = 2.0
export(Vector3) var direction := Vector3(0.0, 0.0, 1.0)

var changingOnRun = false
var last_angle = 0.0

func _ready():
	add_to_group("IA")
	
	$jose_blue.visible = false
	$jose_brown.visible = false
	$jose_orange.visible = false
	$jose_green.visible = false
	
	$LaunchCadency.start(lapstime)
	
	match jose:
		Jose.BLUE:	$jose_blue.visible = true
		Jose.BROWN:	$jose_brown.visible = true
		Jose.ORANGE:	$jose_orange.visible = true
		Jose.GREEN:	$jose_green.visible = true


func _physics_process(delta):
	if not isDead:
		walk(direction, delta)
		if not changingOnRun and is_on_wall():
			changeDirectionAfterWallContact()


func changeDirectionAfterWallContact():
	if direction.x != 0:
		changeDirection(Game.randArray([Vector3(0, 0, 1), Vector3(0, 0, -1), Vector3(direction.x * -1, 0, 0), Vector3(direction.x * -1, 0, 1), Vector3(direction.x * -1, 0, -1)]))
	elif direction.z != 0:
		changeDirection(Game.randArray([Vector3(1, 0, 0), Vector3(-1, 0, 0), Vector3(0, 0, direction.z * -1), Vector3(1, 0, direction.z * -1), Vector3(-1, 0, direction.z * -1)]))


func changeDirection(newDirection: Vector3):
	changingOnRun = true
	$TestWall.start()
	var angle = acos(newDirection.z / sqrt(newDirection.x * newDirection.x + newDirection.z * newDirection.z)) * (1 if newDirection.x >= 0 else -1)
	
	$tw_rotate.interpolate_property(self, "rotation", Vector3(0,last_angle,0), Vector3(0,angle,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$tw_rotate.start()
	last_angle = angle
	direction = newDirection


func _on_TestWall_timeout():
	changingOnRun = false


func _on_LaunchCadency_timeout():
	if not isDead:
		launch(global_transform, global_transform)

