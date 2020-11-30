extends KinematicBody

onready var _fragment = preload("res://Bomb/Fragment.tscn") 

var velocity = Vector3.ZERO

export (float) var lapstime = 1.5

const GRAVITY := -9.8 * 5
const friction = 0.99

enum { UNKOWN, LOADING, EXPLODE }
var state = UNKOWN
var fragments = []
var speed_vertical = 0.0
var speed_horizontal = 0.0
var touchBomb = false
var firing = false
var bombOwner

func _ready():
	add_to_group("bomb")


func _physics_process(delta):
	
	if is_on_floor() and not touchBomb:
		velocity = Vector3.ZERO
	else :
		velocity.y += GRAVITY * delta
		velocity = move_and_slide(velocity, Vector3.UP)
		touchBomb = false
		
#	velocity.y += GRAVITY * delta
	
#	var temp_velocity = velocity
#	temp_velocity.y = 0.0
#	temp_velocity *= friction
#	velocity.x = temp_velocity.x
#	velocity.z = temp_velocity.z
#	velocity = move_and_slide(velocity, Vector3.UP)
#	touchBomb = false


func start(position : Transform, direction : Transform, pSpeed_vertical : float, pSpeed_horizontal : float, pBombOwner : String, color: Color):
	var material = $Mesh.material_override.duplicate()
	material.albedo_color = color
	$Mesh.material_override = material
	
	createAllInstanceFragement()
	
	speed_vertical = pSpeed_vertical
	speed_horizontal = pSpeed_horizontal
	self.global_transform = position
	velocity = speed_vertical * -direction.basis.z
	velocity.y = speed_horizontal
	state = LOADING
	$Timer.start(lapstime)
	bombOwner = pBombOwner
	
	$Anim.play("color_anim")
	#$Mesh.material_override.albedo_color = color
	

func createAllInstanceFragement():
	var multiplier = 5.0
	for i in range(-multiplier, multiplier, 1):
		var angle1 = PI * i / multiplier
		for j in range(-multiplier, multiplier, 1):
			var angle2 = PI * j / multiplier  
			fragments.append(createInstanceFragement(6.0 * Vector3(cos(angle1) * cos(angle2), cos(angle1) * sin(angle2), sin(angle1))))


func _on_Timer_timeout():
	if state == LOADING:
		state = EXPLODE
		
	elif state == EXPLODE:
		state = UNKOWN
		fire()


func fire():
	if not firing:
		firing = true
		for i in range(0, fragments.size()):
			if fragments[i] != null:
				fragments[i].fire()
		$Particles.emitting = true
		$Mesh.visible = false
		$Anim.play("light_anim")
		yield($Anim, "animation_finished")
		queue_free()


func createInstanceFragement(coord: Vector3):
	var fragment = _fragment.instance()
	fragment.start(coord)
	add_child(fragment)
	return fragment


func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		touchBomb = true
		velocity = speed_vertical * 4.0 * -transform.basis.z
		velocity.y = speed_horizontal
		
