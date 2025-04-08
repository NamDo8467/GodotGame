extends Node2D

@onready var star_Holder = $Star_Holder
@onready var food = $Food

func _ready():
	var final_Score = Global.Get_Final_Score()
	
	star_Holder.Set_Stars(final_Score)
	
	if final_Score >= 92:
		food.play("Perfect")
		return
	
	if final_Score >= 40:
		food.play("Good")
		return
	
	food.play("Bad")
