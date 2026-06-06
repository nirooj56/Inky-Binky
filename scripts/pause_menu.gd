extends CanvasLayer

@onready var mobile_pause_button: Button = $MobilePauseButton
@onready var color_rect: ColorRect = $ColorRect2
@onready var quit_button: Button = $ColorRect2/VBoxContainer/Quit

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	color_rect.hide() # Hides Pause Menu overlay on boot
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Handle the Mobile Pause Button visibility
	if OS.has_feature("mobile") or OS.has_feature("android"):
		mobile_pause_button.show()
	else:
		mobile_pause_button.hide()

	# updates the Quit button text to the Main Menu on Web and Mobile
	if OS.has_feature("web") or OS.has_feature("mobile") or OS.has_feature("android"):
		quit_button.text = "Main Menu"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
	
func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	color_rect.visible = new_pause_state
	# Smooth mouse visibility handling
	if new_pause_state:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Show cursor for menu selection
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide it during gameplay
	
	if OS.has_feature("mobile") or OS.has_feature("android"):
		mobile_pause_button.visible = !new_pause_state
	
	# --- DYNAMIC PAUSE MUSIC SWAP ---
	if new_pause_state:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Show cursor
		
		MusicManager.play_menu_music()                 # 🎵 Switch to calm menu track!
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  # Hide cursor
		MusicManager.play_game_music()
	
func _on_resume_pressed() -> void:
	toggle_pause()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	if OS.has_feature("web") or OS.has_feature("mobile") or OS.has_feature("android"):
		get_tree().change_scene_to_file("res://scenes/game_screen.tscn")
	else:
		get_tree().quit()

func _on_mobile_pause_button_pressed() -> void:
	mobile_pause_button.release_focus()
	toggle_pause()
