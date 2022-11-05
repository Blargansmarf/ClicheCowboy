extends KinematicBody2D

export (int) var speed = 100
export (float) var shootCooldown = 1.0

var velocity = Vector2()
var canShoot = true
var shoot = false
var shootDelta = 0.0

onready var collider = $CollisionShape2D
onready var sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if !canShoot:
		shootDelta += delta
		if shootDelta >= shootCooldown:
			canShoot = true
			shootDelta = 0.0
	
	player_input()
	velocity = move_and_slide(velocity)

func player_input():
	#movement logic
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	velocity = velocity.normalized() * speed
	
	#bullet logic
	if Input.is_action_pressed("leftclick") and canShoot:
		shoot = true
		canShoot = false
