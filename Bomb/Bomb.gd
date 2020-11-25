extends KinematicBody

var velocity := Vector3.ZERO

const GRAVITY := -9.8 * 5

func _ready():
	add_to_group("weapon")


func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if (is_on_floor()):
		velocity = Vector3.ZERO
	velocity = move_and_slide(velocity, Vector3.UP)
	


func start(position : Transform, direction : Transform, speed_vertical : float, speed_horizontal : float):
	self.global_transform = position
	velocity.x = speed_vertical * -direction.basis.z.x
	velocity.y = speed_horizontal
	velocity.z = speed_vertical * -direction.basis.z.z
