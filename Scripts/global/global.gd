extends Node

var score : int
var ESCENA = "res://scenes/chapters/capitulo_intro.tscn"
#Movimiento del player, ejes de movimiento
var axis : Vector2

func get_axis() -> Vector2:
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_just_pressed("ui_down"))
	return axis.normalized() # Para evitar que se duplique la velocidad al presionar 2 teclas
