extends Node

var timer = 10
export(PackedScene) var menu

func _ready():
	$Sprite.modulate = "00ffffff"

func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("left_mouse_button"):
		go_to_menu()

func _process(delta):
	timer -= delta
	if timer <= 0:
		go_to_menu()
	
func _on_AnimationPlayer_animation_finished(anim_name):
	go_to_menu()

func _on_AudioIntro_finished():
	$AnimationPlayer.play("fade")

func go_to_menu():
	get_tree().change_scene_to(menu)
