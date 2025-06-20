extends Control
const INTRODUCCION = preload("res://dialogos/god.dialogue")
var dialogos = 0
# ==== inicio de programa ===== #
func _ready() -> void:
	# Empieza la animacion de God
	$Audios/god.play() # Audio de la escena
	$Audios/sorpresa.play() # Audio de la escena
	
	# Animacion de player y God
	$Azrael.play("hide")
	$God.play("god")
	
	## Conectar señales UNA sola vez
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	# Mostrar diálogo GOD
	DMSettings.set_setting(DMSettings.BALLOON_PATH, "res://dialogos/balloon_prologo.tscn")
	DialogueManager.show_dialogue_balloon(INTRODUCCION, "dios_escena")

func _on_dialogue_ended(_dialogue) -> void:
	print(dialogos)
	match dialogos:
		0:
			dialogos +=1
			# Fade In (Ambiente: Fondo oscuro a claro)
			var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			tween.tween_property($fade_rect, "modulate", Color(1, 1, 1, 1), 2.0)
			tween.connect("finished", Callable(self, "_on_fin_escena"))

func _on_fin_escena() -> void:
	# Cambia la escena a inciar
	Global.ESCENA = "res://scenes/chapters/capitulo_1.tscn"
	# Cambia a la escena principal del juego
	get_tree().change_scene_to_file("res://scenes/LoadingScene.tscn")
