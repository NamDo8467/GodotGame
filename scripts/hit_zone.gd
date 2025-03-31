extends Area2D

@onready var squished_sound: AudioStreamPlayer2D = $SquishedSound
@onready var timer = $Timer
@onready var monster = get_parent()
func _on_body_entered(body):
	monster.get_node("KillZone").queue_free()
	squished_sound.play()
	await squished_sound.finished
	if monster.name == "CabbageMonster":
		monster.queue_free()
		Global.transition_to_minigames()
	else:
		monster.queue_free()
	#monster.get_node("KillZone").queue_free()
	#timer.start()
	
	
func _on_timer_timeout():
	pass
	#if monster.name == "CabbageMonster":
		#monster.queue_free()
		#Global.transition_to_minigames()
	#else:
		#monster.queue_free()
	
