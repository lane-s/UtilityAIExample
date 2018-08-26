extends WorldEnvironment

onready var player = get_node("Player")
onready var navigation = get_node("Navigation")
onready var camera = get_node("Camera")

signal mouse_down_on_terrain(pos)
signal mouse_up

var mouse_down_on_terrain = false
var mouse_was_down_on_terrain = false

var mouse_world_pos

func _ready():
	randomize()
	self.connect("mouse_down_on_terrain", player, "_on_mouse_down_on_terrain")
	self.connect("mouse_up", player, "_on_mouse_up")
	camera.set_target(player)

func _process(delta):
	if mouse_down_on_terrain:
		if not mouse_was_down_on_terrain:
			mouse_was_down_on_terrain = true
		emit_signal("mouse_down_on_terrain", mouse_world_pos)
	elif not mouse_down_on_terrain and mouse_was_down_on_terrain:
		mouse_was_down_on_terrain = false
		emit_signal("mouse_up")

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		mouse_down_on_terrain = false

func _on_WorldPlane_input_event(camera, event, position, click_normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		mouse_down_on_terrain = true
		mouse_world_pos = position

	if event is InputEventMouseMotion and mouse_down_on_terrain:
		mouse_world_pos = position
