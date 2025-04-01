extends Node2D
# Called when the node enters the scene tree for the first time.
var fire_starting_position_x = 1120
var fire_starting_position_y = 560
var fire_scene = preload("res://scenes/fire.tscn")
var fire_instantiated = false
var drop_fire = 0 # will be used to recreate fire after all of them drop. There are 37 fire in total

#@onready var timer = $Timer
		
		
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if fire_instantiated == false:
		#1110
		for i in range(0, 1110, 30):
			var fire = fire_scene.instantiate()
			fire.position = Vector2(fire_starting_position_x + i, fire_starting_position_y)
			get_parent().add_child(fire)
		fire_instantiated = true
		#drop_fire = 0



#func _on_timer_timeout():
	#fire_instantiated = false
	##drop_fire = 0
	#print(" I run")
	
