extends KinematicBody2D

onready var left_wall_raycasts = $WallRaycasts/LeftWallRaycasts
onready var right_wall_raycasts = $WallRaycasts/RightWallRaycasts
onready var sprite = $Sprite
onready var wall_slide_cooldown = $Timers/WallSlideCooldown
onready var wall_jump_cooldown = $Timers/WallJumpCooldown
onready var wall_slide_sticky_timer = $Timers/WallSlideStickyTimer
onready var coyote_timer = $Timers/CoyoteTimer

var velocity = Vector2()
var floor_normal = Vector2.UP
var wall_jump_velocity = Vector2(120, -210)

var gravity = 750
var acc = 1000
var max_speed = 110
var jump_force = 270

var move_direction = 1
var wall_direction = 1

var air_h_weight_regular = 0.5
var air_h_weight_after_wall_jump = 0.05

var air_h_weight = air_h_weight_regular
var floor_h_weight = 0.5


func check_is_on_floor():
	return is_on_floor()

func _air_movement(delta):
	if InputManager.pressing_left:
		velocity.x = max(velocity.x - acc * delta, -max_speed)
	elif InputManager.pressing_right:
		velocity.x = min(velocity.x + acc * delta, max_speed)
	else:
		velocity.x = lerp(velocity.x , 0, air_h_weight)

#func handle_wall_slide_sticking():
#	if move_direction != 0 and move_direction != wall_direction:
#		if wall_slide_sticky_timer.is_stopped():
#			wall_slide_sticky_timer.start()
#	else:
#		wall_slide_sticky_timer.stop()


# Runs on all States -----------------------------------------------------------

func update_move_direction():
	move_direction = -int(InputManager.pressing_left) + int(InputManager.pressing_right)
	
func update_flip():
	if move_direction == 1:
		sprite.flip_h = false
	elif move_direction == -1:
		sprite.flip_h = true

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

func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, -gravity, gravity * 0.3)
	
func update_movement():
	velocity = move_and_slide(velocity, floor_normal)
	
# ------------------------------------------------------------------------------


# Specific States Logic --------------------------------------------------------

func idle_state():
	velocity.x = lerp(velocity.x, 0, floor_h_weight)
	
	
	
func run_state(delta):
	if InputManager.pressing_left:
		velocity.x = max(velocity.x - acc * delta, -max_speed)
	elif InputManager.pressing_right:
		velocity.x = min(velocity.x + acc * delta, max_speed)



func enter_jump_state():
	velocity.y = -jump_force
	
func jump_state(delta):
	_air_movement(delta)
	if !InputManager.pressing_up:
		velocity.y *= 0.5



func enter_fall_state(air_h_weight_value):
	air_h_weight = air_h_weight_value
	
func fall_state(delta):
	_air_movement(delta)
	
	
	
func wall_slide_state():
	if velocity.y < 0 and InputManager.just_released_up:
		velocity.y *= 0.5
	
	if move_direction != 0 and move_direction == wall_direction:
		velocity.y = clamp(velocity.y, -gravity, gravity * 0.1)
	
	


func enter_wall_jump_state(direction):
	var wall_jump_force = wall_jump_velocity
	wall_jump_force.x *= direction
	velocity = wall_jump_force
	wall_jump_cooldown.start()

func wall_jump_state():
	if InputManager.just_released_up:
		velocity *= 0.5

	
	
func dash_state():
	pass



func swing_state():
	pass
	
	
	
func stop_state():
	pass

# ------------------------------------------------------------------------------
