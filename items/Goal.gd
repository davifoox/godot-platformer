extends Area2D

signal player_reached_goal

func _on_Goal_body_entered(body: Node) -> void:
	emit_signal("player_reached_goal")
