extends Sprite

#export(NodePath) onready var state_machine = get_node(state_machine) as StateMachine
export(int) var min_distance = 50
onready var hook_list = get_tree().get_nodes_in_group("hook")
var current_hook = null
signal hook_found(hook)
signal hook_lost
var search = true

func _process(delta):
	get_closest_hook()
	set_target_position_and_visibility()

func get_closest_hook():
	if !search:
		return
		
	for h in hook_list:
		var distance = owner.global_position.distance_to(h.global_position)
		if distance < min_distance:
			if current_hook == null:
				current_hook = h
			elif distance < owner.global_position.distance_to(current_hook.global_position):
				current_hook = h
		elif current_hook != null:
			if owner.global_position.distance_to(current_hook.global_position) > min_distance:
				current_hook = null
			
	
	if current_hook != null:
		emit_signal("hook_found", current_hook)
	else:
		emit_signal("hook_lost")
		
func set_target_position_and_visibility():
	if current_hook != null:
		visible = true
		global_position = current_hook.global_position
	else:
		visible = false
		global_position = owner.global_position

func _on_StateMachine_transitioned(state_name, previous_state_name):
	if state_name == "Swing":
		search = false
	else:
		search = true
