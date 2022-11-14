extends KinematicBody2D

export (int) var speed = 50

var velocity = Vector2()
var alive = true
var health = 0
var paused = false

onready var myCollider = $CollisionShape2D
onready var mySprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
		
		velocity = velocity.normalized() * speed
		velocity = move_and_slide(velocity)
		
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if "Player" in collision.collider.name:
				var playerInstance = instance_from_id(collision.collider_id)
				playerInstance.hit = true
