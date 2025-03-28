extends Area2D

@onready var timer = $Timer
var player1 = null
var player2 = null
func _on_body_entered(body):
	if body.name == "Player" :
		player1 = body
		body.get_node("CollisionShape2D").queue_free()	
	if body.name == "Player2":
		player2 = body
		body.get_node("CollisionShape2D").queue_free()
	
	
	timer.start()

func _on_timer_timeout():
	if player1:
		player1.queue_free()	
	if player2:
		player2.queue_free()	



