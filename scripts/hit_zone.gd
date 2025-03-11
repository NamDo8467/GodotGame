extends Area2D

@onready var timer = $Timer
@onready var mushroom = get_parent()
func _on_body_entered(body):
	mushroom.queue_free()
	#var mushroom_animation = mushroom.get_node("AnimatedSprite2D")
	#mushroom_animation.play("die")
	
	#timer.start()
	
#func _on_timer_timeout():
	#pass
	##get_tree().reload_current_scene()
	##Global.reset_score()
