class_name GrabLedge
extends PlayerState

func enter(_msg := {}) -> void:
	player.activate_ledge_collision(true)
	player.velocity.x = 0
	
func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	#move
	player.velocity = player.move_and_slide(player.velocity, player.floor_normal)
	
	if Input.is_action_just_pressed("action1"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("down"):
		state_machine.transition_to("WallSlide")


func exit() -> void:
	player.wall_slide_cooldown.start()
	player.activate_ledge_collision(false)
	
