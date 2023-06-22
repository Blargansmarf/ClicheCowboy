extends CharacterBody2D

@export (int) var speed = 50
@export (int) var health = 1

var velocity = Vector2()
var alive = true
var paused = false

@onready var myCollider = $CollisionShape2D
@onready var mySprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	mySprite.play()

func initStats(spd, hlth):
	health = hlth
	speed = spd

func setDir(dir):
	velocity = dir

func _physics_process(_delta):
	if alive and !paused:
		if health <= 0:
			alive = false
			pass
		
		if !mySprite.playing:
			mySprite.play()
		
		velocity = velocity.normalized() * speed
		mySprite.flip_h = velocity.x > 0
		set_velocity(velocity)
		move_and_slide()
		velocity = velocity
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if "Player" in collision.collider.name:
				var playerInstance = instance_from_id(collision.collider_id)
				playerInstance.hit = true
	if paused:
		mySprite.stop()
