class_name Dash
extends PlayerState

onready var tween: Tween = Tween.new()
var x_velocity: float = 0

func _ready():
	add_child(tween)
	#tween.connect("tween_completed", self, "_on_tween_completed")
	tween.connect("tween_all_completed", self, "_on_tween_completed")

func enter(_msg := {}) -> void:
	tween.stop_all()
	tween_x_velocity()
	
func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	player.velocity.y = lerp(player.velocity.y, 0, 0.5)
	player.velocity.x = x_velocity
	
	#move
	player.velocity = player.move_and_slide(player.velocity, player.floor_normal)

func manage_transition() -> void:
	if player.hook != null and Input.is_action_just_pressed("action1"):
		state_machine.transition_to("Swing")
		
func exit() -> void:
	tween.stop_all()

func tween_x_velocity(): 
	tween.interpolate_property(self, "x_velocity",
		100 * player.move_direction, 400 * player.move_direction, 0.2,
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()

func _on_tween_completed():
	state_machine.transition_to("Fall")
