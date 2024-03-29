extends CharacterBody2D

var speed = 200
var alive = false
var velocity = Vector2()
var damage = 0
var time = 0
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_stats(spd, vel, dmg, t):
	speed = spd
	velocity = vel
	damage = dmg
	time = t
	alive = true

func _physics_process(delta):
	if alive and !paused:
		time -= delta
		if time <= 0:
			alive = false
			pass
		velocity = velocity.normalized() * speed
		set_velocity(velocity)
		move_and_slide()
		velocity = velocity
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if "Bandito" in collision.collider.name:
				alive = false
				var enemyInstance = instance_from_id(collision.collider_id)
				enemyInstance.health -= damage
