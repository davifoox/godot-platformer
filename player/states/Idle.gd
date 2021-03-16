class_name Idle
extends PlayerState


func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	print("IDLE")


func physics_update(delta: float) -> void:
#	if not player.is_on_floor():
#		state_machine.transition_to("Air")
#		return
	
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
#	if Input.is_action_just_pressed("move_up"):
#		state_machine.transition_to("Air", {do_jump = true})
#	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
#		state_machine.transition_to("Run")
