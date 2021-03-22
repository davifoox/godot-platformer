extends Sprite

#export(NodePath) onready var state_machine = get_node(state_machine) as StateMachine
export(String) var target_tipe
export(int) var max_distance = 50

onready var target_list = get_tree().get_nodes_in_group(target_tipe)
var search: bool = true

var last_target = null
var current_target = null

signal target_changed(current_target)

func _process(delta):
	_find_target()
	_set_target_position_and_visibility()

func _find_target():
	if !search:
		return
		
	for t in target_list:
		var distance = owner.global_position.distance_to(t.global_position)
		if distance < max_distance:
			if current_target == null:
				current_target = t
			elif distance < owner.global_position.distance_to(current_target.global_position):
				current_target = t
		elif current_target != null:
			if owner.global_position.distance_to(current_target.global_position) > max_distance:
				current_target = null
			
	if last_target != current_target:
		emit_signal("target_changed", current_target)
	
	last_target = current_target
		
func _set_target_position_and_visibility():
	if current_target != null:
		visible = true
		global_position = current_target.global_position
	else:
		visible = false
		global_position = owner.global_position

func _on_StateMachine_transitioned(state_name, previous_state_name):
	if state_name == "Swing":
		search = false
	else:
		search = true
