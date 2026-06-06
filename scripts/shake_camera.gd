extends Camera2D

var shake_intensity: float = 0.0
var shake_fade: float = 5.0

func _ready() -> void:
	add_to_group("Camera")

func _process(delta: float) -> void:
	if shake_intensity > 0:
		shake_intensity = lerp(shake_intensity, 0.0, shake_fade * delta)
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		offset = Vector2.ZERO
		
func shake(intensity: float, fade_speed: float = 5.0) -> void:
		shake_intensity = intensity
		shake_fade = fade_speed
		
		# Vibrating the Mobile Phone when the screen shakes
		if OS.has_feature("mobile") or OS.has_feature("android"):
			var vibration_ms = int(intensity * 10)
			vibration_ms = clamp(vibration_ms, 10, 250)
			Input.vibrate_handheld(vibration_ms)
