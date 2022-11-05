extends Node2D

onready var playerScn = preload("res://scenes/player.tscn")
onready var bulletScn = preload("res://scenes/bullet.tscn")

var player
var bullets = []

onready var screenSize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	player = playerScn.instance()
	player.position = screenSize / 2
	add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player.shoot:
		player.shoot = false
		bullets.append(bulletScn.instance())
		bullets[-1].position = player.position
		bullets[-1].init_stats(200, Vector2(1, 0), 1, 2)
		add_child(bullets[-1])
	
	if !bullets.empty():
		for b in bullets:
			if !b.alive:
				b.queue_free()
				bullets.remove(bullets.find(b))
				
