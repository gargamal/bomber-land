extends Area

export (Vector2) var north = Vector2(1, 0)
export (Vector2) var south = Vector2(-1, 0)
export (Vector2) var west = Vector2(0, 1)
export (Vector2) var east = Vector2(0, -1)


func _on_ControlPoint_body_entered(body):
	if body.is_in_group("IA"):
		body.changeDirection(getNewDirection())


func getNewDirection()-> Vector2:
	var list = []
	if north != Vector2.ZERO:
		list.append(north)
	if south != Vector2.ZERO:
		list.append(south)
	if west != Vector2.ZERO:
		list.append(west)
	if east != Vector2.ZERO:
		list.append(east)
		
	return Game.randArray(list)

