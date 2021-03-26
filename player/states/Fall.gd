class_name Fall
extends PlayerState

var air_h_weight: float

func enter(_msg := {}) -> void:
	if state_machine.last_state_name == "WallJump" or state_machine.last_state_name == "Swing":
		air_h_weight = player.air_h_weight_small
	else:
		air_h_weight = player.air_h_weight_regular
	if state_machine.last_state_name == "Run":
		player.velocity.y = 0
		player.coyote_timer.start()

func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	if Input.is_action_pressed("left"):
		player.velocity.x = max(player.velocity.x - player.acc * delta, -player.max_speed)
	elif Input.is_action_pressed("right"):
		player.velocity.x = min(player.velocity.x + player.acc * delta, player.max_speed)
	else:
		player.velocity.x = lerp(player.velocity.x , 0, air_h_weight)
	if player.velocity.x != 0:
		player.move_direction = sign(player.velocity.x)
#	if Input.is_action_pressed("down"): #VERDEPOIS
#		player.velocity.y += player.push_down_speed * delta
	if Input.is_action_just_pressed("action1"):
		player.jump_buffer.start()
	
	#move
	player.velocity = player.move_and_slide(player.velocity, player.floor_normal)

func manage_transition() -> void:
	if player.check_is_on_floor():
		state_machine.transition_to("Idle")
	elif !player.coyote_timer.is_stopped() and (Input.is_action_just_pressed("action1") or !player.jump_buffer.is_stopped()):
		state_machine.transition_to("Jump")
	elif player.wall_direction != 0 and player.wall_slide_cooldown.is_stopped():
		state_machine.transition_to("WallSlide")
	#VERDEPOIS buga quando o player deslizou numa parede até cair, entrando no estado fall
	#nesse caso quando dá o wall_jump vai na mesma direção da parede
	elif !player.wall_slide_cooldown.is_stopped() and Input.is_action_just_pressed("action1") and player.move_direction != 0:
		state_machine.transition_to("WallJump")
	elif player.hook != null and Input.is_action_just_pressed("action1"):
		state_machine.transition_to("Swing")
	elif Input.is_action_just_pressed("action2"):
		state_machine.transition_to("Dash")
