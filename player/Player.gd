class_name Player
extends KinematicBody2D

onready var left_wall_raycasts = $WallRaycasts/LeftWallRaycasts
onready var right_wall_raycasts = $WallRaycasts/RightWallRaycasts
onready var sprite = $Sprite
onready var wall_slide_cooldown = $Timers/WallSlideCooldown
onready var wall_jump_cooldown = $Timers/WallJumpCooldown
onready var wall_slide_sticky_timer = $Timers/WallSlideStickyTimer
onready var coyote_timer = $Timers/CoyoteTimer
onready var hook_detection = $HookDetection
onready var state_machine = $StateMachine

var velocity = Vector2()
var floor_normal = Vector2.UP
var wall_jump_velocity = Vector2(150, -270)

var gravity = 1000
var acc = 1800
var max_speed = 100
var jump_force = 270

var move_direction = 1
var wall_direction = 1

var air_h_weight_regular = 0.5
var air_h_weight_after_wall_jump = 0.05

var air_h_weight = air_h_weight_regular
var floor_h_weight = 0.5

var hook = null
var retract_force = 1000

func _physics_process(delta):
	#DEBUG
#	if hook != null:
#		print(hook.name)
#	else:
#		print("null")
	
	apply_gravity(delta)
	update_wall_direction()
	update_move_direction()
	update_flip()
	update_movement()

# Runs on all States -----------------------------------------------------------

func update_move_direction():
	move_direction = -int(InputManager.pressing_left) + int(InputManager.pressing_right)

func update_flip():
	if move_direction == 1:
		sprite.flip_h = false
		hook_detection.position = Vector2(22,-22)
	elif move_direction == -1:
		sprite.flip_h = true
		hook_detection.position = Vector2(-22,-22)
		
		
func _check_is_valid_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func update_wall_direction():
	var is_near_wall_left = _check_is_valid_wall(left_wall_raycasts)
	var is_near_wall_right = _check_is_valid_wall(right_wall_raycasts)
	if is_near_wall_left and is_near_wall_right:
		wall_direction = move_direction
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)

#func handle_wall_slide_sticking():
#	if move_direction != 0 and move_direction != wall_direction:
#		if wall_slide_sticky_timer.is_stopped():
#			wall_slide_sticky_timer.start()
#	else:
#		wall_slide_sticky_timer.stop()

func check_is_on_floor():
	return is_on_floor()

func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, -gravity, gravity * 0.3)

func update_movement():
	velocity = move_and_slide(velocity, floor_normal)
	
# ------------------------------------------------------------------------------


func _on_HookDetection_area_entered(area):
	if hook != area and state_machine.state.name != "Swing":
		hook = area

func _on_HookDetection_area_exited(area):
	if hook == area and state_machine.state.name != "Swing":
		hook = null
