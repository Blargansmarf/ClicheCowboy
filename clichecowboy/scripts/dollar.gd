extends Area2D

onready var alive = true

func _physics_process(_delta):
	if alive:
		var overlap = get_overlapping_bodies()
		for o in overlap:
			if "Player" in o.name:
				alive = false
