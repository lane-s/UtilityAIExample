extends RigidBody

export(float) var max_growth_time = 40
export(float) var min_growth_time = 25

export(float) var min_size = 10
export(float) var max_size = 20

var start_scale
var target_scale

var growth_time
var growth_time_elapsed


onready var mesh = get_node("Mesh")

func _ready():
	mode = MODE_KINEMATIC
	var size = randf()*(max_size - min_size) + min_size
	start_scale = mesh.scale
	target_scale = Vector3(size, size, size)

	growth_time = randf()*(max_growth_time - min_growth_time) + min_growth_time
	growth_time_elapsed = 0

func _process(delta):
	if growth_time_elapsed < growth_time:
		growth_time_elapsed += delta
		var t = growth_time_elapsed / growth_time

		mesh.scale = start_scale.linear_interpolate(target_scale, t)
	else:
		mode = MODE_RIGID

func _on_Fruit_body_entered(body):
	pass


