extends Node2D

onready var playerScn = preload("res://scenes/player.tscn")
onready var bulletScn = preload("res://scenes/bullet.tscn")
onready var banditoScn = preload("res://scenes/bandito.tscn")

var player
var bullets = []
var enemies = []

enum Thing {BULLET, ENEMY}

#trash is stored as type, position
var trash = []

onready var screenSize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	player = playerScn.instance()
	player.position = screenSize / 2
	add_child(player)
	
	enemies.append(banditoScn.instance())
	enemies[-1].initStats(20, 100)
	enemies[-1].setDir(Vector2(1, 0))
	enemies[-1].position = Vector2(100, 100)
	add_child(enemies[-1])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player.shoot:
		player.shoot = false
		bullets.append(bulletScn.instance())
		bullets[-1].position = player.position
		bullets[-1].init_stats(200, player.shootDir, 1, 2)
		add_child(bullets[-1])
	
	if !enemies.empty():
		for e in enemies:
			if !e.alive:
				trash.append(Thing.ENEMY)
				trash.append(enemies.find(e))
			else:
				var dir = getSlope(e.position, player.position)
				e.setDir(dir)
	if !bullets.empty():
		for b in bullets:
			if !b.alive:
				trash.append(Thing.BULLET)
				trash.append(bullets.find(b))
	
	cleanUp()

func getSlope(src, dest):
	return dest - src

func cleanUp():
	if !trash.empty():
		if trash[0] == Thing.BULLET:
			bullets[trash[1]].queue_free()
			bullets.remove(trash[1])
			trash.remove(0)
			trash.remove(0)
		elif trash[0] == Thing.ENEMY:
			enemies[trash[1]].queue_free()
			enemies.remove(trash[1])
			trash.remove(0)
			trash.remove(0)
		cleanUp()
			
