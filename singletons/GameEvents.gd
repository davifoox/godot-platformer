extends Node

signal player_died
signal character_died(character_name)

signal screen_shaked(intensity, time)

signal dialog_initiated
signal dialog_finished

#func emit_dialog_initiated(dialogue: Dialogue):
#	call_deferred("emit_signal", "dialog_initiated", dialogue)
#
#func emit_dialog_finished():
#	call_deferred("emit_signal", "dialog_finished")
	

signal music_volume_changed
signal sfx_volume_changed
