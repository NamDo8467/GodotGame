extends Node2D


var player1_scene = preload("res://scenes/player.tscn")
var starting_position = Vector2(787,888)
var player1 = null

func _process(_delta):
	if player1 == null:
		player1 = player1_scene.instantiate()
		player1.position = starting_position
		get_parent().add_child(player1)
