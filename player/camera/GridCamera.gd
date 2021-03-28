class_name GridCamera
extends GameplayCamera

onready var grid_size = get_viewport().size
var grid_position = Vector2()
export(NodePath) onready var target = get_node(target)

func _ready():
#	set_as_toplevel(true)
	update_grid_position()

func _physics_process(delta):
	update_grid_position()

func update_grid_position():
	var x = floor(target.global_position.x/ grid_size.x)
	var y = floor(target.global_position.y / grid_size.y)
	var new_grid_position = Vector2(x,y)
	if grid_position == new_grid_position:
		return
	grid_position = new_grid_position
	global_position = grid_position * grid_size
