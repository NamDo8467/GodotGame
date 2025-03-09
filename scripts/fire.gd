extends Node2D
@onready var timer = $Timer

var SECOND = 2
@onready var fire = $AnimatedSprite2D
@onready var kill_zone = $KillZone
var trigger_dropping = false

func _on_ready():
	#timer.start()
	fire.play("on")
	#kill_zone.set_collision_mask_value(2, false)
	
	
func _process(delta):
	if trigger_dropping == true:
		#timer.start()
		position.y += 4
func _on_timer_timeout():
	#position.y += 2
	pass
	#if fire.animation == "on":
		#fire.play("off")
		#kill_zone.set_collision_mask_value(2, false)
		#
	#elif fire.animation == "off":
		#fire.play("on")
		#kill_zone.set_collision_mask_value(2, true)
		#
	#timer.start()


func _on_trigger_zone_body_entered(body):
	trigger_dropping = true


func _on_kill_zone_body_entered(body):
	if body.name == "TileMap":
		#print(body)
		queue_free()
		#return
