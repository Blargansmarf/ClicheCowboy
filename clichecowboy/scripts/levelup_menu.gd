extends Node2D

@onready var button0 = $Button0
@onready var button1 = $Button1
@onready var button2 = $Button2
@onready var button3 = $Button3

var option0
var option1
var option2
var option3

var choice

var rng = RandomNumberGenerator.new()

# 0 - move spd
# 1 - fire rate
# 2 - dash cd
# 3 - bullet spd and damage
# 4 - dash length and invuln time
# 5 - bullet life and damage
# 6 - max health
# 7 - heal to full

func _ready():
	choice = -1
	rng.randomize()
	gather_options()
	assign_buttons()
	
func gather_options():
	option0 = rng.randi_range(0, 7)
	while option0 == 5 or option0 == 6:
		option0 = rng.randi_range(0, 7)
	option1 = rng.randi_range(0, 7)
	while option1 == option0 or option1 == 5 or option1 == 6:
		option1 = rng.randi_range(0, 7)
	option2 = rng.randi_range(0, 7)
	while option2 == option1 or option2 == option0 or option2 == 5 or option2 == 6:
		option2 = rng.randi_range(0, 7)
	option3 = rng.randi_range(0, 7)
	while option3 == option2 or option3 == option1 or option3 == option0 or option3 == 5 or option3 == 6:
		option3 = rng.randi_range(0, 7)

func assign_buttons():
	match option0:
		0:
			setbutton_movespd(button0)
		1:
			setbutton_firerate(button0)
		2:
			setbutton_dashcd(button0)
		3:
			setbutton_bulletspddmg(button0)
		4:
			setbutton_dashlen(button0)
		5:
			setbutton_bulletnum(button0)
		6:
			setbutton_maxhealth(button0)
		7:
			setbutton_fullheal(button0)
			
	match option1:
		0:
			setbutton_movespd(button1)
		1:
			setbutton_firerate(button1)
		2:
			setbutton_dashcd(button1)
		3:
			setbutton_bulletspddmg(button1)
		4:
			setbutton_dashlen(button1)
		5:
			setbutton_bulletnum(button1)
		6:
			setbutton_maxhealth(button1)
		7:
			setbutton_fullheal(button1)
			
	match option2:
		0:
			setbutton_movespd(button2)
		1:
			setbutton_firerate(button2)
		2:
			setbutton_dashcd(button2)
		3:
			setbutton_bulletspddmg(button2)
		4:
			setbutton_dashlen(button2)
		5:
			setbutton_bulletnum(button2)
		6:
			setbutton_maxhealth(button2)
		7:
			setbutton_fullheal(button2)
			
	match option3:
		0:
			setbutton_movespd(button3)
		1:
			setbutton_firerate(button3)
		2:
			setbutton_dashcd(button3)
		3:
			setbutton_bulletspddmg(button3)
		4:
			setbutton_dashlen(button3)
		5:
			setbutton_bulletnum(button3)
		6:
			setbutton_maxhealth(button3)
		7:
			setbutton_fullheal(button3)
	
	button0.connect("pressed",Callable(self,"_button0_clicked"))
	button1.connect("pressed",Callable(self,"_button1_clicked"))
	button2.connect("pressed",Callable(self,"_button2_clicked"))
	button3.connect("pressed",Callable(self,"_button3_clicked"))

func setbutton_movespd(btn):
	btn.text = "Move Speed +"

func setbutton_firerate(btn):
	btn.text = "Fire Rate +"

func setbutton_dashcd(btn):
	btn.text = "Dash Cooldown -"

func setbutton_bulletspddmg(btn):
	btn.text = "Bullet Spd + Bullet Dmg +"

func setbutton_dashlen(btn):
	btn.text = "Dash Len + Invul Time +"

func setbutton_bulletnum(btn):
	btn.text = "Bullet Life + Bullet Dmg +"

func setbutton_maxhealth(btn):
	btn.text = "Max Health +"

func setbutton_fullheal(btn):
	btn.text = "Full Heal"

func _button0_clicked():
	choice = option0

func _button1_clicked():
	choice = option1

func _button2_clicked():
	choice = option2

func _button3_clicked():
	choice = option3
