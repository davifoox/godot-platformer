extends Node

export(PackedScene) var dust_particle
export(float) var dust_particle_y_position = 7
onready var world = get_tree().get_root()
var _current_state_name: String = ""

var direction: int = 1

func spawn_dust_particle():
	var dp = dust_particle.instance()
	world.add_child(dp)
	dp.global_position = owner.global_position
	dp.global_position.y += dust_particle_y_position
	dp.scale.x = direction

func _on_StateMachine_transitioned(state_name, previous_state_name):
	_current_state_name = state_name
	while _current_state_name == "Run":
		spawn_dust_particle()
		yield(get_tree().create_timer(1), "timeout") #VERDEPOIS isso custa muito processamento?
