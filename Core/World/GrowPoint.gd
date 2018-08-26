extends Spatial
var Fruit = preload("res://Core/World/Fruit.tscn")

export(float) var max_no_growth_time = 30
export(float) var min_no_growth_time = 1

var growing_fruit
onready var wait_timer = get_node("Timer")

const FRUIT_Y_OFFSET = 0.2

func _ready():
	wait_timer.connect("timeout", self, "start_growing")
	wait_to_grow()

func wait_to_grow():
	wait_timer.stop()
	wait_timer.wait_time = randf()*(max_no_growth_time - min_no_growth_time) + min_no_growth_time
	wait_timer.start()

func start_growing():
	if growing_fruit != null:
		return
	
	growing_fruit = Fruit.instance()
	get_parent().add_child(growing_fruit)
	growing_fruit.global_transform.origin = global_transform.origin - Vector3(0, FRUIT_Y_OFFSET, 0)
	growing_fruit.global_transform.basis = global_transform.basis



