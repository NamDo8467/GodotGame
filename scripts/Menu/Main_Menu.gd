extends Control


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func StartGame_Pressed():
	#TODO: Change this to move to a level select screen
	get_tree().change_scene_to_file("res://scenes/game.tscn") 

func Settings_Pressed():
	#TODO: Connect this to a menu
	print("Open Settings")

func Quit_Pressed():
	get_tree().quit()
