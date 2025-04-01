extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 15.0 # Change this to adjust timers
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_Game_Started:
		return
	
	
	
	super(delta)

func Calculate_Score():
	pass

func Game_Finished_Check():
	pass
	
	super()

