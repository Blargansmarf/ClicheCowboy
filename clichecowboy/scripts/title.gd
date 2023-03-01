extends Node2D

func _ready():
	OS.window_size = Vector2(1024,600)
	OS.window_position = Vector2(0,0)

func _physics_process(_delta):
	if Input.is_action_just_pressed("dodge"):
		get_tree().change_scene("res://scenes/level.tscn")
