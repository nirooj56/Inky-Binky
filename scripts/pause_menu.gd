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

# If you hid the cursor during gameplay, show it here so they can click buttons!
	if new_pause_state:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	if OS.has_feature("mobile") or OS.has_feature("android"):
		mobile_pause_button.visible = !new_pause_state
	
	# MOUSE CAPTURE LOGIC 
	if new_pause_state:
		# Game is PAUSED: Show the mouse so they can click menu buttons
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		# Game is RESUMED: Lock the mouse back into the gameplay
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_resume_pressed() -> void:
	toggle_pause()

func _on_quit_pressed() -> void:
	# Always make sure the mouse is visible before leaving the gameplay loop
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if OS.has_feature("mobile") or OS.has_feature("android"):
		# Unpause the engine so the menu scene actually runs!
		get_tree().paused = false 
		# Change back to your start menu instead of killing the app
		get_tree().change_scene_to_file("res://scenes/game_screen.tscn") # (Make sure this matches your exact Main Menu scene filename)
	else:
		# Desktop players can still close the application normally
		get_tree().quit()

func _on_mobile_pause_button_pressed() -> void:
	# Release focus so it doesn't trap keyboard inputs if a keyboard is plugged in
	mobile_pause_button.release_focus()
	
	# Trigger the exact same menu layout toggle
	toggle_pause()
