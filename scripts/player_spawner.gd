extends Node2D


var player1_scene = preload("res://scenes/player.tscn")
var player2_scene = preload("res://scenes/player2.tscn")
var player1_starting_position = Vector2(787,888)
var player2_starting_position = Vector2(928, 888)
var player1 = null
var player2 = null

func _process(_delta):
	if player1 == null:
		player1 = player1_scene.instantiate()
		player1.position = player1_starting_position
		get_parent().add_child(player1)
	if player2 == null:
		player2 = player2_scene.instantiate()
		player2.position = player2_starting_position
		get_parent().add_child(player2)
		
