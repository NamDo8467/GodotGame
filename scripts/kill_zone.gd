extends Area2D

@onready var timer = $Timer


func _on_body_entered(body):
	#print("You die")
	#Engine.time_scale = 0.8
	body.get_node("CollisionShape2D").queue_free()
	timer.start()
	
	
	
func _on_timer_timeout():
	#Engine.time_scale = 1
	get_tree().reload_current_scene()
	Global.reset_score()



