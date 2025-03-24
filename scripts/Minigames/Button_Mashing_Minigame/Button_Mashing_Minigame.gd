extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 15.0 # Change this to adjust timers
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	
	# Minigame Gameplay Here
	

func Calculate_Score():
	return current_Score

func Game_Finished_Check():
	print("Here")
	
	super()

