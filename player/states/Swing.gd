class_name Swing
extends PlayerState

#func enter(_msg := {}) -> void:
#	player.set_hook_detection_monitoring(false)

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	var radius = player.global_position - player.hook.position # points away from center
	#if velocity.length() < 0.01 or radius.length() < 10: return
	var angle = acos(radius.dot(player.velocity) / (radius.length() * player.velocity.length()))
	var rad_velocity = cos(angle) * player.velocity.length()
	player.velocity += radius.normalized() * -rad_velocity
	
	player.velocity += (player.hook.position - player.global_position).normalized() * player.retract_force * delta
	
	if Input.is_action_just_released("action1"):
		state_machine.transition_to("Fall")

#func exit() -> void:
#	player.set_hook_detection_monitoring(true)
#	player.hook = null
