extends CharacterBody2D

var health = 100.0
@export var SPEED = 500
signal health_depleted
# Mobile Touch Configuration
var touch_start_position = Vector2.ZERO
var is_dragging = true
var move_direction = Vector2.ZERO
var pulse_time: float = 0.0
var is_triple_shot: bool = false
var powerup_timer: float = 0.0
const POWERUP_DURATION: float = 7.0

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
		get_tree().call_group("Camera", "shake", 12.0, 4.0)
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
	
	# Low Health UI Warning (Pulsing Progress Bar)
	if health <= 25.0 and health > 0.0:
		# Accumulate time to handle our flashing rate speed
		pulse_time += delta * 15.0 
		# Use an absolute value sine wave to smoothly ping-pong transparency
		# This moves back and forth cleanly between 0.3 (faded) and 1.0 (fully visible)
		var flash_alpha = 0.3 + (abs(sin(pulse_time)) * 0.7)
		
		# Apply a  bright red color mask
		%ProgressBar.modulate = Color(1.0, 0.1, 0.1, flash_alpha)
	else:
		# Reset back the color
		%ProgressBar.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	# Power up
	if is_triple_shot:
		powerup_timer -= delta
		if powerup_timer <= 0.0:
			is_triple_shot = false
	
func _input(event: InputEvent) -> void:
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

func activate_triple_shot() -> void:
	is_triple_shot = true
	powerup_timer = POWERUP_DURATION
	%ProgressBar.modulate = Color(0.2, 1.0, 0.2, 1.0)
