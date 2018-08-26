extends KinematicBody

onready var surface_material = get_node("MeshInstance").get_surface_material(0)

var default_color
var ground_target_pos

const TARGET_REACHED_DISTANCE = 0.05
const MAX_SPEED_DISTANCE = 6

export(float, 0.05, 15, 0.05) var min_speed
export(float, 0.05, 15, 0.05) var max_speed

export(float, 0.05, 60, 0.05) var look_speed

var velocity setget , get_velocity

const PUSH_FORCE = 30

func get_velocity():
	return velocity

func _ready():
	velocity = Vector3()
	default_color = surface_material.albedo_color;
	ground_target_pos = self.global_transform.origin
	set_physics_process_internal(true)

func _physics_process(delta):
	var target_distance = self.get_translation().distance_to(ground_target_pos)
	if  target_distance > TARGET_REACHED_DISTANCE:
		rotate_towards_ground_target(delta)

		var move_direction = (ground_target_pos - self.get_translation()).normalized()
		move_direction.y = 0

		var speed = clamp(target_distance / MAX_SPEED_DISTANCE * max_speed, min_speed, max_speed)
		velocity = move_direction * delta * speed
		
		transform.origin = transform.origin + velocity
	else:
		velocity = Vector3()

func rotate_towards_ground_target(delta):
	var t = self.get_transform()
	var look_at_ground_target = t.looking_at(Vector3(ground_target_pos.x, get_translation().y, ground_target_pos.z), Vector3(0, 1, 0))
	var rotation = Quat(t.basis).slerp(look_at_ground_target.basis, delta * look_speed)
	set_transform(Transform(rotation, t.origin))

func _on_mouse_down_on_terrain(position):
	ground_target_pos = position

func _on_mouse_up():
	ground_target_pos = self.get_translation()

func _on_ChangeColorButton_pressed(button_pressed_color):
	if surface_material.albedo_color.to_rgba32() == button_pressed_color.to_rgba32():
		surface_material.albedo_color = default_color
	else:
		surface_material.albedo_color = button_pressed_color