class_name GameplayCamera
extends Camera2D

var shake = 0
var intensity = 0.5

func _ready():
	GameEvents.connect("screen_shaked", self, "_on_screen_shaked")

func _process(delta):
	if shake > 0:
		offset = Vector2(cos(rad2deg(shake)), sin(rad2deg(shake))) * intensity
		shake -= delta
	else:
		offset = Vector2(0,0)
		
func shake(shake_intensity = 0.5, shake_time = 0.3):
	intensity = shake_intensity
	shake = shake_time

func _on_screen_shaked(intensity: float, time: float):
	shake(intensity, time)
