extends Spatial


var list_ControlPoint = []


func _ready():
	add_to_group("room")
	list_ControlPoint.append($ControlPoint/P1.global_transform)
	list_ControlPoint.append($ControlPoint/P2.global_transform)
	list_ControlPoint.append($ControlPoint/P3.global_transform)
	list_ControlPoint.append($ControlPoint/P4.global_transform)
	list_ControlPoint.append($ControlPoint/P5.global_transform)
	list_ControlPoint.append($ControlPoint/P6.global_transform)
	list_ControlPoint.append($ControlPoint/P7.global_transform)
	list_ControlPoint.append($ControlPoint/P8.global_transform)
	list_ControlPoint.append($ControlPoint/P9.global_transform)


func getRespawn():
	return Game.randArray(list_ControlPoint)
