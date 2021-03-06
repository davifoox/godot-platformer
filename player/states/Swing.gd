class_name Swing
extends PlayerState

var swing_impulse = 100
var swing_friction = 25
var max_x_velocity = 200

func enter(_msg := {}) -> void:
	pass

func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	var radius = player.global_position - player.hook.global_position
	var angle = acos(radius.dot(player.velocity) / (radius.length() * player.velocity.length()))
	var rad_velocity = cos(angle) * player.velocity.length()

	player.velocity += radius.normalized() * -rad_velocity
	player.velocity += (player.hook.position - player.global_position).normalized() * delta# * player.retract_force * delta
	
	apply_friciton(delta)
	if Input.is_action_pressed("left"):
		player.velocity.x -= swing_impulse * delta
	elif Input.is_action_pressed("right"):
		player.velocity.x += swing_impulse * delta
	
	player.velocity.x = clamp(player.velocity.x, -max_x_velocity, max_x_velocity)
	
	if player.velocity.x != 0:
		player.move_direction = sign(player.velocity.x)
		
	if Input.is_action_just_pressed("down"):
		player.velocity.y = 0
	
	player.sprite.look_at(player.hook.global_position)
	player.sprite.rotation_degrees += 90
	
	#move
	player.velocity = player.move_and_slide(player.velocity, player.floor_normal)

func apply_friciton(delta):
	if abs(player.velocity.x) > 0.5:
		
		if player.move_direction == 1 and !Input.is_action_pressed("right"):
			player.velocity.x -= swing_friction * delta
		elif player.move_direction == -1 and !Input.is_action_pressed("left"):
			player.velocity.x += swing_friction * delta
	else:
		player.velocity.x = 0

func manage_transition() -> void:
	if Input.is_action_just_pressed("action1"):
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("down"):
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("action2"):
		state_machine.transition_to("Dash")

func exit() -> void:
	player.sprite.rotation_degrees = 0
