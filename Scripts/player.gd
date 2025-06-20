extends CharacterBody2D
class_name Player

# Variables
var axis : Vector2 = Vector2.ZERO #Movimiento del personaje
var death : bool = false # Verifica si esta vivo o no


# ===== Organizar los exports por categorias =====
# Crea una opcion para el player
@export_category("Config") # 

# Modifica su GUI del personaje
@export_group("Required References") # Referencias requeridas
@export var gui : CanvasLayer # Para su GUI - HUD, life

# Modifica su movimiento del personaje
@export_group("Motion")
@export var speed : int = 128
@export var gravity : int = 16
@export var jump : int = 368
@export var health_player : int = 5
# Para el movimiento = Medidas del sprites  multiplo de 4

# Para el knockbak del personaje - retroceso cuando es golpeado
var is_knockback := false
@export var knockback_force := Vector2(-100, -280)  # X: lateral, Y: hacia arriba
@export var knockback_dir := 0  # -1 (izquierda) o 1 (derecha)

# Invulnerabilidad del personaje
var invulnerable := false
@export var invuln_duration := 1.0  # segundos de invulnerabilidad
@export var blink_interval := 0.1   # segundos entre parpadeos

var _invuln_timer := 0.0
var _blink_timer := 0.0



# ========== Inicio del programa ========== #
func _process(_delta):
	if invulnerable:
		_invuln_timer -= _delta
		_blink_timer -= _delta

		if _blink_timer <= 0.0:
			$AnimatedSprite2D.visible = not $AnimatedSprite2D.visible
			_blink_timer = blink_interval

		if _invuln_timer <= 0.0:
			invulnerable = false
			$AnimatedSprite2D.visible = true  # Asegúrate de que quede visible
	
	# Animaciones de player
	if death:
		death_ctrl()
	elif is_knockback:
		knockback_ctrl()
	else:
		motion_ctrl()
			
# Funcion cuando se presiona una tecla
func _input(event):
	if not death and is_on_floor() and (event.is_action_pressed("ui_accept") or event.is_action_pressed("jump")):
		jump_ctrl(1)

# Funcion para mover al personaje
func get_axis() -> Vector2:
	axis.x = int((Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"))) - int((Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left")))
	return axis.normalized() # Para evitar que se duplique la velocidad al presionar 2 teclas


# Funcion de movimiento y animaciones
func motion_ctrl() -> void:
	""" MOVIMIENTO """
	if not get_axis().x == 0:
		$AnimatedSprite2D.scale.x = get_axis().x
	
	velocity.x = get_axis().x * speed
	velocity.y += gravity
	
	move_and_slide() # Para que mueva el personaje
	
	""" ANIMACION """
	# Si el personaje esta tocando el suelo
	match is_on_floor():
		true:
			if not get_axis().x == 0:
				$AnimatedSprite2D.play("camina")
			else:
				$AnimatedSprite2D.play("hide")
		false:
			if velocity.y < 0:
				$AnimatedSprite2D.play("salta")
			else:
				$AnimatedSprite2D.play("salta")

# Funcion de death			
func death_ctrl() -> void:
	velocity.x = 0
	velocity.y += gravity
	move_and_slide()
		
# Funcion del salto
func jump_ctrl(power : float) -> void:
	velocity.y = -jump * power
	$Audio/salto.play()
	
# Funcion damage
func damage_ctrl() -> void:
	is_knockback = true
	# Invulnerabilidad
	if invulnerable:
		return  # Ignora daño si está invulnerable
		
	health_player -= 1
	gui.set_life(health_player) # Cambia de vida del gui del personaje
	# Animacion de muerte cuando el player ya no tenga vida
	if health_player <= 0:
		death = true
		$AnimatedSprite2D.play("death")
		$Audio/game_over.play()
		return
	else:
		$Audio/damage.play()
		
	
	
	# Activar invulnerabilidad
	invulnerable = true
	_invuln_timer = invuln_duration
	_blink_timer = 0.0
	
	# Knockback: Determina dirección contraria al movimiento actual
	knockback_dir = sign(velocity.x)
	if knockback_dir == 0:
		knockback_dir = -1  # por defecto hacia la izquierda
	
	# Aplica el retroceso
	velocity.x = knockback_force.x * knockback_dir
	velocity.y = knockback_force.y
	
# Verificacion del knockback_ctrl
func knockback_ctrl() -> void:
	velocity.y += gravity
	move_and_slide()

	# Cancelar el knockback cuando toque el suelo
	if is_on_floor():
		is_knockback = false
	

func _on_hit_point_body_entered(body):
	if body is Enemy and velocity.y >= 0:
		$Audio/hit.play()
		body.damage_ctrl(1)
		jump_ctrl(0.75)

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "death":
		#gui.game_over()
		get_parent().get_node("GUI").game_over()		
 
func _set_life(life):
	health_player = life
	
