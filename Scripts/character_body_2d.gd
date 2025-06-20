extends CharacterBody2D

''' MOVIMIENTO 2D'''

# Variables de movimiento del personaje
@export var speed : float

func _process(delta):
	motion_ctrl()

func motion_ctrl() -> void:
	velocity.x = Global.get_axis().x * speed
	velocity.y = Global.get_axis().y * -speed
	move_and_slide()
