extends CanvasLayer

@onready var mobile_pause_button: Button = $MobilePauseButton

func _ready() -> void:
	$ColorRect2.hide() #Hides Pause Menu
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Check if the player is running the game on Android or iOS
	if OS.has_feature("mobile") or OS.has_feature("android"):
		mobile_pause_button.show() # Show it for touch screens
	else:
		mobile_pause_button.hide() # Hide it completely on Windows/Mac/Linux

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		toggle_pause()
	
func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	
	# Toggle the background rectangle
	$ColorRect2.visible = new_pause_state
	
	# Print a message to the output log to confirm it's running
	print("Is the color rect supposed to be visible right now? ", $ColorRect2.visible)
	
	if OS.has_feature("mobile") or OS.has_feature("android"):
		mobile_pause_button.visible = !new_pause_state
	
func _on_resume_pressed() -> void:
	toggle_pause()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_mobile_pause_button_pressed() -> void:
	# Release focus so it doesn't trap keyboard inputs if a keyboard is plugged in
	mobile_pause_button.release_focus()
	
	# Trigger the exact same menu layout toggle
	toggle_pause()
