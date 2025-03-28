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
	
	if body.position.x <= 694:
		Global.die_outside_of_the_room = true
		Global.spawning_position_x = 130
	else:
		Global.die_outside_of_the_room = false
		Global.spawning_position_x = 1053
	timer.start()

func _on_timer_timeout():
	if player1:
		if player1.has_node("Trampoline"):
			player1.remove_child(player1.get_node("Trampoline"))
			
		player1.queue_free()
		player1 = null	
	if player2:
		if player2.has_node("Trampoline"):
			player2.remove_child(player2.get_node("Trampoline"))
		player2.queue_free()
		player2 = null	



