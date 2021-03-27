class_name EdgeBalance
extends PlayerState

#func enter(_msg := {}) -> void:
#	player.velocity.x = 0

func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	player.velocity.x = lerp(player.velocity.x, 0, player.floor_h_weight)
	
	if !player.raycast_down_right.is_colliding() and player.raycast_down_left.is_colliding():
		player.move_direction = 1
	elif !player.raycast_down_left.is_colliding() and player.raycast_down_right.is_colliding():
		player.move_direction = -1
	
	#move
	player.velocity = player.move_and_slide_with_snap(player.velocity,Vector2(0,8), player.floor_normal)
	
func manage_transition() -> void:
	if Input.is_action_pressed("left"):
		state_machine.transition_to("Run")
	elif Input.is_action_pressed("right"):
		state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("action1") or !player.jump_buffer.is_stopped():
		state_machine.transition_to("Jump")
	elif player.check_is_on_floor() == false:
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("action2"):
		state_machine.transition_to("Dash")
#	elif player.velocity.x != 0:
#		state_machine.transition_to("Idle")
#	elif !player.check_is_on_platform_edge():
#		state_machine.transition_to("Idle")
