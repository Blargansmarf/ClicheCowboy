extends Node2D

onready var playerScn = preload("res://scenes/player.tscn")
onready var bulletScn = preload("res://scenes/bullet.tscn")
onready var banditoScn = preload("res://scenes/bandito.tscn")
onready var dollarScn = preload("res://scenes/dollar.tscn")
onready var deathScn = preload("res://scenes/death_menu.tscn")
onready var lvlupScn = preload("res://scenes/levelup_menu.tscn")
onready var hudScn = preload("res://scenes/HUD.tscn")

var player
var bullets = []
var enemies = []
var dollars = []
var hud
var lvlup

enum Thing {BULLET, ENEMY, DOLLAR}

#trash is stored as type, position
var trash = []

var paused = false
var hitFlip = false
var dodgeFlip = false
var dead = false
var lvl = false
var frameCount = 0

export (int) var spawnRate = 60
export (int) var enemySpeed = 50
export (int) var enemyHealth = 1

export (int) var spawnRateInc = -1
export (int) var enemySpeedInc = 1
export (int) var enemyHealthInc = 1

#60 frames = 1 sec
export (int) var spawnRateFrame = 600
export (int) var enemySpeedFrame = 180
export (int) var enemyHealthFrame = 1800

var rng = RandomNumberGenerator.new()

onready var screenSize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	player = playerScn.instance()
	player.position = screenSize / 2
	hud = hudScn.instance()
	player.add_child(hud)
	hud.global_position = Vector2(0, 0)
	add_child(player)
	
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !paused:
		
		frameCount+=1
		
		if player.shoot:
			player.shoot = false
			bullets.append(bulletScn.instance())
			bullets[-1].position = player.get_node("GunSprite/TipArea/Tip").global_position
			bullets[-1].init_stats(player.bulletSpeed, player.shootDir, player.bulletDamage, player.bulletLife)
			add_child(bullets[-1])
		
		if player.hit and !hitFlip:
			hitFlip = true
			hud.gotHit()
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
			hud.dodgeUsed()
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
					hud.updateDollars(player.moneyCap - player.money)
					trash.append(Thing.DOLLAR)
					trash.append(dollars.find(d))
		
		if player.health <= 0:
			dead = true
			pauseGame()
			var deathMenu = deathScn.instance()
			deathMenu.position += player.position - screenSize/2
			add_child(deathMenu)
		
		if player.money >= player.moneyCap:
			levelup()
		
		if frameCount % spawnRate == 0:
			generateEnemy()
		
		if player.canDodge:
			hud.dodgeReady()
		
		scaleEnemies()
		cleanUp()
	
	if lvl:
		if lvlup.choice > -1:
			applyLevelUp()
	
	if Input.is_action_just_pressed("pause") and !dead and !lvl:
		if paused:
			unpauseGame()
		elif !paused:
			pauseGame()
	
	if Input.is_action_just_pressed("pause") and dead:
		get_tree().reload_current_scene()

func getSlope(src, dest):
	return dest - src

func cleanUp():
	var bulletCleaned = 0
	var enemyCleaned = 0
	var dollarCleaned = 0
	while !trash.empty():
		if trash.size() < 2:
			trash.clear()
		if trash[0] == Thing.BULLET:
			trash[1] -= bulletCleaned
			bullets[trash[1]].queue_free()
			bullets.remove(trash[1])
			trash.remove(0)
			trash.remove(0)
			bulletCleaned += 1
		elif trash[0] == Thing.ENEMY:
			trash[1] -= enemyCleaned
			enemies[trash[1]].queue_free()
			enemies.remove(trash[1])
			trash.remove(0)
			trash.remove(0)
			enemyCleaned += 1
		elif trash[0] == Thing.DOLLAR:
			trash[1] -= dollarCleaned
			dollars[trash[1]].queue_free()
			dollars.remove(trash[1])
			trash.remove(0)
			trash.remove(0)
			dollarCleaned += 1
		else:
			trash.clear()
			
func generateEnemy():
	enemies.append(banditoScn.instance())
	enemies[-1].initStats(enemySpeed, enemyHealth)
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
	hud.paused = true
	if !bullets.empty():
		for b in bullets:
			b.paused = true
	if !enemies.empty():
		for e in enemies:
			e.paused = true
	
func unpauseGame():
	paused = false
	player.paused = false
	hud.paused = false
	if !bullets.empty():
		for b in bullets:
			b.paused = false
	if !enemies.empty():
		for e in enemies:
			e.paused = false

func levelup():
	pauseGame()
	lvl = true
	lvlup = lvlupScn.instance()
	lvlup.position = player.position - screenSize/2
	add_child(lvlup)

# 0 - move spd
# 1 - fire rate
# 2 - dash cd
# 3 - bullet spd and damage
# 4 - dash length and invuln time
# 5 - bullet time 
# 6 - max health
# 7 - heal to full

func applyLevelUp():
	match lvlup.choice:
		0:
			player.speed += player.speedLvl
		1:
			player.shootCooldown += player.shootCooldownLvl
			if player.shootCooldown < .15:
				player.shootCooldown = .15
		2:
			player.dodgeCooldown += player.dodgeCooldownLvl
			if player.dodgeCooldown < 1:
				player.dodgeCooldown = 1
		3:
			player.bulletSpeed += player.bulletSpeedLvl
			player.bulletDamage += player.bulletDamageLvl
		4:
			player.dodgeTime += player.dodgeTimeLvl
			player.invTime += player.invTimeLvl
		5:
			player.bulletLife += player.bulletLifeLvl
		6:
			player.maxHealth += player.healthLvl
		7:
			player.health = player.maxHealth
			hud.fullHeal()
	
	player.moneyCap *= player.moneyCapLvl
	player.moneyCap = round(player.moneyCap)
	player.money = 0
	hud.updateDollars(player.moneyCap)
	lvl = false
	lvlup.queue_free()
	unpauseGame()

func scaleEnemies():
	if frameCount % enemyHealthFrame == 0:
		enemyHealth += enemyHealthInc
		#print("Enemy health +1")
	
	if frameCount % spawnRateFrame == 0:
		spawnRate += spawnRateInc
		if spawnRate < 0:
			spawnRate = 1
		#print("Enemy spawn rate increased")
	
	if frameCount % enemySpeedFrame == 0:
		enemySpeed += enemySpeedInc
		#print("Enemy speed increased")
