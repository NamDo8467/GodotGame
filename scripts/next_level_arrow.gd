extends Area2D
@onready var arrow = $AnimatedSprite2D

func _on_body_entered(body):
	arrow.play("hit")
	SceneTransitionAnimation.change_scene()
	await SceneTransitionAnimation.animation_player.animation_finished
	var next_level = Global.level + 1
	var path_to_next_level:String = "res://scenes/level_" + str(next_level) + ".tscn" 
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
