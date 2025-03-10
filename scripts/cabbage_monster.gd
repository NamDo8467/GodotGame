extends Node2D

const SPEED = 300

@onready var cabbage_monster = $AnimatedSprite2D

var direction = 1 # currently going to the right
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x >= 680:
		direction = -1
		cabbage_monster.flip_h = true
	elif position.x <= -5:
		direction = 1
		cabbage_monster.flip_h = false
	position.x += direction * SPEED * delta
