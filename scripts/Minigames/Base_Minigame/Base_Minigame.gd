extends Node2D

# Base Variables
signal Minigame_Finished(score)

@onready var p1 = $Player_1
@onready var p2 = $Player_2
@onready var start_Timmer = $CanvasLayer/Start_Timmer
@onready var game_Timmer = $CanvasLayer/Game_Timmer
@onready var current_Timmer = $CanvasLayer/Current_Timmer
@onready var score_Text = $CanvasLayer/Score_Text # TODO: Change this to be based off stars

# Score Variables
var current_Score = 0.0

# Timmer Variables
var timmer_Tween : Tween
var is_Game_Started = false
var current_Time = 0.0
var minigame_Time

# Transition Variables
var transition : ColorRect
var tansition_Time = 2.0


# Called when the node enters the scene tree for the first time.
func _ready():
	Start_Countdown()

func Start_Countdown():
	current_Time = 0
	var tween = create_tween()
	
	tween.tween_property(game_Timmer, "value", minigame_Time, 3)
	
	Start_Timmer()
	
	await get_tree().create_timer(1).timeout
	start_Timmer.text = "[center]2[/center]"
	await get_tree().create_timer(1).timeout
	start_Timmer.text = "[center]1[/center]"
	await get_tree().create_timer(1).timeout
	start_Timmer.text = "[center]GO![/center]"
	
	is_Game_Started = true
	
	var fade_out = create_tween()
	fade_out.tween_property(start_Timmer, "modulate", Color(1, 1, 1, 0), 1)

func Start_Timmer():
	current_Timmer.rotation_degrees = current_Time + 5
	
	timmer_Tween = get_tree().create_tween()
	
	var degree = 360 * (minigame_Time / game_Timmer.max_value)
	timmer_Tween.tween_property(current_Timmer, "rotation_degrees", degree, 3)
	timmer_Tween.tween_property(current_Timmer, "rotation_degrees", 0, minigame_Time).finished.connect(End_Minigame)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Game_Finished_Check()
	Update_Timmer(delta)

func Update_Score_Stars():
	return # TODO: Add the stars (maybe piece by piece)

func Update_Timmer(delta):
	current_Time += delta

# Abstract
func Game_Finished_Check():
	pass

func End_Minigame():
	if !is_Game_Started:
		return
	
	Update_Score_Stars()
	
	timmer_Tween.stop()
	
	is_Game_Started = false
	start_Timmer.modulate = Color(0, 0, 0, 1)
	
	start_Timmer.text = "[font_size=100][center]Your score is " + str(current_Score) + "%[/center]" 
	
	emit_signal("Minigame_Finished", current_Score)
