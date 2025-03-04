extends Area2D

@onready var timer = $Timer
var player = null
func _on_body_entered(body):	
	body.get_node("CollisionShape2D").queue_free()
	player = body
	timer.start()

func _on_timer_timeout():
	player.queue_free()
		



