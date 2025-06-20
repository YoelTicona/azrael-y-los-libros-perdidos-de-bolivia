# Menu principal
extends Node2D
var velocidad = 30  # velocidad base
var limite_nubes = 1500
var popup

# Movimiento de las nubes
func _process(delta):
	
	$ParallaxBackground.scroll_offset.x += velocidad * delta
	# Reinicia el movimeinto de las nubes
	if ($ParallaxBackground.scroll_offset.x > limite_nubes):
		$ParallaxBackground.scroll_offset.x = delta
		
#Movimiento	
func _on_jugar_pressed():
	# Cambia la escena a inciar
	Global.ESCENA = "res://scenes/chapters/capitulo_intro.tscn"
	# Cambia a la escena principal del juego
	get_tree().change_scene_to_file("res://scenes/LoadingScene.tscn")	

func _on_opciones_pressed() -> void:
	$PopupOpciones.show()
	$CanvasLayer/MenuPrincipal.hide()


func _on_button_pressed() -> void:
	$PopupOpciones.hide()
	$CanvasLayer/MenuPrincipal.show()


func _on_button_capitulo1() -> void:
	get_tree().change_scene_to_file("res://scenes/chapters/capitulo_1.tscn")	

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_creditos_pressed() -> void:
	$PopupCreditos.show()
	$CanvasLayer/MenuPrincipal.hide()


func _on_button_2_salir() -> void:
	$PopupCreditos.hide()
	$CanvasLayer/MenuPrincipal.show()


func _on_volumen_pressed() -> void:
	var is_muted = AudioServer.is_bus_mute(0)
	AudioServer.set_bus_mute(0, not is_muted)
	if is_muted: 
		$PopupOpciones/Volumen.text = "Volumen: ON"
	else:
		$PopupOpciones/Volumen.text = "Volumen: OFF"
