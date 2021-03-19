extends Area2D

onready var sprite = $Sprite

func activate():
	sprite.frame = 1
	
func deactivate():
	sprite.frame = 0
	
