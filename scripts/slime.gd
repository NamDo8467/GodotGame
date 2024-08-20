extends Node2D

const SPEED = 60
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var slime = $AnimatedSprite2D
@onready var kill_zone = $KillZone

var direction = 1 # currently going to the left

#func _ready():
	#slime.flip_h = true
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		slime.flip_h = false
	elif ray_cast_left.is_colliding():
		direction = 1
		slime.flip_h = true
	
	position.x += direction * SPEED * delta
