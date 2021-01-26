extends KinematicBody

const NB_DECTECTOR = 100
const ROTATE_DECTECTOR = PI / 8.0

var velocity = Vector3.ZERO

export (float) var lapstime = 1.5

const GRAVITY := -9.8 * 5
const friction = 0.99

enum { UNKOWN, LOADING, EXPLODE }
var state = UNKOWN
var detectors = []
var speed_vertical = 0.0
var speed_horizontal = 0.0
var firing = false
var bombOwner


func _ready():
	add_to_group("bomb")
	createAllInstanceDetector()


func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0.0
	temp_velocity *= friction
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP)


func start(position : Transform, direction : Transform, pSpeed_vertical : float, pSpeed_horizontal : float, pBombOwner : String, color: Color):
	createMaterial(color)
	
	speed_vertical = pSpeed_vertical
	speed_horizontal = pSpeed_horizontal
	self.global_transform = position
	velocity = speed_vertical * -direction.basis.z
	velocity.y = speed_horizontal
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


func createInstanceDetector(angle):
	$detector.global_rotate(Vector3(1, 0, 0), ROTATE_DECTECTOR)
	var detector = $detector.duplicate()
	detector.rotate_y(angle)
	add_child(detector)
	detectors.append(detector)
	return detector


func _on_Area_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("IA"):
		velocity = speed_vertical * 4.0 * -transform.basis.z
		velocity.y = speed_horizontal
		
