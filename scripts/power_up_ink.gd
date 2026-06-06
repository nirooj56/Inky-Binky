extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Verify that what touched us is actually the player character
	if body.has_method("activate_triple_shot"):
		body.activate_triple_shot() # Trigger the power-up behavior on the player
		queue_free() # Destroy the pickup item from the map
