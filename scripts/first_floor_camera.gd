extends Node2D

var cameraEnterZone
var camera

var player_set_to_show_elevator = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	cameraEnterZone = $CameraEnterZone
	camera = $Camera2D
	player_set_to_show_elevator["Player"] = null
	player_set_to_show_elevator["Player2"] = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(delta)
	pass


#func _on_camera_enter_zone_body_entered(body):
	##print(player_set_to_show_elevator)
	#var player = body.name
	#player_set_to_show_elevator.erase(player)
	#
	#camera.zoom.x = 0.99
	#camera.zoom.y = 1
	#
	#camera.position = Vector2(1657, 504)


func _on_camera_leaving_zone_body_entered(body):
	var player = body.name
	player_set_to_show_elevator[player] = null
	
	if len(player_set_to_show_elevator) >= 2:
		camera.zoom.x = 1.4
		camera.zoom.y = 1

		camera.position = Vector2(300, 504)
