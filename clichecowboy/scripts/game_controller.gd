extends Node2D

onready var playerScn = preload("res://scenes/player.tscn")
onready var bulletScn = preload("res://scenes/bullet.tscn")

var player
var bullets

onready var screenSize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	player = playerScn.instance()
	player.position = screenSize / 2
	add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.shoot:
		player.shoot = false
		bullets = bulletScn.instance()
		bullets.position = player.position
		add_child(bullets)
