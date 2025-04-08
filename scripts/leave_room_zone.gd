extends Area2D

var camera
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_parent().get_child(0)
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	var player_name = body.name
	if (player_name == "Player" and body.is_picking_player2_up) or (player_name == "Player2" and body.is_picking_player1_up):
		Global.player_set_to_show_elevator["Player"] = null
		Global.player_set_to_show_elevator["Player2"] = null
	else:
		Global.player_set_to_show_elevator[player_name] = null
	
	if len(Global.player_set_to_show_elevator) >= 2:
		Global.is_Inisde_Room = false
		
		camera.zoom.x = 1.4
		camera.zoom.y = 1

		camera.position = Vector2(300, 504)
