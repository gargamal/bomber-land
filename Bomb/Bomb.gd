extends KinematicBody

const NB_DECTECTOR = 100
const ROTATE_DECTECTOR = PI / 8.0

var velocity = Vector3.ZERO

export (float) var lapstime = 1.5

const GRAVITY := -250
const FRICTION := 0.99

enum { UNKOWN, LOADING, EXPLODE }
var state = UNKOWN
var body_test_fire := []
var firing = false
var firing_detection = false
var is_calculating = false
var bombOwner
var hasTouchEnvironnementFirst = false


func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0.0
	temp_velocity *= FRICTION
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if !hasTouchEnvironnementFirst:
		var nb_collider = get_slide_count()
		if nb_collider > 0:
			for i in nb_collider:
				var collision = get_slide_collision(i)
				if (collision.collider.is_in_group("player") or collision.collider.is_in_group("IA")) and collision.collider.playerName != bombOwner.playerName:
					collision.collider.inFireBomb(bombOwner)
					fireBy(bombOwner)
	
	detection()


func start(position :Transform, direction :Transform, speed_lauch :float, speed_fly :float, pBombOwner :KinematicBody, color :Color):
	createMaterial(color)
	
	body_test_fire.append(pBombOwner)
	
	self.global_transform = position
	velocity = speed_lauch * direction.basis.z
	velocity.y = velocity.y + speed_fly
	state = LOADING
	bombOwner = pBombOwner
	
	var center = position 
	center.origin.y += 2
	$center_top.global_transform = center
	
	center = position
	center.origin.y += -2
	$center_bottom.global_transform = center
	$Timer.start(lapstime)
	$Anim.play("color_anim")
	

func createMaterial(color: Color):
	var material = $Mesh.material_override.duplicate()
	material.albedo_color = color
	$Mesh.material_override = material


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
		while is_calculating:
			var _is_calculating = is_calculating
		queue_free()


func fireBy(pBombOwner):
	if not firing:
		self.bombOwner = pBombOwner
		fire()


func detection():
	if firing and not firing_detection:
		firing_detection = true
		is_calculating = true
		var space_state = get_world().direct_space_state
		for body in body_test_fire:
			interaction_bomb(space_state, body, $center_top.global_transform.origin)
			interaction_bomb(space_state, body, $center_bottom.global_transform.origin)
		is_calculating = false


func interaction_bomb(space_state, body, origin):
	var result = space_state.intersect_ray(origin, body.get_center())
	if result and (result.collider.is_in_group("player") or result.collider.is_in_group("IA")):
		result.collider.inFireBomb(bombOwner)
	elif result and result.collider.is_in_group("bomb"):
		result.collider.fireBy(bombOwner)


func get_center():
	return $contact.global_transform.origin


func push_bomb(body):
	velocity = body.speed_shoot * body.get_position().basis.z
	velocity.y = velocity.y + body.speed_fly


func _on_contact_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("IA"):
		if body.playerName != bombOwner.playerName and !hasTouchEnvironnementFirst:
			body.inFireBomb(bombOwner)
			fireBy(bombOwner)

		if hasTouchEnvironnementFirst:
			push_bomb(body)
			
	elif body.is_in_group("floor"):
		hasTouchEnvironnementFirst = true


func _on_explosion_body_entered(body):
	if (body.is_in_group("player") or body.is_in_group("IA") or body.is_in_group("bomb")) and body_test_fire.find(body) == -1:
		body_test_fire.append(body)


func _on_explosion_body_exited(body):
	if (body.is_in_group("player") or body.is_in_group("IA") or body.is_in_group("bomb")) and body_test_fire.find(body) != -1:
		body_test_fire.erase(body)
