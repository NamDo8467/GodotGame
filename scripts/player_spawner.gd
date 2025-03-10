extends Node2D


var player1_scene = preload("res://scenes/player.tscn")
var player2_scene = preload("res://scenes/player2.tscn")
var player1_starting_position = Vector2(-89,Global.spawning_position_y)
var player2_starting_position = Vector2(-150, Global.spawning_position_y)
var player1 = null
var player2 = null

func _ready():
	#print(spawning_area.position)
	pass
func _process(_delta):
	if player1 == null:
		player1 = player1_scene.instantiate()
		player1_starting_position.y = Global.spawning_position_y
		print(Global.spawning_position_y)
		player1.position = player1_starting_position
		get_parent().add_child(player1)
	if player2 == null:
		player2 = player2_scene.instantiate()
		player2_starting_position.y = Global.spawning_position_y
		player2.position = player2_starting_position
		get_parent().add_child(player2)
		
