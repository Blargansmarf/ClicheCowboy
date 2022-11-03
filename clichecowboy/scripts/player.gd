extends KinematicBody2D

export (int) var speed = 150

var velocity = Vector2()

var bulletScn = preload("res://scenes/bullet.tscn")
var bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	player_input()
	velocity = move_and_slide(velocity)
	
	if bullet and !bullet.alive:
		bullet.queue_free()

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
	if Input.is_action_just_pressed("leftclick"):
		bullet = bulletScn.instance()
		bullet.position = position
		bullet.init_stats(200, Vector2(1, 0), 1, 3)
