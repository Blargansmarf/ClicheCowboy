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

var frameCount = 0
export (int) var spawnRate = 60
var rng = RandomNumberGenerator.new()

onready var screenSize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	player = playerScn.instance()
	player.position = screenSize / 2
	add_child(player)
	
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	frameCount+=1
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
	if frameCount % spawnRate == 0:
		generateEnemy()
	cleanUp()

func getSlope(src, dest):
	return dest - src

func cleanUp():
	print(trash.size())
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
			
func generateEnemy():
	enemies.append(banditoScn.instance())
	enemies[-1].initStats(50, 1)
	var loc = rng.randi_range(0, 3)
	var pos = Vector2()
	if  loc == 0:
		pos = Vector2(rng.randi_range(-10, screenSize.x), -10)
	elif loc == 1:
		pos = Vector2(screenSize.x + 10, rng.randi_range(0, screenSize.y))
	elif loc == 2:
		pos = Vector2(rng.randi_range(-10, screenSize.x), screenSize.y + 10)
	else:
		pos = Vector2(-10, rng.randi_range(0, screenSize.y))
	enemies[-1].position = pos
	add_child(enemies[-1])
