extends Node

#GROUPS
const LEVEL_MANAGER_GROUP = "level_manager"

var SAVE_FILE_PATH
var save : SaveFile
var project_name

var total_levels_number = 0
const LEVELS_PATH = "res://levels/"

var game_clock = 0.0

func _ready():
	GameEvents.connect("music_volume_changed", self, "_on_music_volume_changed")
	GameEvents.connect("sfx_volume_changed", self, "_on_sfx_volume_changed")
	
	set_process(false)
	project_name = ProjectSettings.get_setting("application/config/name")
	SAVE_FILE_PATH = "user://" + project_name + ".tres"
	
	set_initial_save_file()
	get_levels_amount()
	update_game_settings()

func _process(delta):
	game_clock += delta

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func set_initial_save_file():
	if ResourceLoader.load(SAVE_FILE_PATH) == null:
		save = SaveFile.new()
		save_file()
	else:
		save = ResourceLoader.load(SAVE_FILE_PATH)
func save_file():
	ResourceSaver.save(SAVE_FILE_PATH, save)
func reset_save_file():
	save = SaveFile.new()
	save_file()

func start_game_clock():
	set_process(true)
func stop_game_clock():
	set_process(false)
func reset_game_clock():
	game_clock = 0.0

func get_levels_amount():
	var dir = Directory.new()
	if dir.open(LEVELS_PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
				#print("Found directory: " + file_name)
			else:
				if file_name != "BaseLevel.tscn": # if level is not the base level, icrease the variable value
					total_levels_number += 1
				#print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func get_game_clock_result():
	var time_converter = TimeConverter.new()
	return time_converter.format_time(game_clock, time_converter.FORMAT_MINUTES | time_converter.FORMAT_SECONDS)

func _on_music_volume_changed():
	save.music_on = !save.music_on
	update_game_settings()
	save_file()

func _on_sfx_volume_changed():
	save.sfx_on = !save.sfx_on
	update_game_settings()
	save_file()

func update_game_settings():
	if save.music_on:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 0)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
	
	if save.sfx_on:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 0)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)
