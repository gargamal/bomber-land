extends KinematicBody

var camera_change := Vector2.ZERO

export(float) var cameraAngle := 0.0
export(float) var mouseSensitivity := 0.3

var velocity := Vector3.ZERO
var direction := Vector3.ZERO

const GRAVITY := -9.8 * 5

export(float) var walkSpeed := 30.0
export(float) var walkAcceleration := 2.0
export(float) var walkDeacceleration := 6.0

export(float) var speed_lauch := 5.0
export(float) var speed_shoot := 10.0
export(float) var speed_fly := 20.0
export(float) var intervalle := 1.0

var launch_bomb = true

onready var _bomb = preload("res://Bomb/Bomb.tscn") 
var bomb = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	ifExit()
	aim()
	walk(delta)
	launch()
	
func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative


func launch():
	if Input.is_action_just_pressed("launch_bomb") and launch_bomb:
		bomb = _bomb.instance()
		bomb.start($Head/Camera/Launch.global_transform, $Head/Camera.get_camera_transform().basis, speed_lauch, speed_fly)
		get_parent().add_child(bomb)
		$Timer.start(intervalle)
		launch_bomb = false


func ifExit():
	if (Input.is_action_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()


func walk(delta):
	direction = Vector3.ZERO
	var aim = $Head/Camera.get_camera_transform().basis
		
	if Input.is_action_pressed("move_foward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
		
	direction = direction.normalized()
	
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


func aim():
	if camera_change.length() > 0:
		$Head.rotate_y(deg2rad(-camera_change.x * mouseSensitivity))
		
		var change = -camera_change.y * mouseSensitivity
		if change + cameraAngle < 90 and  change + cameraAngle > -90:
			$Head/Camera.rotate_x(deg2rad(change))
			cameraAngle += change
		camera_change = Vector2.ZERO


func _on_Timer_timeout():
	launch_bomb = true
