extends Node2D

# Base Variables
signal Minigame_Finished(score)

@onready var p1 = $Player_1
@onready var p2 = $Player_2
@onready var start_Countdown = $CanvasLayer/Start_Countdown
@onready var timmer_Background = $CanvasLayer/Timmer/Background
@onready var timmer_Tracker = $CanvasLayer/Timmer/Background/Tracker
@onready var score_Text = $CanvasLayer/Score_Text # TODO: Change this to be based off stars

# Music Variables
@onready var bg_Music = $CanvasLayer/Sound/BG_Music
@onready var countdown_Bleep = $CanvasLayer/Start_Countdown/Sound/Countdown_Bleep
@onready var timmer_Ending_Ring = $CanvasLayer/Timmer/Background/Sound/Ending_Ring
@onready var timmer_Tick = $CanvasLayer/Timmer/Background/Sound/Tick

# Score Variables
var current_Score = 0.0

# Timmer Variables
var timmer_Tween : Tween
var is_Game_Started = false
var current_Time = 0.0
var minigame_Time = 10.0

# Transition Variables
var transition : ColorRect
var tansition_Time = 2.0


# Called when the node enters the scene tree for the first time.
func _ready():
	Start_Countdown()

func Start_Countdown():
	current_Time = 0
	timmer_Tracker.rotation_degrees = current_Time + 5
	
	await get_tree().create_timer(1).timeout
	
	var tween = create_tween()
	tween.tween_property(timmer_Background, "value", minigame_Time, 3)
	
	Start_Timmer()
	
	countdown_Bleep.play()
	await get_tree().create_timer(1).timeout
	countdown_Bleep.play()
	start_Countdown.text = "[center]2[/center]"
	countdown_Bleep.play()
	await get_tree().create_timer(1).timeout
	start_Countdown.text = "[center]1[/center]"
	countdown_Bleep.play()
	await get_tree().create_timer(1).timeout
	start_Countdown.text = "[center]GO![/center]"
	bg_Music.play()
	
	is_Game_Started = true
	
	timmer_Tick.play()
	
	var fade_out = create_tween()
	fade_out.tween_property(start_Countdown, "modulate", Color(1, 1, 1, 0), 1)

func Start_Timmer():
	timmer_Tween = get_tree().create_tween()
	
	var degree = 360 * (minigame_Time / timmer_Background.max_value)
	timmer_Tween.tween_property(timmer_Tracker, "rotation_degrees", degree, 3)
	timmer_Tween.tween_property(timmer_Tracker, "rotation_degrees", 1, minigame_Time).finished.connect(End_Minigame)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	
	is_Game_Started = false
	
	timmer_Tick.stop()
	bg_Music.stop()
	timmer_Ending_Ring.play()
	
	await get_tree().create_timer(1).timeout
	
	Update_Score_Stars()
	
	timmer_Tween.stop()
	
	start_Countdown.modulate = Color(0, 0, 0, 1)
	
	start_Countdown.text = "[font_size=100][center]Your score is " + str(current_Score) + "%[/center]" 
	
	emit_signal("Minigame_Finished", current_Score)
