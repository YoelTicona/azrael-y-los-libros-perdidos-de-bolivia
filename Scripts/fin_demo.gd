extends Control

func _ready() -> void:
	$AnimatedSprite2D.play("hide")

func _on_button_2_pressed() -> void:
	Global.ESCENA = "res://scenes/MainMenu.tscn"
	# Cambia a la escena principal del juego
	get_tree().change_scene_to_file("res://scenes/LoadingScene.tscn")


func _on_button_pressed() -> void:
	get_tree().quit()
