extends Area2D
func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	
func _on_body_entered(body) -> void:
	if  body is Player:
		body.damage_ctrl()	
	
