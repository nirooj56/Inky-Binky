extends AudioStreamPlayer

const MENU_MUSIC = preload("res://assets/audio/menu_track.mp3")
const GAME_MUSIC = preload("res://assets/audio/gameplay.ogg")

func _ready() -> void:
	# Automatically play the main menu theme when the game boots up
	play_menu_music()

func play_menu_music() -> void:
	if stream == MENU_MUSIC and playing:
		return 
	stream = MENU_MUSIC
	play()

func play_game_music() -> void:
	if stream == GAME_MUSIC and playing:
		return
	stream = GAME_MUSIC
	play()
