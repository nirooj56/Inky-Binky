extends CanvasLayer

@onready var main_menu_quit_button: Button = $ColorRect2/VBoxContainer/Quit

func _ready() -> void:
	if OS.has_feature("web") or OS.has_feature("mobile") or OS.has_feature("android"):
		main_menu_quit_button.hide()
		

func _on_start_pressed() -> void:
	get_tree().paused = false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	$ColorRect2/VBoxContainer/Start.release_focus()
	MusicManager.play_game_music()
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
