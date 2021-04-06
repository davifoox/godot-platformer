class_name Die
extends PlayerState

func _ready():
	GameEvents.connect("player_died", self, "_on_player_died")

#func enter(_msg := {}) -> void:
#	player.velocity = Vector2(0,0)
#
#func physics_update(delta: float) -> void:
#	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

func _on_player_died():
#	print("died")
	state_machine.transition_to("Die")
