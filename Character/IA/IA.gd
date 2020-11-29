extends "res://Character/Character.gd"


var direction = Vector3.ZERO
var speed = 2.0

var changingOnRun = false


func _ready():
	add_to_group("IA")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	direction = Vector3(0.0, 0.0, 1.0)


func _physics_process(delta):
	walk(direction, delta)
	
	if not changingOnRun and is_on_wall():
		changeDirectionAfterWallContact()


func changeDirectionAfterWallContact():
	if direction.x != 0:
		changeDirection(randArray([Vector3(0, 0, 1), Vector3(0, 0, -1), Vector3(direction.x * -1, 0, 0), Vector3(direction.x * -1, 0, 1), Vector3(direction.x * -1, 0, -1)]))
	elif direction.z != 0:
		changeDirection(randArray([Vector3(1, 0, 0), Vector3(-1, 0, 0), Vector3(0, 0, direction.z * -1), Vector3(1, 0, direction.z * -1), Vector3(-1, 0, direction.z * -1)]))


func changeDirection(newDirection: Vector3):
	changingOnRun = true
	$TestWall.start()
	direction = newDirection


func _on_TestWall_timeout():
	changingOnRun = false

