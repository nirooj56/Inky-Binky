extends Area2D
const BULLET = preload("uid://4gxndumca2pj")
var bullet_scene = preload("uid://4gxndumca2pj")


func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func _on_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	var powerup_active: bool = false
	if get_parent() and "is_triple_shot" in get_parent():
		powerup_active = get_parent().is_triple_shot
	if not powerup_active:
		spawn_bullet(0.0)
	else:
		# Triple Shot Spread!
		spawn_bullet(0.0)    # Center bullet
		spawn_bullet(-0.25)  # Angled slightly left
		spawn_bullet(0.25)   # Angled slightly right

func spawn_bullet(angle_offset: float) -> void:
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position 
	new_bullet.global_rotation = %ShootingPoint.global_rotation + angle_offset
	get_tree().current_scene.add_child(new_bullet)
