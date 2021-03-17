extends StateMachine

func _ready():
	add_state("IDLE")
	add_state("RUN")
	add_state("JUMP")
	add_state("FALL")
	add_state("DASH")
	add_state("WALL_SLIDE")
	add_state("WALL_JUMP")
	add_state("SWING")
	add_state("STOP")
	call_deferred("set_state", states.IDLE)

func _state_logic(delta):
	match state:
		states.IDLE:
			parent.idle_state()
		states.RUN:
			parent.run_state(delta)
		states.JUMP:
			parent.jump_state(delta)
		states.FALL:
			parent.fall_state(delta)
		states.WALL_SLIDE:
			parent.wall_slide_state()
		states.WALL_JUMP:
			parent.wall_jump_state()
	
	parent.apply_gravity(delta)
	parent.update_move_direction()
	parent.update_flip()
	parent.update_wall_direction()
	parent.update_movement()
	
func _get_transition(_delta):
	match state:
		states.IDLE:
			if InputManager.pressing_left or InputManager.pressing_right:
				return states.RUN
			elif InputManager.just_pressed_up:
				return states.JUMP
		states.RUN:
			if !InputManager.pressing_left and !InputManager.pressing_right:
				return states.IDLE
			elif !parent.check_is_on_floor():
				return states.FALL
			elif InputManager.just_pressed_up:
				return states.JUMP
		states.JUMP:
			if parent.wall_direction != 0 and parent.wall_slide_cooldown.is_stopped():
				return states.WALL_SLIDE
			elif parent.velocity.y >= 0:
				return states.FALL
		states.FALL:
			if parent.check_is_on_floor():
				if InputManager.pressing_left or InputManager.pressing_right:
					return states.RUN
				else:
					return states.IDLE
			elif parent.wall_direction != 0 and parent.wall_slide_cooldown.is_stopped():
				return states.WALL_SLIDE
			elif !parent.wall_slide_cooldown.is_stopped() and InputManager.just_pressed_up and parent.move_direction != 0:
				return states.WALL_JUMP
			elif !parent.coyote_timer.is_stopped() and InputManager.just_pressed_up:
				return states.JUMP
		states.WALL_SLIDE:
#			parent.handle_wall_slide_sticking()
			if parent.check_is_on_floor():
				return states.IDLE
			elif parent.wall_direction == 0:
				return states.FALL
			if InputManager.just_pressed_up:
				return states.WALL_JUMP
		states.WALL_JUMP:
			if parent.wall_jump_cooldown.is_stopped():
				return states.FALL 
				# fazer também que nem no jump normal (se soltar o botao reduz o impulso do wall jump)
			if parent.check_is_on_floor():
				if InputManager.pressing_left or InputManager.pressing_right:
					return states.RUN
				else:
					return states.IDLE
			if parent.wall_direction != 0 and parent.wall_slide_cooldown.is_stopped():
				return states.WALL_SLIDE
	
	return null
	
func _enter_state(new_state, old_state):
	print(states.keys()[state])
	match new_state:
		states.JUMP:
			parent.enter_jump_state()
		states.WALL_JUMP:
			if old_state == states.WALL_SLIDE:
				parent.enter_wall_jump_state(-parent.wall_direction)
			elif old_state == states.FALL:
				parent.enter_wall_jump_state(parent.move_direction)
		states.FALL:
			if old_state == states.WALL_JUMP:
				parent.enter_fall_state(parent.air_h_weight_after_wall_jump)
			else:
				parent.enter_fall_state(parent.air_h_weight_regular)
				
func _exit_state(old_state, new_state):
	match old_state:
		states.WALL_SLIDE:
			parent.wall_slide_cooldown.start()
		states.RUN:
			if new_state == states.FALL:
				parent.coyote_timer.start()
			
			
func _on_WallSlideStickyTimer_timeout():
	if state == states.WALL_SLIDE:
		set_state(states.FALL)
		#parent.exit_wall_slide_state()
