extends CanvasLayer


func _on_start_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
