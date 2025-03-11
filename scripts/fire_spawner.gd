extends Node2D
# Called when the node enters the scene tree for the first time.
var fire_starting_position_x = 60
var fire_starting_position_y = 422
var fire_scene = preload("res://scenes/fire.tscn")
var fire_instantiated = false
func _ready():
	#for i in range(0, 100, 10):
	pass
		#print("ahahhah")
		
		


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if fire_instantiated == false:
		for i in range(0, 500, 30):
			var fire = fire_scene.instantiate()
			fire.position = Vector2(fire_starting_position_x + i, fire_starting_position_y)
			get_parent().add_child(fire)
		fire_instantiated = true
