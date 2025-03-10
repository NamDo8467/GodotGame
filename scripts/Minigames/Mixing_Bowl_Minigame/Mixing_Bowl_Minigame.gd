extends Node2D

signal Minigame_Finished(score)

@onready var start_Timmer = $CanvasLayer/Start_Timmer

# Timmer Variables
var timmer_Tween : Tween
var is_Game_Started = false
var current_Time = 0.0
var minigame_Time = 15.0
var transition : ColorRect
var tansition_Time = 2.0

var current_Score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func Update_Score_Text():
	#var total = 0
	#var num_Scores = 0
#
	#for score in cut_Scores:
		#if score >= 0:
			#total += score
			#num_Scores += 1
	#
	#total /= num_Scores
	#total *= 100
	#total = round(total)
	#total /= 100
	#
	#current_Score = total
	#
	#score_Text.text = ("[right]Score " + str(current_Score) + "%[/right]   ")
	pass


func End_Minigame():
	if !is_Game_Started:
		return
	
	Update_Score_Text()
	
	timmer_Tween.stop()
	
	is_Game_Started = false
	start_Timmer.modulate = Color(0, 0, 0, 1)
	
	start_Timmer.text = "[font_size=100][center]Your score is " + str(current_Score) + "%[/center]" 
	
	emit_signal("Minigame_Finished", current_Score)
