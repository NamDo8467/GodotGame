extends Area2D


# Called when the node enters the scene tree for the first time.
#var player_set_to_show_elevator = {}
var camera
func _ready():
	Global.player_set_to_show_elevator["Player"] = null
	Global.player_set_to_show_elevator["Player2"] = null
	camera = get_parent().get_child(0)
	#print(camera)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	var player = body.name
	Global.player_set_to_show_elevator.erase(player)
	
	Global.is_Inisde_Room = true
	
	camera.zoom.x = 0.99
	camera.zoom.y = 1
	
	camera.position = Vector2(1657, 504)
