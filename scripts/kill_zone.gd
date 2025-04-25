extends Area2D

@onready var timer = $Timer
var player1 = null
var player2 = null
func _on_body_entered(body):
	
	print(position.y - body.position.y)
	#if body.name == "Player" :
		#player1 = body
		#player1.Is_Alive = false
		#var collision_shape = body.get_node("CollisionShape2D")
		#collision_shape.queue_free()
		#var falling_sound = player1.get_node("FallingSound")
		#falling_sound.play()
		#var death_Animation = player1.player_sprite
		#death_Animation.play("Death")
		##await falling_sound.finished
			#
	#if body.name == "Player2":
		#player2 = body
		#player2.Is_Alive = false
		#body.get_node("CollisionShape2D").queue_free()
		#var falling_sound = player2.get_node("FallingSound")
		#falling_sound.play()
		#
		#player2.player_sprite.play("Death")
		
		
		#await falling_sound.finished
		
	#if body.position.x <= 900:
		#Global.die_outside_of_the_room = true
		#Global.spawning_position_x = 130
	#else:
		#Global.die_outside_of_the_room = false
		#Global.spawning_position_x = 1053
	
	if Global.is_Inisde_Room:
		Global.spawning_position_x = 1053
	else:
		Global.spawning_position_x = 130
	
	timer.start()

func _on_timer_timeout():
	if player1:
		player1.Is_Alive = true
		if player1.has_node("Trampoline"):
			player1.remove_child(player1.get_node("Trampoline"))
		player1.queue_free()
		player1 = null
		print("Hello")
	if player2:
		player2.Is_Alive = true
		if player2.has_node("Trampoline"):
			player2.remove_child(player2.get_node("Trampoline"))
		player2.queue_free()
		player2 = null	


