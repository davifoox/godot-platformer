extends AnimationPlayer

func _on_StateMachine_transitioned(state_name, previous_state_name):
	if has_animation(state_name):
		play(state_name)
