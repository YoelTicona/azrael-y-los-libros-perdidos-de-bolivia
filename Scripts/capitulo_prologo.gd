extends Control
const INTRODUCCION = preload("res://dialogos/introduccion.dialogue")
var dialogo_azrael:bool = true
var esperando_dialogo_miguel = false
var esperando_final_dialogo_miguel = false
var esperando_dialogo_demonio = false
var esperando_dialogo_forcejeo = false
var esperando_dialogo_final = false
var esperando_dialogo_final_caminar = false

var player_instance : Player = null
var demonio_mostrado = false


# ==== posicion en el programa ===== #
func _process(_delta):
	if player_instance != null and not demonio_mostrado:
		var mitad_x = get_viewport_rect().size.x / 2
		if player_instance.position.x >= mitad_x:
			demonio_mostrado = true
			mostrar_demonio()
func mostrar_demonio():
	$imp.visible = true
	$imp.play("imp")
	
	$move_left.visible = false
	$move_right.visible = false
	$jump.visible = false
	$Objetivo.visible = false
	
	# Aquí puedes agregar animación, diálogo, sonidos, etc.
	# Lanza diálogo demonio, ejemplo:
	DMSettings.set_setting(DMSettings.BALLOON_PATH, "res://dialogos/balloon_prologo.tscn")
	DialogueManager.show_dialogue_balloon(INTRODUCCION, "imp_escena")
	player_instance.queue_free()
	player_instance = null
	$Audios/Audio1.stop()
	$Audios/Audio2.play()
	$Azrael.visible = true
	$Azrael.play("hide")
# ==== inicio de programa ===== #
func _ready() -> void:
	# Fade In (Ambiente: Fondo oscuro a claro)
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($fade_rect, "modulate", Color(1, 1, 1, 0.0), 2.0)
	# Empieza la animacion de player
	$AnimatedSprite2D2.play("sentado") # Animacion del player
	$Audios/Audio1.play() # Audio de la escena
	await get_tree().create_timer(2.0).timeout # Esperamos 2 seg la escena
	
	## Conectar señales UNA sola vez
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	# Mostrar diálogo Azrael
	DMSettings.set_setting(DMSettings.BALLOON_PATH, "res://dialogos/balloon_prologo.tscn")
	DialogueManager.show_dialogue_balloon(INTRODUCCION, "azrael_intro")
	

func _on_dialogue_ended(_dialogue) -> void:
	# Este método se llamará cada vez que termine cualquier diálogo,
	# filtramos para que solo actúe tras diálogo Azrael y no tras Miguel
	if dialogo_azrael:
		dialogo_azrael = false
		esperando_dialogo_miguel = true
		_animar_miguel_llegada()
		# Mostrar diálogo Miguel
		DMSettings.set_setting(DMSettings.BALLOON_PATH, "res://dialogos/balloon_prologo.tscn")
		DialogueManager.show_dialogue_balloon(INTRODUCCION, "miguel_escena")
	elif esperando_dialogo_miguel:
		esperando_dialogo_miguel = false
		esperando_dialogo_demonio = true
		miguelSale()
		# Hacer que azael se levante
		await get_tree().create_timer(3.0).timeout		
			# Instanciar Player solo cuando termine diálogo de Miguel
		if player_instance == null:
			$AnimatedSprite2D2.visible = false # Ocultando al sprite de azrael sentado
			$Silla.visible = true # Mostrando la silla
			$Objetivo.visible = true
			$Consejos.visible = true
			$TimerConsejos.wait_time = 3
			$TimerConsejos.start()
			# Cargando a Player
			$move_left.visible = true
			$move_right.visible = true
			$jump.visible = true
			var PlayerScene = preload("res://scenes/player.tscn")
			player_instance = PlayerScene.instantiate()
			# Cambiar posición donde aparece el player
			player_instance.position = Vector2(43.0, 237.0)  # la posición que quieras
			# Cambiar escala del player (1,1 es tamaño normal)
			player_instance.scale = Vector2(1.8, 1.8)  # para agrandarlo 1.5 veces
			add_child(player_instance)
	elif esperando_dialogo_demonio:
		# Cuando acabe de hablar el demonio
		esperando_dialogo_demonio = false
		esperando_dialogo_forcejeo = true
		
		# Hacer que azrael camine hacia el demonio rapidamente
		$Azrael.play("camina")
		var tween = create_tween()
		tween.tween_property($Azrael, "position", Vector2(124.0, 174.0), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.connect("finished", Callable(self, "_on_azrael_llego"))
	elif esperando_dialogo_forcejeo:
		esperando_dialogo_forcejeo = false
		esperando_dialogo_final = true
		# Realizando un forcejeo moviendo la camara
		$Audios/Audio2.stop()
		$Audios/Caida.play()
		DMSettings.set_setting(DMSettings.BALLOON_PATH, "res://dialogos/balloon_prologo.tscn")
		DialogueManager.show_dialogue_balloon(INTRODUCCION, "discusion")
	elif esperando_dialogo_final:
		esperando_dialogo_final = false
		esperando_dialogo_final_caminar = true
		
		# Hacer que el imp desaparezca
		var tween = create_tween()
		tween.tween_property($imp, "modulate", Color(1, 1, 1, 0), 2.0)  # alfa a 0 en 2 segundos
		tween.connect("finished", Callable(self, "_on_imp_desaparecio"))
	elif esperando_dialogo_final_caminar:
		# Caminata de azrael
		$Azrael.play("camina")
		$Azrael.flip_h = false
		var tween = create_tween()
		tween.tween_property($Azrael, "position", Vector2(538.0, 187.0), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		# Fade In (Ambiente: Fondo oscuro a claro)
		var tween2 : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween2.tween_property($fade_rect, "modulate", Color(1, 1, 1, 1), 2.0)
		tween.connect("finished", Callable(self, "_on_azrael_salio_escena"))
		
func _animar_miguel_llegada() -> void:
	$MiguelAS3.play("miguel_caminando")
	var tween = create_tween()
	tween.tween_property($MiguelAS3, "position", Vector2(388.0, 189.0), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", Callable(self, "_on_miguel_llego"))
	
func _on_miguel_llego() -> void:
	# Mostrar diálogo de Miguel cuando llega
	$MiguelAS3.play("miguel_parado")

func _on_azrael_llego() -> void:
	# Mostrar diálogo de Miguel cuando llega
	$Azrael.play("hide")
	
	# Realizando el dialogo
	DMSettings.set_setting(DMSettings.BALLOON_PATH, "res://dialogos/balloon_prologo.tscn")
	DialogueManager.show_dialogue_balloon(INTRODUCCION, "imp_azrael")
	
func _on_imp_desaparecio() -> void:
	DMSettings.set_setting(DMSettings.BALLOON_PATH, "res://dialogos/balloon_prologo.tscn")
	DialogueManager.show_dialogue_balloon(INTRODUCCION, "azrael_se_va")
	
func _on_dialogue_final_miguel(_dialogue) -> void:
	pass
	#$MiguelAS3.play("miguel_caminando")
	#$MiguelAS3.flip_h = false
	#var tween = create_tween()
	#tween.tween_property($MiguelAS3, "position", Vector2(538.0, 187.0), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Hacer que azael se levante
	#await get_tree().create_timer(1.0).timeout
	#$Player.visible = 1
	#$Silla.visible = 1
	
	
func miguelSale() -> void:
	# Aquí va la lógica cuando termine el diálogo de Miguel
	$MiguelAS3.play("miguel_caminando")
	$MiguelAS3.flip_h = false
	var tween = create_tween()
	tween.tween_property($MiguelAS3, "position", Vector2(538.0, 187.0), 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_azrael_salio_escena() -> void:
	# Cambia la escena a inciar
	Global.ESCENA = "res://scenes/chapters/capitulo_prologo_2.tscn"
	# Cambia a la escena principal del juego
	get_tree().change_scene_to_file("res://scenes/LoadingScene.tscn")

func _on_timer_consejos_timeout() -> void:
	$Consejos.visible = false
