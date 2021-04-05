class_name Stop
extends PlayerState

func _ready():
	GameEvents.connect("dialog_initiated", self, "_on_dialog_initiated")
	GameEvents.connect("dialog_finished", self, "_on_dialog_finished")

func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	player.velocity.x = lerp(player.velocity.x, 0, player.floor_h_weight)
	
	#move
	player.velocity = player.move_and_slide_with_snap(player.velocity,Vector2(0,8), player.floor_normal)
	
#manage_transition
func _on_dialog_initiated():
	state_machine.transition_to("Stop")
	
func _on_dialog_finished():
	state_machine.transition_to("Idle")
