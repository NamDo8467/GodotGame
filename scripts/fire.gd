extends Node2D
@onready var timer = $Timer

var SECOND = 2
@onready var fire = $AnimatedSprite2D
@onready var kill_zone = $KillZone

func _on_ready():
	timer.start()
	kill_zone.set_collision_mask_value(2, false)
	
func _on_timer_timeout():
	if fire.animation == "on":
		fire.play("off")
		kill_zone.set_collision_mask_value(2, false)
		
	elif fire.animation == "off":
		fire.play("on")
		kill_zone.set_collision_mask_value(2, true)
		
	timer.start()






