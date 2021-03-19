extends Area2D



func _on_Hook_area_entered(area):
	var player = area.owner
	player.hook = self

func _on_Hook_area_exited(area):
	var player = area.owner
	if player.hook == self:
		player.hook = null
