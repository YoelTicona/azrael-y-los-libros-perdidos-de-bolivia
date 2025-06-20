extends Area2D

func _ready() -> void:
	$Sprite.play("on")

# Recoger la moneda y aumentar puntos	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		$Sprite.play("off")
		$sound.play()
		Global.score += 100
		


func _on_sound_finished() -> void:
	queue_free()
