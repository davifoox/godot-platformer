extends AnimationPlayer


var direction: int = 1

func _on_StateMachine_transitioned(state_name, previous_state_name):
	match previous_state_name:
		"Fall":
			play("Reset")
		"Jump":
			play("Reset")
	match state_name:
		"Idle":
			if previous_state_name == "Fall":
				play("HitFloor")
		"Jump":
			play("Jump")
		"Fall":
			play("Fall")
		"WallJump":
			play("WallJump")
		"WallSlide":
			if previous_state_name != "GrabLedge":
				if direction == 1:
					play("WallSlideRight")
				elif direction == -1:
					play("WallSlideLeft")
		"Dash":
			play("Dash")
#		"Run":
#			_spawn_dust_particle() #VERDEPOIS pensando em colocar signals nos estados mesmo

func play_animation(animation_name: String):
	play(animation_name)
