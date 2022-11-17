extends Node2D

onready var playerScn = preload("res://scenes/player.tscn")
onready var bulletScn = preload("res://scenes/bullet.tscn")
onready var banditoScn = preload("res://scenes/bandito.tscn")
onready var dollarScn = preload("res://scenes/dollar.tscn")
onready var deathScn = preload("res://scenes/death_menu.tscn")

var player
var bullets = []
var enemies = []
var dollars = []

enum Thing {BULLET, ENEMY, DOLLAR}

#trash is stored as type, position
var trash = []

var paused = false
var hitFlip = false
var dodgeFlip = false
var dead = false
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
# warning-ignore:unused_argument
func _physics_process(delta):
	if !paused:
		
		frameCount+=1
		if player.shoot:
			player.shoot = false
			bullets.append(bulletScn.instance())
			bullets[-1].position = player.position
			bullets[-1].init_stats(200, player.shootDir, 1, 2)
			add_child(bullets[-1])
		
		if player.hit and !hitFlip:
			hitFlip = true
			if !enemies.empty():
				for e in enemies:
					e.set_collision_mask_bit(0, false)
		elif !player.hit and hitFlip:
			hitFlip = false
			if !enemies.empty():
				for e in enemies:
					e.set_collision_mask_bit(0, true)
		
		if player.dodging and !dodgeFlip:
			dodgeFlip = true
			if !enemies.empty():
				for e in enemies:
					e.set_collision_mask_bit(0, false)
		elif !player.dodging and dodgeFlip:
			dodgeFlip = false
			if !enemies.empty():
				for e in enemies:
					e.set_collision_mask_bit(0, true)
		
		if !enemies.empty():
			for e in enemies:
				if !e.alive:
					var dollar = dollarScn.instance()
					dollar.position = e.position
					dollars.append(dollar)
					add_child(dollars[-1])
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
		
		if !dollars.empty():
			for d in dollars:
				if !d.alive:
					player.money += 1
					print(player.money)
					trash.append(Thing.DOLLAR)
					trash.append(dollars.find(d))
		
		if player.health <= 0:
			dead = true
			pauseGame()
			var deathMenu = deathScn.instance()
			deathMenu.rect_position += player.position
			add_child(deathMenu)
		
		if frameCount % spawnRate == 0:
			generateEnemy()
		cleanUp()
	
	if Input.is_action_just_pressed("pause") and !dead:
		if paused:
			unpauseGame()
		elif !paused:
			pauseGame()
	
	if Input.is_action_just_pressed("pause") and dead:
		get_tree().reload_current_scene()

func getSlope(src, dest):
	return dest - src

func cleanUp():
	while !trash.empty():
		if trash.size() < 2:
			trash.clear()
		elif trash[0] == Thing.BULLET:
			bullets[trash[1]].queue_free()
			bullets.remove(trash[1])
			trash.remove(0)
			trash.remove(0)
		elif trash[0] == Thing.ENEMY:
			enemies[trash[1]].queue_free()
			enemies.remove(trash[1])
			trash.remove(0)
			trash.remove(0)
		elif trash[0] == Thing.DOLLAR:
			dollars[trash[1]].queue_free()
			dollars.remove(trash[1])
			trash.remove(0)
			trash.remove(0)
		else:
			trash.clear()
			
func generateEnemy():
	enemies.append(banditoScn.instance())
	enemies[-1].initStats(50, 1)
	var loc = rng.randi_range(0, 3)
	var pos = Vector2()
	var playerPosDiff = player.position - screenSize/2
	if  loc == 0:
		pos = Vector2(rng.randi_range(-10, screenSize.x) + playerPosDiff.x, -10 + playerPosDiff.y)
	elif loc == 1:
		pos = Vector2(screenSize.x + 10 + playerPosDiff.x, rng.randi_range(0, screenSize.y) + playerPosDiff.y)
	elif loc == 2:
		pos = Vector2(rng.randi_range(-10, screenSize.x) + playerPosDiff.x, screenSize.y + 10 + playerPosDiff.y)
	else:
		pos = Vector2(-10 + playerPosDiff.x, rng.randi_range(0, screenSize.y) + playerPosDiff.y)
	enemies[-1].position = pos
	if hitFlip or dodgeFlip:
		enemies[-1].set_collision_mask_bit(0, false)
	add_child(enemies[-1])
	
func pauseGame():
	paused = true
	player.paused = true
	if !bullets.empty():
		for b in bullets:
			b.paused = true
	if !enemies.empty():
		for e in enemies:
			e.paused = true
	
func unpauseGame():
	paused = false
	player.paused = false
	if !bullets.empty():
		for b in bullets:
			b.paused = false
	if !enemies.empty():
		for e in enemies:
			e.paused = false
