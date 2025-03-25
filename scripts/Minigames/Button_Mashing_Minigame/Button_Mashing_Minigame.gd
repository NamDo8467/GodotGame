extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"

@onready var progress_Bar = $CanvasLayer/Progress_Bar
@onready var p1_Press_A = $Player_1_Press_A
@onready var p1_Press_B = $Player_1_Press_B
@onready var p2_Press_A = $Player_2_Press_A
@onready var p2_Press_B = $Player_2_Press_B

# Player Variables
enum player_Buttons {NONE, A1, A2}
# P1
var p1_Button_To_Press = player_Buttons.NONE
var p1_Switch_Chance = 99
# P2
var p2_Button_To_Press = player_Buttons.NONE
var p2_Switch_Chance = 99

# Game Variables
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 15.0 # Change this to adjust timers
	
	p1_Press_A.visible = false
	p1_Press_B.visible = false
	p2_Press_A.visible = false
	p2_Press_B.visible = false
	
	super()
	
	Set_P1_Buttons_To_Press()
	Set_P2_Buttons_To_Press()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_Game_Started:
		return
	
	# Minigame Gameplay Here
	P1_Button_Check()
	P2_Button_Check()
	
	super(delta)

func P1_Button_Check():
	if Input.is_action_just_pressed("P1_Minigame_Action_1"):
		match p1_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(2)
				Set_P1_Buttons_To_Press()
			player_Buttons.A2:
				Calculate_Score(-1)
	
	if Input.is_action_just_pressed("P1_Minigame_Action_2"):
		match p1_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(-1)
			player_Buttons.A2:
				Calculate_Score(2)
				Set_P1_Buttons_To_Press()

func P2_Button_Check():
	if Input.is_action_just_pressed("P2_Minigame_Action_1"):
		match p2_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(2)
				Set_P2_Buttons_To_Press()
			player_Buttons.A2:
				Calculate_Score(-1)
	
	if Input.is_action_just_pressed("P2_Minigame_Action_2"):
		match p2_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(-1)
			player_Buttons.A2:
				Calculate_Score(2)
				Set_P2_Buttons_To_Press()

func Set_P1_Buttons_To_Press():
	rng.randomize()
	if rng.randi_range(0, 99) <= p1_Switch_Chance:
		p1_Switch_Chance = 0
		match p1_Button_To_Press:
			player_Buttons.A1:
				p1_Button_To_Press = player_Buttons.A2
			player_Buttons.A2:
				p1_Button_To_Press = player_Buttons.A1
			player_Buttons.NONE:
				if rng.randi_range(0, 1) == 0:
					p1_Button_To_Press = player_Buttons.A1
				else:
					p1_Button_To_Press = player_Buttons.A2
	else:
		p1_Switch_Chance += 5
		print(p1_Switch_Chance)

func Set_P2_Buttons_To_Press():
	rng.randomize()
	if rng.randi_range(0, 99) <= p2_Switch_Chance:
		p2_Switch_Chance = 0
		match p2_Button_To_Press:
			player_Buttons.A1:
				p2_Button_To_Press = player_Buttons.A2
			player_Buttons.A2:
				p2_Button_To_Press = player_Buttons.A1
			player_Buttons.NONE:
				if rng.randi_range(0, 1) == 0:
					p2_Button_To_Press = player_Buttons.A1
				else:
					p2_Button_To_Press = player_Buttons.A2
	else:
		p2_Switch_Chance += 5
	
	Update_Button_To_Press_Display()

func Update_Button_To_Press_Display():
	match p1_Button_To_Press:
		player_Buttons.A1:
			p1_Press_B.visible = false
			p1_Press_A.visible = true
		player_Buttons.A2:
			p1_Press_A.visible = false
			p1_Press_B.visible = true
	match p2_Button_To_Press:
		player_Buttons.A1:
			p2_Press_B.visible = false
			p2_Press_A.visible = true
		player_Buttons.A2:
			p2_Press_A.visible = false
			p2_Press_B.visible = true

func Calculate_Score(score):
	progress_Bar.value += score
	
	current_Score = progress_Bar.value
	
	score_Text.text = ("[right]Score " + str(current_Score) + "%[/right]   ")
	
	if current_Score >= progress_Bar.max_value:
		End_Minigame()

func Game_Finished_Check():
	
	super()

