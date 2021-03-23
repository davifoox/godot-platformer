extends Node

export(PackedScene) var dust_particle
export(float) var dust_particle_y_position = 7
onready var world = get_tree().get_root()

var direction: int = 1

func spawn_dust_particle():
	var dp = dust_particle.instance()
	world.add_child(dp)
	dp.global_position = owner.global_position
	dp.global_position.y += dust_particle_y_position
	dp.scale.x = direction
