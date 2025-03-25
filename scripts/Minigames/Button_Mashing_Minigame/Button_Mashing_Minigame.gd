extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"

@onready var progress_Bar = $CanvasLayer/Progress_Bar

# Player Variables
enum player_Buttons {NONE, A1, A2}
# P1
var p1_Button_To_Press = player_Buttons.NONE
var p1_Switch_Chance = 0
# P2
var p2_Button_To_Press = player_Buttons.NONE
var p2_Switch_Chance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 15.0 # Change this to adjust timers
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_Game_Started:
		return
	
	# Minigame Gameplay Here
	Set_Buttons_To_Press()
	
	P1_Button_Check()
	P2_Button_Check()
	
	super(delta)

func Set_Buttons_To_Press():
	p1_Button_To_Press = player_Buttons.A1
	p2_Button_To_Press = player_Buttons.A2

func P1_Button_Check():
	if Input.is_action_just_pressed("P1_Minigame_Action_1"):
		match p1_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(2)
			player_Buttons.A2:
				Calculate_Score(-1)
	
	if Input.is_action_just_pressed("P1_Minigame_Action_2"):
		match p1_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(-1)
			player_Buttons.A2:
				Calculate_Score(2)

func P2_Button_Check():
	if Input.is_action_just_pressed("P2_Minigame_Action_1"):
		match p2_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(2)
			player_Buttons.A2:
				Calculate_Score(-1)
	
	if Input.is_action_just_pressed("P2_Minigame_Action_2"):
		match p2_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(-1)
			player_Buttons.A2:
				Calculate_Score(2)

func Calculate_Score(score):
	progress_Bar.value += score
	
	current_Score = progress_Bar.value
	
	score_Text.text = ("[right]Score " + str(current_Score) + "%[/right]   ")
	
	if current_Score >= progress_Bar.max_value:
		End_Minigame()

func Game_Finished_Check():
	
	super()

