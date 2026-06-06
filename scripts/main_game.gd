extends Node2D

@onready var score_label: Label = $CanvasLayer/HBoxContainer/ScoreLabel
@onready var spawn_timer: Timer = $Timer
var survival_time: float = 0.0
var score: int = 0
var difficulty_factor: float = 1.0
const MAX_DIFFICULTY: float = 5.0
const DIFFICULTY_RAMP_SPEED: float = 0.01
const BASE_SPAWN_TIME: float = 1.5
const MIN_SPAWN_TIME: float = 0.2

func _ready() -> void:
	if spawn_timer:
		spawn_timer.wait_time = BASE_SPAWN_TIME
		spawn_timer.start()
	# Hides the cursor during gameplay so it doesn't distract the player
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Spawning Frogs randomly to the game, 
func spawn_frog():
	var new_frog = preload("uid://criqxbnu1qhx2").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_frog.global_position = %PathFollow2D.global_position
	add_child(new_frog)

# Spawning Worms randomly to the game, 
func spawn_worm():
	var new_worm = preload("uid://fixywb6ublc5").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_worm.global_position = %PathFollow2D.global_position
	add_child(new_worm)

# Spawning Trees randomly in the game.
func spawn_trees():
	var new_trees = preload("res://scenes/tree.tscn").instantiate()
	# Pick a random spot along the outer PathFollow2D ring
	%PathFollow2D.progress_ratio = randf()
	new_trees.global_position = %PathFollow2D.global_position
	# Add the tree to the level map
	add_child(new_trees)

# Spawning Spikes randomly in the game.
func spawn_spikes():
	var new_spike = preload("res://scenes/spike.tscn").instantiate()
	# Pick a random spot along the outer PathFollow2D ring
	%PathFollow2D.progress_ratio = randf()
	new_spike.global_position = %PathFollow2D.global_position
	# Add the tree to the level map
	add_child(new_spike)

# Spawning Bushes randomly in the game.
func spawn_bushes():
	var new_bush = preload("res://scenes/bush.tscn").instantiate()
	# Pick a random spot along the outer PathFollow2D ring
	%PathFollow2D.progress_ratio = randf()
	new_bush.global_position = %PathFollow2D.global_position
	# Add the tree to the level map
	add_child(new_bush)

func _on_timer_timeout() -> void:
	# List of all current frogs and worms in the level
	var frog_count = get_tree().get_nodes_in_group("frog").size()
	var worm_count = get_tree().get_nodes_in_group("worm").size()
	# Only spawn a new one if there are fewer than 30 slimes on the map
	if frog_count < 20:
		spawn_frog()
	if worm_count < 20:
		spawn_worm()
	
	# Spawning Trees, Bushes and Spikes
	var spawn_multiplier: int = floor(difficulty_factor)
	if randf() > 0.1: 
		for i in range(spawn_multiplier):
			spawn_trees()
			
	# SPAWN SPIKES: Lowered requirement to > 0.2 (80% chance to spawn)
	if randf() > 0.2:
		for i in range(spawn_multiplier):
			spawn_spikes()
			
	# SPAWN BUSHES: Lowered requirement to > 0.3 (70% chance to spawn)
	if randf() > 0.3:
		for i in range(spawn_multiplier):
			spawn_bushes()

func _on_player_health_depleted() -> void:
	Global.final_score = score
	var minutes: int = int(score / 60)
	var seconds: int = int(score % 60)
	var final_time_string: String = "%02d:%02d" % [minutes, seconds]
	$GameOver/ColorRect/VBoxContainer/GameOverScoreLabel.text = "You Survived: " + final_time_string + " seconds!"
	%GameOver.visible = true
	get_tree().paused = true
	MusicManager.play_menu_music()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	$GameOver/ColorRect/Restart.release_focus()
	get_tree().reload_current_scene()

# Adding timer based score function
func _process(delta: float) -> void:
	if not get_tree().paused:
		survival_time += delta
		score = floor(survival_time)
		var minutes: int = int(score / 60)
		var seconds: int = int(score % 60)
		var time_string: String = "%02d:%02d" % [minutes, seconds]
		score_label.text = "TIME: " + time_string + "s"

func update_difficulty():
	var current_step: int = floor(survival_time / 30)
	difficulty_factor = min(1.0 + (current_step * 0.5), MAX_DIFFICULTY)
	if spawn_timer:
		var new_wait_time = BASE_SPAWN_TIME / difficulty_factor
		var target_time = max(new_wait_time, MIN_SPAWN_TIME)
		if spawn_timer.wait_time != target_time:
			spawn_timer.wait_time = target_time
