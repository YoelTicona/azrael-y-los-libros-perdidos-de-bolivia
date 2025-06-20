extends CharacterBody2D
class_name Enemy

# ===== Organizar los exports por categorias =====
# Crea una opcion para el player
@export_category("Options") # 
@export var health : int = 1
@export var score : int = 100

# Modifica su movimiento del personaje
@export_group("Motion")
@export var speed : int = 16
@export var gravity : int = 16
# Para el movimiento = Medidas del sprites  multiplo de 4

# Movimiento automatico del enemigo
var direction : int = 1

# Funcion de movimiento
func _process(_delta):
	if health > 0: # Se mueve si aun esta vivo
		motion_ctrl()
	
# Movimiento d
func motion_ctrl() -> void:
	$Sprite.scale.x = direction
	$Sprite.play("walk")
	
	# Deteccion de un precipicio para la caida
	if not $Sprite/RayCast2D.is_colliding() or is_on_wall():
		direction *= -1
	
	# Cambio de direcciones
	velocity.x = direction * speed
	velocity.y += gravity
	move_and_slide()

func damage_ctrl(damage : int) -> void:
	health -= damage
	
	if health <= 0:
		#$AnimatedSprite2D.play("death")
		$Sprite.play("death")
		
		# Desactiva la colision ya que muere
		$CollisionShape2D.set_deferred("disabled", true)
		
		gravity = 0
		Global.score += score

# Muerte del npc
func _on_sprite_animation_finished() -> void:
	if $Sprite.animation == "death":
		queue_free()

# Daño hacia el Player
func _on_area_hit_body_entered(body: Node2D) -> void:
	if body is Player and health > 0:
		body.damage_ctrl()
