extends "res://Character/Character.gd"


var camera_change := Vector2.ZERO

export(float) var cameraAngle := 0.0
export(float) var mouseSensitivity := 0.3

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	ifExit()
	aim()
	walkChooseDirection(delta)
	launchTest()
	
func _input(event):
	if event is InputEventMouseMotion:
		camera_change = event.relative


func launchTest():
	if Input.is_action_just_pressed("launch_bomb") and launch_bomb:
		launch($Head/Camera/Launch.global_transform, $Head/Camera.get_camera_transform())


func ifExit():
	if (Input.is_action_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()


func walkChooseDirection(delta):
	var direction = Vector3.ZERO
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
	walk(direction, delta)


func aim():
	if camera_change.length() > 0:
		$Head.rotate_y(deg2rad(-camera_change.x * mouseSensitivity))
		
		var change = -camera_change.y * mouseSensitivity
		if change + cameraAngle < 90 and  change + cameraAngle > -90:
			$Head/Camera.rotate_x(deg2rad(change))
			cameraAngle += change
		camera_change = Vector2.ZERO

