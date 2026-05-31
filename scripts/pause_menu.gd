extends CanvasLayer

func _ready() -> void:
	hide() #Hides Pause Menu
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		toggle_pause()
	
func toggle_pause():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	
func _on_resume_pressed() -> void:
	toggle_pause()

func _on_quit_pressed() -> void:
	get_tree().quit()
