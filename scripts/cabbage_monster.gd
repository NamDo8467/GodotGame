extends Node2D

const SPEED = 270

@onready var cabbage_monster = $AnimatedSprite2D
var right_walking_boundary = 1120
var left_walking_boundary = 855
var direction = 1 # currently going to the right
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x >= right_walking_boundary:
		direction = -1
		cabbage_monster.flip_h = true
	elif position.x <= left_walking_boundary:
		direction = 1
		cabbage_monster.flip_h = false
	position.x += direction * SPEED * delta
