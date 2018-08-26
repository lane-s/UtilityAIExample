extends Camera

export(float, 1, 60, 0.05) var snap_speed
export(Vector3) var cam_offset
export(int) var deadzone_horizontal
export(int) var deadzone_top
export(int) var deadzone_bottom

var deadzone_min
var deadzone_max

var cam_target

func _ready():
	deadzone_max = get_viewport().size - Vector2(deadzone_horizontal, deadzone_bottom)
	deadzone_min = Vector2(deadzone_horizontal, deadzone_top)

func _physics_process(delta):
	if cam_target != null:
		var move_vector = calc_move_vector(delta)
		var new_pos = get_translation() + move_vector
		set_transform(Transform(get_transform().basis, new_pos))

func calc_move_vector(delta):
	var res = Vector3()
	var screen_pos = unproject_position(cam_target.get_translation())

	var corner = true

	#Check if the target position is within the deadzone. If not, get the direction the camera needs to move in order to correct
	if screen_pos.x > deadzone_max.x or screen_pos.x < deadzone_min.x:
		var world_x_dir = get_transform().basis.x
		world_x_dir.y = 0

		if screen_pos.x < deadzone_min.x:
			res -= world_x_dir
		else:
			res += world_x_dir
	else:
		corner = false
	
	if screen_pos.y > deadzone_max.y or screen_pos.y < deadzone_min.y:
		var world_y_dir = get_transform().basis.y
		world_y_dir.y = 0

		if screen_pos.y > deadzone_max.y:
			res -= world_y_dir
		else:
			res += world_y_dir
	else:
		corner = false

	#If the camera needs to move on both the x and z axis, simply move with the same velocity as the target
	if corner:
		return cam_target.velocity
	
	#Otherwise use the component of the target's velocity in the direction that the camera should move
	res = res.normalized()
	var dot = res.dot(cam_target.velocity)
	if dot > 0:
		res = res * dot
	else:
		res *= delta * snap_speed
	
	return res

func set_target(target):
	cam_target = target
	set_translation(cam_target.get_translation() + cam_offset)

