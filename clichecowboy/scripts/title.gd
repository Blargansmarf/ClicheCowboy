extends Node2D

func _ready():
	get_window().size = Vector2(1024,600)
	get_window().position = Vector2(0,0)

func _physics_process(_delta):
	if Input.is_action_just_pressed("dodge"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")
