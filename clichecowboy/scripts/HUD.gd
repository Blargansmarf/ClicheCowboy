extends Node2D

@onready var health0 = $health0
@onready var health1 = $health1
@onready var health2 = $health2

@onready var dodgeInd = $dodgeInd

@onready var dollarstolvl = $dollarstolevel

@onready var timer = $timer

var time = 0
var paused = false

func dodgeReady():
	dodgeInd.animation = "ready"

func dodgeUsed():
	dodgeInd.animation = "cooldown"

func gotHit():
	if health2.animation == "full":
		health2.animation = "empty"
	elif health1.animation == "full":
		health1.animation = "empty"
	else:
		health0.animation = "empty"

func fullHeal():
	health0.animation = "full"
	health1.animation = "full"
	health2.animation = "full"

func updateDollars(dollars):
	dollarstolvl.text = "$$$ to lvl - " + str(dollars)

func _physics_process(delta):
	if !paused:
		time += delta
		var mins = floor(time/60.0)
		var secs = floor(time-(mins*60))
		timer.text = "%02d:%02d" % [mins, secs]
