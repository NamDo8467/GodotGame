extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"

@onready var progress_Bar = $CanvasLayer/Progress_Bar
@onready var p1_Press_A = $Player_1_Press_A
@onready var p1_Press_B = $Player_1_Press_B
@onready var p2_Press_A = $Player_2_Press_A
@onready var p2_Press_B = $Player_2_Press_B

# Sound Variables
@onready var p1_Cutting = $CanvasLayer/Sound/Sound_Effects/Cutting_P1
@onready var p2_Cutting = $CanvasLayer/Sound/Sound_Effects/Cutting_P2
var MIN_PITCH = 0.5
var MAX_PITCH = 1.75
var PITCH_GAIN_STEP = 0.1
var PITCH_LOSS_STEP = -0.05
var p1_Pitch = 1.0
var p2_Pitch = 1.0

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
var points_Gained = 3
var points_Lost = -2

# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 15.0 # Change this to adjust timers
	
	p1_Press_A.visible = false
	p1_Press_B.visible = false
	p2_Press_A.visible = false
	p2_Press_B.visible = false
	
	super()
	

# Called after timmer ends
func Game_Start():
	Set_P1_Buttons_To_Press()
	Set_P2_Buttons_To_Press()
	
	p1_Cutting.play()
	p2_Cutting.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_Game_Started:
		return
	
	Update_Pitch_Speed(delta)
	
	# Minigame Gameplay Here
	P1_Button_Check()
	P2_Button_Check()
	
	Game_Finished_Check()
	Update_Timmer(delta)

func P1_Button_Check():
	if Input.is_action_just_pressed("P1_Minigame_Action_1"):
		match p1_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(points_Gained)
				p1_Pitch += PITCH_GAIN_STEP
				Set_P1_Buttons_To_Press()
			player_Buttons.A2:
				p1_Pitch += PITCH_LOSS_STEP
				Calculate_Score(points_Lost)
	
	if Input.is_action_just_pressed("P1_Minigame_Action_2"):
		match p1_Button_To_Press:
			player_Buttons.A1:
				p1_Pitch += PITCH_LOSS_STEP
				Calculate_Score(points_Lost)
			player_Buttons.A2:
				Calculate_Score(points_Gained)
				p1_Pitch += PITCH_GAIN_STEP
				Set_P1_Buttons_To_Press()

func P2_Button_Check():
	if Input.is_action_just_pressed("P2_Minigame_Action_1"):
		match p2_Button_To_Press:
			player_Buttons.A1:
				Calculate_Score(points_Gained)
				p2_Pitch += PITCH_GAIN_STEP
				Set_P2_Buttons_To_Press()
			player_Buttons.A2:
				p2_Pitch += PITCH_LOSS_STEP
				Calculate_Score(points_Lost)
	
	if Input.is_action_just_pressed("P2_Minigame_Action_2"):
		match p2_Button_To_Press:
			player_Buttons.A1:
				p2_Pitch += PITCH_LOSS_STEP
				Calculate_Score(points_Lost)
			player_Buttons.A2:
				Calculate_Score(points_Gained)
				p2_Pitch += PITCH_GAIN_STEP
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
	
	Update_Button_To_Press_Display()

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

func Update_Pitch_Speed(delta):
	p1_Pitch += PITCH_LOSS_STEP * delta
	p1_Pitch = clamp(p1_Pitch, MIN_PITCH, MAX_PITCH)
	
	p1_Cutting.pitch_scale = p1_Pitch
	
	p2_Pitch += PITCH_LOSS_STEP * delta
	p2_Pitch = clamp(p2_Pitch, MIN_PITCH, MAX_PITCH)
	
	p2_Cutting.pitch_scale = p2_Pitch


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

func Game_Finished_Check():
	if current_Score >= progress_Bar.max_value:
		End_Minigame()


func End_Minigame():
	p1_Cutting.stop()
	p2_Cutting.stop()
	
	super()
