extends KinematicBody

var accelerate := 0.0
var velocity := Vector3.ZERO

var hight = 10.0

func _ready():
	add_to_group("fragment")


func _physics_process(delta):
	if accelerate > 0.0:
		velocity *= accelerate * delta
		velocity = move_and_slide(velocity, Vector3.UP)


func start(coord: Vector3):
	translate(coord)
	set_physics_process(false)

func fire():
	accelerate = 55.0
	velocity = translation * accelerate 
	velocity.y = 0
	set_physics_process(true)
	$Area/ColWithEnv.disabled = false


func _on_Area_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("IA"):
		body.inFireBomb(get_parent().bombOwner)
		queue_free()
	elif body.is_in_group("block"):
		queue_free()
	elif body.is_in_group("bomb"):
		body.fire()
		queue_free()
