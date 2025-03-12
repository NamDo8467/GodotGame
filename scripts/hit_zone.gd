extends Area2D

@onready var timer = $Timer
@onready var monster = get_parent()
func _on_body_entered(body):
	if monster.name == "CabbageMonster":
		monster.queue_free()
		Global.transition_to_minigames()
	else:
		monster.queue_free()
	
	#timer.start()
	
func _on_timer_timeout():
	pass
	#SceneTransitionAnimation.change_scene()
		#
	#await SceneTransitionAnimation.animation_player.animation_finished
	#get_tree().change_scene_to_file("res://scenes/Minigames/Minigame_Menu/Minigame_Menu.tscn")
