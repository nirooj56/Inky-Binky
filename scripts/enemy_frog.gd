extends CharacterBody2D

var health = 2
@export var SPEED = 250.0
var powerup_scene = preload("uid://b6txfmbrplwf7")

# FIX: Find the player dynamically using our group tag, no matter where the slime spawns
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player:
		# Dynamic AI movement chasing the player
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * SPEED
		move_and_slide()
		
		# SAFEGUARD: Automatically despawn if the player runs too far away (2500 pixels)
		var distance = global_position.distance_to(player.global_position)
		if distance > 2500.0:
			queue_free()

func take_damage():
	health -= 1
	
	if health <= 0: # Using '<=' is safer practice than '==' for health tracking
		# 1. Spawning the death smoke explosion effect
		const SMOKE_SCENE = preload("uid://dhmhmrth6rdce")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		
		# --- SPAWN DROPS ---
		if randf() > 0.85: 
			var drop = powerup_scene.instantiate()
			drop.global_position = global_position
			get_tree().current_scene.call_deferred("add_child", drop)
		
		# 2. Delete the slime from the game map
		queue_free()

func die() -> void:
	# 15% chance to drop a powerup bottle when a mob is crushed
	if randf() > 0.85:
		var drop = powerup_scene.instantiate()
		drop.global_position = global_position
		# Add it to the main world map so it stays stationary on the ground
		get_tree().current_scene.call_deferred("add_child", drop) 
	queue_free() # Destroy the mob
