extends Node2D
func _ready() -> void:
	Global.score = 0
func _on_escena_area_entered(_area: Area2D) -> void:
	Global.ESCENA = "res://scenes/chapters/prologo_2.tscn"
	# Cambia a la escena principal del juego
	get_tree().change_scene_to_file("res://scenes/Fin_demo.tscn")
		
