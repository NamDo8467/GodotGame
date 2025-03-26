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
	var player = body.name
	Global.player_set_to_show_elevator[player] = null
	
	if len(Global.player_set_to_show_elevator) >= 2:
		camera.zoom.x = 1.4
		camera.zoom.y = 1

		camera.position = Vector2(300, 504)
