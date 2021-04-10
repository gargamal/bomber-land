extends KinematicBody

const NB_DECTECTOR = 100
const ROTATE_DECTECTOR = PI / 8.0

var velocity = Vector3.ZERO

export (float) var lapstime = 1.5

const GRAVITY := -250
const FRICTION := 0.99

enum { UNKOWN, LOADING, EXPLODE }
var state = UNKOWN
var detectors = []
var firing = false
var bombOwner
var hasTouchEnvironnementFirst = false


func _ready():
	add_to_group("bomb")
	createAllInstanceDetector()


func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0.0
	temp_velocity *= FRICTION
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP)


func start(position :Transform, direction :Transform, speed_lauch :float, speed_fly :float, pBombOwner :KinematicBody, color :Color):
	createMaterial(color)
	
	self.global_transform = position
	velocity = speed_lauch * direction.basis.z
	velocity.y = velocity.y + speed_fly
	state = LOADING
	bombOwner = pBombOwner
	
	$Timer.start(lapstime)
	$Anim.play("color_anim")
	

func createMaterial(color: Color):
	var material = $Mesh.material_override.duplicate()
	material.albedo_color = color
	$Mesh.material_override = material


func createAllInstanceDetector():
	var i = 0
	var interval = PI * 2 / NB_DECTECTOR
	
	detectors.append($detector)
	while i < NB_DECTECTOR:
		createInstanceDetector(interval * i)
		i += 1 
	

func _on_Timer_timeout():
	if state == LOADING:
		state = EXPLODE
		
	elif state == EXPLODE:
		state = UNKOWN
		fire()


func fire():
	if not firing:
		firing = true
		detection()
		$Particles.emitting = true
		$Mesh.visible = false
		$Anim.play("light_anim")
		yield($Anim, "animation_finished")
		queue_free()


func fireBy(pBombOwner):
	if not firing:
		self.bombOwner = pBombOwner
		fire()


func detection():
	for detector in detectors:
		var body = detector.get_collider()
		if body != null and (body.is_in_group("player") or body.is_in_group("IA")):
			body.inFireBomb(bombOwner)
		elif body != null and body.is_in_group("bomb"):
			body.fireBy(bombOwner)


func push_bomb(body):
	velocity = body.speed_shoot * body.get_position().basis.z
	velocity.y = velocity.y + body.speed_fly


func createInstanceDetector(angle):
	$detector.global_rotate(Vector3(1, 0, 0), ROTATE_DECTECTOR)
	var detector = $detector.duplicate()
	detector.rotate_y(angle)
	add_child(detector)
	detectors.append(detector)
	return detector


func _on_Area_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("IA"):
		if body.playerName != bombOwner.playerName and !hasTouchEnvironnementFirst:
			body.inFireBomb(bombOwner)
			fireBy(bombOwner)

		if hasTouchEnvironnementFirst:
			push_bomb(body)
			
	elif body.is_in_group("environnement"):
		hasTouchEnvironnementFirst = true
