extends KinematicBody2D

export (int) var speed = 50

var velocity = Vector2()
var alive = true
var health = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initStats(spd, hlth):
	health = hlth
	speed = spd

func setDir(dir):
	velocity = dir

func _physics_process(_delta):
	if alive:
		if health <= 0:
			alive = false
			pass
		
		velocity = velocity.normalized() * speed
		velocity = move_and_slide(velocity)
