extends KinematicBody

var velocity := Vector3.ZERO

const GRAVITY := -2500

enum Character { BULL, CROMAGNON, CYCLOP, DINO, DWARF, JOSE, LEG, MAGO, MONSTER, OCTOPUS, RABBIT, TRAMP } 

export(String) var playerName := ""
export(float) var walkSpeed := 30.0
export(float) var walkAcceleration := 2.0
export(float) var walkDeacceleration := 6.0
export(float) var speed_lauch := 5.0
export(float) var speed_shoot := 10.0
export(float) var speed_fly := 20.0
export(float) var lapstime := 0.5
export(Color) var color := Color(0.1, 0.1, 0.1, 1.0)
export(Character) var character := Character.JOSE
export(float) var scale_character := 0.2
export(float) var scale_bomb := 2.5

var launch_bomb = true

var isDead = false

onready var _bomb = preload("res://Bomb/Bomb.tscn") 
var bomb = null


func launch(position : Transform, direction : Transform):
	bomb = _bomb.instance()
	get_parent().add_child(bomb)
	bomb.start(position, direction, speed_lauch, speed_fly, self, color)
	bomb.scale = Vector3(scale_bomb, scale_bomb, scale_bomb)
	$Timer.start(lapstime)
	launch_bomb = false


func walk(direction :Vector3, delta :float):
	velocity.y += GRAVITY * delta
	var temp_velocity := velocity
	temp_velocity.y = 0
	
	var target = direction * walkSpeed
	
	var acceleration
	if direction.dot(temp_velocity):
		acceleration = walkAcceleration
	else:
		acceleration = walkDeacceleration
	
	temp_velocity = velocity.linear_interpolate(target, acceleration * delta)
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	velocity =  move_and_slide(velocity, Vector3.UP)


func _on_Timer_timeout():
	launch_bomb = true
	
	
func inFireBomb(whoseIsBomb :KinematicBody):
	if not isDead:
		isDead = true
		visible = false
		Game.addKill(whoseIsBomb.playerName, playerName)
		translate(Vector3(0, 200.0, 0))
		rotate(Vector3(1, 0, 0), -PI / 2.0)
		$TimeRespawn.start()


func _on_TimeRespawn_timeout():
	spawn()
	$TimeRespawn.stop()


func spawn():
	var room = get_parent().get_node("room")
	global_transform = room.getRespawn()
	scale = Vector3(scale_character, scale_character, scale_character)
	isDead = false
	visible = true
	
	
