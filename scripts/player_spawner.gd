extends Node2D


var player1_scene = preload("res://scenes/player.tscn")
var player2_scene = preload("res://scenes/player2.tscn")
#var player1_starting_position = Vector2(Global.spawning_position_x, Global.spawning_position_y)
#var player2_starting_position = Vector2(Global.spawning_position_x - 120, Global.spawning_position_y)
var player1 = null
var player2 = null

func _ready():
	#print(spawning_area.position)
	pass
func _process(_delta):
	if player1 == null:
		player1 = player1_scene.instantiate()
		var player1_starting_position = Vector2(Global.spawning_position_x, Global.spawning_position_y)
		player1.position = player1_starting_position
		Global.player_set_to_show_elevator[player1.name] = null
		get_parent().add_child(player1)
	if player2 == null:
		player2 = player2_scene.instantiate()
		var player2_starting_position = Vector2(Global.spawning_position_x - 120, Global.spawning_position_y)
		player2.position = player2_starting_position
		Global.player_set_to_show_elevator[player2.name] = null
		get_parent().add_child(player2)
		
	if Input.is_action_just_released("restart"):
		Global.reset_apartment_scene()
		get_tree().reload_current_scene()
		
	if Input.is_action_just_released("go_to_minigames"):
		Global.transition_to_minigames()
