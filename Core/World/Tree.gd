extends Spatial

var grow_points = []

func _ready():
	for node in get_node("GrowPoints").get_children():
		grow_points.append(node)

