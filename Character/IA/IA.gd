extends "res://Character/Character.gd"


var speed = 2.0
export(Vector3) var direction := Vector3(0.0, 0.0, 1.0)

var changingOnRun = false
var last_angle = 0.0
var last_enemy = null


func _ready():
	scale = Vector3(scale_character, scale_character, scale_character)
	var ia_obj = [$bull, $cromagnon,$cyclop, $dino, $dwarf, $jose, $leg, $mago, $monster, $octopus, $rabbit, $tramp]
	for obj in ia_obj:
		obj.visible = false
	
	$LaunchCadency.start(lapstime)
	
	match character:
		Character.BULL:	$bull.visible = true
		Character.CROMAGNON:	$cromagnon.visible = true
		Character.CYCLOP:	$cyclop.visible = true
		Character.DINO:	$dino.visible = true
		Character.DWARF:	$dwarf.visible = true
		Character.JOSE:	$jose.visible = true
		Character.LEG:	$leg.visible = true
		Character.MAGO:	$mago.visible = true
		Character.MONSTER:	$monster.visible = true
		Character.OCTOPUS:	$octopus.visible = true
		Character.RABBIT:	$rabbit.visible = true
		Character.TRAMP:	$tramp.visible = true


func _physics_process(delta):
	if not isDead:
		walk(direction, delta)
		if is_on_wall() or velocity.length() < 10.0:
			changeDirectionAfterWallContact()


func changeDirectionAfterWallContact():
	if direction.x != 0:
		changeDirection(Game.randArray([Vector2(0, 1), Vector2(0, -1), Vector2(direction.x * -1, 0), Vector2(direction.x * -1, 1), Vector2(direction.x * -1, -1)]))
	elif direction.z != 0:
		changeDirection(Game.randArray([Vector2(1, 0), Vector2(-1, 0), Vector2(0, direction.z * -1), Vector2(1, direction.z * -1), Vector2(-1, direction.z * -1)]))


func changeDirection(newDirection: Vector2):
	if not changingOnRun:
		changingOnRun = true
		$TestWall.start()
		var divisor = sqrt(newDirection.x * newDirection.x + newDirection.y * newDirection.y)
		var angle =  0 if divisor == 0 else acos(newDirection.y / divisor) * (1 if newDirection.x >= 0 else -1)
		
		$tw_rotate.interpolate_property(self, "rotation", Vector3(0,last_angle,0), Vector3(0,angle,0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$tw_rotate.start()
		last_angle = angle
		direction = Vector3(newDirection.x, 0, newDirection.y)


func get_position():
	return $Launch.global_transform


func get_center():
	return $center.global_transform.origin


func _on_TestWall_timeout():
	changingOnRun = false


func _on_LaunchCadency_timeout():
	if not isDead and last_enemy != null:
		var coord3 = get_center() - last_enemy.get_center()
		var coord2 = Vector2(coord3.x, coord3.z)
		changeDirection(coord2.normalized())
		launch(get_position(), last_enemy.get_position())
	elif not isDead:
		launch(get_position(), global_transform)


func _on_Area_body_entered(body):
	if body.is_in_group("bomb"):
		body.push_bomb(self)


func _on_enemy_detect_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("IA"):
		last_enemy = body

