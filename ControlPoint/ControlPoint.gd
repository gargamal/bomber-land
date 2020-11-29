extends Area

export (Vector3) var north = Vector3.UP
export (Vector3) var south = Vector3.DOWN
export (Vector3) var west = Vector3.LEFT
export (Vector3) var east = Vector3.RIGHT


func _on_ControlPoint_body_entered(body):
	if body.is_in_group("IA"):
		body.changeDirection(getNewDirection())


func getNewDirection()-> Vector3:
	var list = []
	if north != Vector3.ZERO:
		list.append(north)
	if south != Vector3.ZERO:
		list.append(south)
	if west != Vector3.ZERO:
		list.append(west)
	if east != Vector3.ZERO:
		list.append(east)
		
	return Game.randArray(list)

