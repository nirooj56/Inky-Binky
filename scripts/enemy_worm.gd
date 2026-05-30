extends CharacterBody2D

var health = 1
@export var SPEED = 250.0

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
		
		# 2. Delete the slime from the game map
		queue_free()
