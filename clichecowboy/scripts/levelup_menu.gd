extends Node

onready var button0 = $Button0
onready var button1 = $Button1
onready var button2 = $Button2
onready var button3 = $Button3

var option0
var option1
var option2
var option3

var rng = RandomNumberGenerator.new()

# 0 - move spd
# 1 - fire rate
# 2 - dash cd
# 3 - bullet spd and damage
# 4 - dash length and invuln time
# 5 - bullet amount 
# 6 - max health
# 7 - heal to full

func _ready():
	rng.randomize()
	gather_options()
	assign_buttons()
	
func gather_options():
	option0 = rng.randi(0, 7)
	option1 = rng.randi(0, 7)
	while option1 == option0:
		option1 = rng.randi(0, 7)
	option2 = rng.randi(0, 7)
	while option2 == option1 or option2 == option0:
		option2 = rng.randi(0, 7)
	option3 = rng.randi(0, 7)
	while option3 == option2 or option3 == option1 or option3 == option0:
		option3 = rng.randi(0, 7)

func assign_buttons():
	pass
