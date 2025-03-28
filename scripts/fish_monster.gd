extends Node2D

const SPEED = 65
@onready var fish_monster = $AnimatedSprite2D

var direction = 1 # currently going to the right
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.x >= 1120:
		direction = -1
		fish_monster.flip_h = true
	elif position.x <= 864:
		direction = 1
		fish_monster.flip_h = false
	position.x += direction * SPEED * delta
