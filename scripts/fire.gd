extends Node2D
@onready var timer = $Timer

var SECOND = 2
@onready var fire = $AnimatedSprite2D
@onready var kill_zone = $KillZone
var trigger_dropping = false
#var fire_spawner:Node2D
func _on_ready():
	fire.play("on")
	#fire_spawner = get_parent().get_node("FireSpawner")
	
	
func _process(delta):
	if trigger_dropping == true:
		position.y += 600 * delta
#func _on_timer_timeout():
	#pass



func _on_trigger_zone_body_entered(body):
	trigger_dropping = true



func _on_hit_the_floor_zone_body_entered(body):
	if body.name == "TileMap":
		timer.start()
		#get_node(KillZone) queue_free()
		#fire_spawner.drop_fire += 1


func _on_timer_timeout():
	queue_free()
