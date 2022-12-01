extends KinematicBody2D

export (int) var speed = 100
export (float) var shootCooldown = 1
export (int) var health = 3
export (int) var maxHealth = 3
export (int) var invSpd = 250
export (float) var invTime = .5
export (int) var dodgeSpd = 300
export (float) var dodgeTime = .25
export (float) var dodgeCooldown = 5
export (int) var money = 0
export (int) var moneyCap = 2
export (int) var bulletSpeed = 200
export (int) var bulletDamage = 1
export (int) var bulletLife = 2

export (int) var speedLvl = 30
export (float) var shootCooldownLvl = -.15
export (int) var healthLvl = 1
export (int) var invTimeLvl = .5
export (float) var dodgeTimeLvl = .1
export (float) var dodgeCooldownLvl = -.75
export (int) var bulletSpeedLvl = 50
export (float) var moneyCapLvl = 1.45
export (int) var bulletDamageLvl = 1
export (float) var bulletLifeLvl = .75

var velocity = Vector2()
var canShoot = true
var shoot = false
var shootDir = Vector2()
var shootDelta = 0.0
var paused = false
var invincible = false
var hit = false
var hitDelta =  0.0
var canDodge = true
var dodging = false
var dodgeDelta = 0.0

onready var myCollider = $CollisionShape2D
onready var mySprite = $BodySprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if !paused:
		if !canShoot:
			shootDelta += delta
			if shootDelta >= shootCooldown:
				canShoot = true
				shootDelta = 0.0

		if hit and !invincible:
			invincible = true
			health -= 1
			set_collision_mask_bit(2, false)
			speed += invSpd
			

		if hit:
			hitDelta += delta
			if hitDelta >= invTime:
				hit = false
				invincible = false
				speed -= invSpd
				hitDelta = 0.0
				set_collision_mask_bit(2, true)
		
		if !canDodge:
			dodgeDelta += delta
			if dodging and dodgeDelta >= dodgeTime:
				dodging = false
				speed -= dodgeSpd
				set_collision_mask_bit(2, true)
			if dodgeDelta >= dodgeCooldown:
				canDodge = true
				dodgeDelta = 0.0
		
		player_input()
		velocity = move_and_slide(velocity)
	if paused:
		if mySprite.playing:
			mySprite.stop()

func player_input():
	#movement logic
	if !dodging:
		velocity = Vector2()
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("left"):
			velocity.x -= 1
	if Input.is_action_just_pressed("dodge") and canDodge and !invincible:
		canDodge = false
		dodging = true
		speed += dodgeSpd
		set_collision_mask_bit(2, false)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		mySprite.animation = "walk"
		if velocity.x != 0:
			mySprite.flip_h = velocity.x > 0
		mySprite.play()
	else:
		mySprite.animation = "default"
	
	#bullet logic
	if canShoot:
		if Input.is_action_pressed("shoot_up"):
			canShoot = false
			shoot = true
			if Input.is_action_pressed("shoot_left") and !Input.is_action_pressed("shoot_right") and !Input.is_action_pressed("shoot_down"):
				shootDir = Vector2(-1, -1)
				get_node("GunSprite").rotation = 45
			elif Input.is_action_pressed("shoot_right") and !Input.is_action_pressed("shoot_left") and !Input.is_action_pressed("shoot_down"):
				shootDir = Vector2(1, -1)
				get_node("GunSprite").rotation_degrees = 135
			else:
				shootDir = Vector2(0, -1)
				get_node("GunSprite").rotation_degrees = 90
		elif Input.is_action_pressed("shoot_down"):
			canShoot = false
			shoot = true
			if Input.is_action_pressed("shoot_left") and !Input.is_action_pressed("shoot_right") and !Input.is_action_pressed("shoot_up"):
				shootDir = Vector2(-1, 1)
				get_node("GunSprite").rotation_degrees = -45
			elif Input.is_action_pressed("shoot_right") and !Input.is_action_pressed("shoot_left") and !Input.is_action_pressed("shoot_up"):
				shootDir = Vector2(1, 1)
				get_node("GunSprite").rotation_degrees = -135
			else:
				shootDir = Vector2(0, 1)
				get_node("GunSprite").rotation_degrees = -90
		elif Input.is_action_pressed("shoot_right"):
			canShoot = false
			shoot = true
			shootDir = Vector2(1, 0)
			get_node("GunSprite").rotation_degrees = 180
		elif Input.is_action_pressed("shoot_left"):
			canShoot = false
			shoot = true
			shootDir = Vector2(-1, 0)
			get_node("GunSprite").rotation_degrees = 0
	
