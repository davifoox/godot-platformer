class_name GrabLedge
extends PlayerState

func enter(_msg := {}) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	player.velocity.y = 0
	
	if InputManager.just_pressed_up:
		state_machine.transition_to("Jump")

func exit() -> void:
	player.wall_slide_cooldown.start()
