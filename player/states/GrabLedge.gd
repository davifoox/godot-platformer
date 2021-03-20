class_name GrabLedge
extends PlayerState

func enter(_msg := {}) -> void:
	player.activate_ledge_collision(true)
	
func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	
	if InputManager.just_pressed_up:
		state_machine.transition_to("Jump")

func exit() -> void:
	player.wall_slide_cooldown.start()
	player.activate_ledge_collision(false)
	
