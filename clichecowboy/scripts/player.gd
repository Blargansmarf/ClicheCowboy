extends KinematicBody2D

export (int) var speed = 100
export (float) var shootCooldown = 1
export (int) var health = 3
export (int) var invSpd = 250
export (float) var invTime = .5
export (int) var dodgeSpd = 300
export (int) var dodgeTime = .25
export (int) var dodgeCooldown = 5

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
onready var mySprite = $AnimatedSprite

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
			print("OW I HURT")
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
				print("CAN DODGE")
				canDodge = true
				dodgeDelta = 0.0
		
		player_input()
		velocity = move_and_slide(velocity)
			

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
		print("DODGING")
		canDodge = false
		dodging = true
		speed += dodgeSpd
		set_collision_mask_bit(2, false)
		
	velocity = velocity.normalized() * speed
	
	#bullet logic
	if canShoot:
		if Input.is_action_pressed("shoot_up"):
			canShoot = false
			shoot = true
			if Input.is_action_pressed("shoot_left") and !Input.is_action_pressed("shoot_right") and !Input.is_action_pressed("shoot_down"):
				shootDir = Vector2(-1, -1)
			elif Input.is_action_pressed("shoot_right") and !Input.is_action_pressed("shoot_left") and !Input.is_action_pressed("shoot_down"):
				shootDir = Vector2(1, -1)
			else:
				shootDir = Vector2(0, -1)
		elif Input.is_action_pressed("shoot_down"):
			canShoot = false
			shoot = true
			if Input.is_action_pressed("shoot_left") and !Input.is_action_pressed("shoot_right") and !Input.is_action_pressed("shoot_up"):
				shootDir = Vector2(-1, 1)
			elif Input.is_action_pressed("shoot_right") and !Input.is_action_pressed("shoot_left") and !Input.is_action_pressed("shoot_up"):
				shootDir = Vector2(1, 1)
			else:
				shootDir = Vector2(0, 1)
		elif Input.is_action_pressed("shoot_right"):
			canShoot = false
			shoot = true
			shootDir = Vector2(1, 0)
		elif Input.is_action_pressed("shoot_left"):
			canShoot = false
			shoot = true
			shootDir = Vector2(-1, 0)
	
