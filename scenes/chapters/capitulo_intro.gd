extends CanvasLayer
var limite_nubes = 	200
var velocidad = 10  # velocidad base
# Movimiento de las nubes
const DIALOGUE = preload("res://dialogos/dialogue.dialogue")
# ===== Inicio del programa ====== #
func _ready() -> void:
	# Fade In
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($fade_rect, "modulate", Color(1, 1, 1, 0.0), 2.0)
	
	# audio de la escena
	$Audios/Intro_1.play()
	# Esperar 2 segundos antes de diálogo
	await get_tree().create_timer(2.0).timeout
	$Button.visible = true
	# Esperar 2 segundos antes de diálogo
	DMSettings.set_setting(DMSettings.BALLOON_PATH, "res://dialogos/balloon_introduccion.tscn")
	DialogueManager.show_dialogue_balloon(DIALOGUE, "inicio")
	$Button.visible = true
	
func _process(delta):
	
	$ParallaxBackground.scroll_offset.x += velocidad * delta
	# Reinicia el movimeinto de las nubes
	if ($ParallaxBackground.scroll_offset.x > limite_nubes):
		$ParallaxBackground.scroll_offset.x = delta
		
func _on_button_pressed() -> void:
	# Cuando el jugador presione el botón, hacer fade out y cambiar escena
	
	$Button.visible = false  # Ocultar botón para evitar doble clic
	var tween_out : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_out.tween_property($fade_rect, "modulate", Color(1, 1, 1, 1.0), 2.0)
	
	await tween_out.finished
	get_tree().change_scene_to_file("res://scenes/chapters/capitulo_prologo.tscn")
