extends AnimationPlayer

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
			
