extends Node2D

func _ready() -> void:
	# Hides the cursor during gameplay so it doesn't distract the player
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

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
	if frog_count < 15:
		spawn_frog()
	if worm_count < 15:
		spawn_worm()
	
	# Every time a mob spawns, let's spawn 1 or 2 trees near the edges too!
	# We roll a random number so it doesn't look completely uniform
	if randf() > 0.4: 
		spawn_trees()
	if randf() > 0.5:
		spawn_spikes()
	if randf() > 0.8:
		spawn_bushes()

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	$GameOver/ColorRect/Restart.release_focus()
	get_tree().reload_current_scene()
