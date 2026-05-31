extends CanvasLayer


func _on_start_pressed() -> void:
	get_tree().paused = false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	$ColorRect2/VBoxContainer/Start.release_focus()
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
	
	
