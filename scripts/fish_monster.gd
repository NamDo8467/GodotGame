extends Node2D

const SPEED = 65
@onready var fish_monster = $AnimatedSprite2D
var right_walking_boundary = 1120
var left_walking_boundary = 864
var parent_name: String
var direction = 1 # currently going to the right
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	var parent_name = get_parent().name
	if parent_name == "SecondFloor":
		right_walking_boundary = 1500
	elif parent_name == "ThirdFloor":
		right_walking_boundary = 1120
		
func _process(delta):
	#print(get_parent().name)
	if position.x >= right_walking_boundary:
		direction = -1
		fish_monster.flip_h = true
	elif position.x <= 864:
		direction = 1
		fish_monster.flip_h = false
	position.x += direction * SPEED * delta
