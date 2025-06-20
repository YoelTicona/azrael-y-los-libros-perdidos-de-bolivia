extends CanvasLayer
var dots = 0
func _ready():
	$AnimatedSprite2D.play("camina") # o el nombre de tu animación
	
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(Global.ESCENA)

func _process(delta):
	dots += delta
	var dot_count = int(dots) % 4
	$Label.text = "CARGANDO" + ".".repeat(dot_count)
