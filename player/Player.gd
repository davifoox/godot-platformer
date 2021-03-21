class_name Player
extends KinematicBody2D

onready var state_machine: StateMachine = $StateMachine
onready var left_wall_raycasts: Node2D = $WallRaycasts/LeftWallRaycasts
onready var right_wall_raycasts: Node2D = $WallRaycasts/RightWallRaycasts
onready var sprite: Sprite = $Sprite
onready var hook_detection: Area2D = $HookDetection
onready var ledge_collision: CollisionShape2D = $LedgeCollision
onready var camera: Camera2D = $Camera2D
onready var wall_slide_cooldown: Timer = $Timers/WallSlideCooldown
onready var wall_jump_cooldown: Timer = $Timers/WallJumpCooldown
onready var coyote_timer: Timer = $Timers/CoyoteTimer
onready var jump_buffer: Timer = $Timers/JumpBuffer

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
var air_h_weight_small = 0.05

var air_h_weight = air_h_weight_regular
var floor_h_weight = 0.5

var hook = null
var retract_force = 1250#1000

func _draw():
	if state_machine.state.name == "Swing":
		draw_line(Vector2(), to_local(hook.position), Color("282828"), 2, false)

func _physics_process(delta):
	#DEBUG
	
	update() #draw
	update_wall_direction()
	update_move_direction()
	update_movement()
	if check_passing_vertical_limit() == true:
		die()

# Runs on all States -----------------------------------------------------------

func apply_gravity(delta) -> void:
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, -gravity, gravity * 0.3)

func update_movement() -> void:
	velocity = move_and_slide(velocity, floor_normal)

func update_move_direction() -> void:
	move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	update_flip()
	update_hook_detection_h_position()
	update_camera_h_position()
	update_ledge_collision_h_position()

func update_flip() -> void:
	if state_machine.state.name == "GrabLedge":
		return
	if move_direction == 1:
		sprite.flip_h = false
	elif move_direction == -1:
		sprite.flip_h = true
		
func update_hook_detection_h_position() -> void:
	if move_direction == 1:
		hook_detection.position = Vector2(30,0)
	elif move_direction == -1:
		hook_detection.position = Vector2(-30,0)

func update_camera_h_position() -> void:
	var speed = 0.025
	if move_direction != 0 and wall_direction == 0:
		camera.offset_h = lerp(camera.offset_h, move_direction, speed)

func update_ledge_collision_h_position() -> void:
	if move_direction != 0 and state_machine.state.name != "GrabLedge":
		if move_direction == 1:
			ledge_collision.position = Vector2(6,-13)
		elif move_direction == -1:
			ledge_collision.position = Vector2(-6,-13)

func activate_ledge_collision(value: bool) -> void:
	ledge_collision.disabled = !value

func check_is_on_ledge() -> bool:
	if wall_direction == 1:
		if !right_wall_raycasts.get_child(0).is_colliding(): #upper raycast
			if right_wall_raycasts.get_child(1).is_colliding(): #bottom raycast
				return true
	elif wall_direction == -1:
		if !left_wall_raycasts.get_child(0).is_colliding(): #upper raycast
			if left_wall_raycasts.get_child(1).is_colliding(): #bottom raycast
				return true
	return false

func update_wall_direction() -> void:
	var is_near_wall_left = _check_is_valid_wall(left_wall_raycasts)
	var is_near_wall_right = _check_is_valid_wall(right_wall_raycasts)
	if is_near_wall_left and is_near_wall_right:
		wall_direction = move_direction
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)
		
func _check_is_valid_wall(wall_raycasts) -> bool:
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false
	
func check_is_on_floor() -> bool:
	return is_on_floor()

func check_passing_vertical_limit() -> bool:
	print(position.y)
	if position.y > 200:
		return true
	return false

func die():
	GameEvents.emit_signal("player_died")

# ------------------------------------------------------------------------------

func _on_HookDetection_area_entered(area):
	if hook != area and state_machine.state.name != "Swing":
		hook = area
		hook.activate() #colocar isso em outro objeto HookTarget seila 

func _on_HookDetection_area_exited(area):
	if hook != null:
		hook.deactivate()
	if hook == area and state_machine.state.name != "Swing":
		hook.deactivate()
		hook = null

func set_hook_detection_monitoring(value: bool):
	hook_detection.monitoring = value
