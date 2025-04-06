extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 15.0 # Change this to adjust timers
	
	Start_Countdown()
	await get_tree().create_timer(3).timeout
	
	pass

# Called after timmer ends
func Game_Start():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_Game_Started:
		return
	
	# Custom Game Stuff Here
	
	
	Game_Finished_Check()
	Update_Timmer(delta)

func Calculate_Score():
	pass

func Game_Finished_Check():
	pass


func End_Minigame():
	# End animations and sounds here
	
	
	super()
