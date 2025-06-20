extends Camera2D

@export_category("Config")
@export_group("Required References")
@export var player : CharacterBody2D

func _process(_delta):
	global_position = player.global_position
