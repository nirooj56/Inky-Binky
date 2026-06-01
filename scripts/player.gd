extends CharacterBody2D

var health = 100.0
@export var SPEED = 500
signal health_depleted
# Mobile Touch Configuration
var touch_start_position = Vector2.ZERO
var is_dragging = true
var move_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# 1. Get keyboard input direction
	var keyboard_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# 2. Decide whether to use keyboard or touch input
	if is_dragging:
		# Use the swipe direction calculated in _input()
		velocity = move_direction * SPEED
	elif keyboard_direction.length() > 0.0:
		# Use keyboard direction
		velocity = keyboard_direction * SPEED
	else:
		# Smoothly slow down to a stop if no input is active
		velocity = velocity.move_toward(Vector2.ZERO, SPEED * 0.2)
	move_and_slide()
	
	# Combat / Hurtbox Logic
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			health_depleted.emit()
	
	# Animation
	if velocity.length() > 0.0:
		# Use a mathematical sine wave to rock your Sprite2D left and right!
		# 'rotation' is a built-in property. We apply it directly to your $Sprite2D node.
		$Inky.rotation = sin(Time.get_ticks_msec() * 0.010) * 0.15
		
		# Optional: Add a tiny vertical bounce so it feels extra bouncy
		$Inky.position.y = sin(Time.get_ticks_msec() * 0.03) * 4.0
	else:
		# If the player stops moving, instantly reset your Sprite2D back to normal
		$Inky.rotation = 0.0
		$Inky.position.y = 0.0
		
func _input(event: InputEvent) -> void:
	# Keep your working touch logic exactly as it was!
	if event is InputEventScreenTouch:
		if event.is_pressed():
			touch_start_position = event.position
			is_dragging = true
		else:
			is_dragging = false
			move_direction = Vector2.ZERO
	
	if event is InputEventScreenDrag and is_dragging:
		var current_touch_position = event.position
		var drag_vector = current_touch_position - touch_start_position
		if drag_vector.length() > 10:
			move_direction = drag_vector.normalized()
		else:
			move_direction = Vector2.ZERO


