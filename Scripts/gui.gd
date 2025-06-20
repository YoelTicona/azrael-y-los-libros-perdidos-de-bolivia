extends CanvasLayer

func _process(_delta):
	$Container/Label.text = "SCORE: " + str(Global.score)

func game_over() -> void:
	get_tree().paused = true
	$GameOver/Container/Buttons/restart.grab_focus()
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property($GameOver, "modulate", Color(1, 1, 1, 0.8), 1.0)
	$GameOver/sound.play()


func _on_restart_pressed() -> void:
	get_tree().paused = false  # Muy importante
	get_tree().reload_current_scene()
	Global.score = 0;


func _on_exit_pressed() -> void:
	get_tree().quit()
	# get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")	 Verificar

# Funcion de la vida de player
func set_life(value: int) -> void:
	for i in range(6):
		var life_sprite = $lifeContainer.get_child(i)
		life_sprite.visible = i < value + 1

func get_axis() -> Vector2:
	var axis_x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	return Vector2(axis_x, 0).normalized()
