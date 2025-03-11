extends Node2D

signal Minigame_Finished(score)

@onready var start_Timmer = $CanvasLayer/Start_Timmer
@onready var score_Text = $CanvasLayer/Score_Text
@onready var game_Timmer = $CanvasLayer/Game_Timmer
@onready var current_Timmer = $CanvasLayer/Current_Timmer
@onready var bowl = $Bowl
@onready var mix_Bar = $CanvasLayer/Mix_Bar
@onready var p1_Node = $Player_1
@onready var p1_Bowl = $Bowl/Player_1_Bowl
@onready var p2_Node = $Player_2
@onready var p2_Bowl = $Bowl/Player_2_Bowl

# Timmer Variables
var timmer_Tween : Tween
var is_Game_Started = false
var current_Time = 0.0
var minigame_Time = 15.0
var transition : ColorRect
var tansition_Time = 2.0

var current_Score = 0

var MIN_SPEED = -4.0
var JUMP_VELOCITY = 10.0
var GRAVITY = 8 # per second
var FALL_BOOST = -16
var GRAVITY_BOOST = 3

var MAX_POINTS_HEIGHT = 110
var MIN_POINTS_HEIGHT = 180
var MAX_POINTS_EARNED = 10

enum player_States {BOWL, JUMP, FAST_FALL, STUMBLE}

var is_Able_To_Jump = true

var p1_Velocity = Vector2.ZERO
var p1_State = player_States.BOWL
var p1_Height_Reached = -1

var p2_Velocity = Vector2.ZERO
var p2_State = player_States.BOWL
var p2_Height_Reached = -1

# Bowl Variables
var MAX_BOWL_ANGLE = 30.0
var bowl_Tween : Tween
var tilt_Speed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Start_Countdown()
	await get_tree().create_timer(3).timeout
	
	Start_Timmer()

func Start_Countdown():
	current_Time = 0
	current_Timmer.rotation = current_Time

	var tween = create_tween()
	
	tween.tween_property(game_Timmer, "value", minigame_Time, 3)

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
	var degree = 360 * (minigame_Time / game_Timmer.max_value)
	timmer_Tween = create_tween()
	timmer_Tween.tween_property(current_Timmer, "rotation_degrees", degree, minigame_Time).finished.connect(End_Minigame)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_Game_Started:
		return
	
	if is_Able_To_Jump:
		P1_Actions()
		P2_Actions()
	
	Move_P1(delta)
	Move_P2(delta)
	
	Bowl_Check()

func P1_Actions():
	if Input.is_action_just_pressed("P1_Minigame_Action_1") && p1_State == player_States.BOWL:
		p1_State = player_States.JUMP
		p1_Velocity.y = JUMP_VELOCITY
		
		Bowl_Rotation(1)

	
	if Input.is_action_just_pressed("P1_Minigame_Action_2") && p1_State == player_States.JUMP:
		p1_State = player_States.FAST_FALL
		if p1_Velocity.y > FALL_BOOST:
			p1_Velocity.y = FALL_BOOST
	
		p1_Height_Reached = p1_Node.position.y

func P2_Actions():
	if Input.is_action_just_pressed("P2_Minigame_Action_1") && p2_State == player_States.BOWL:
		p2_State = player_States.JUMP
		p2_Velocity.y = JUMP_VELOCITY
		
		Bowl_Rotation(-1)

	
	if Input.is_action_just_pressed("P2_Minigame_Action_2") && p2_State == player_States.JUMP:
		p2_State = player_States.FAST_FALL
		if p2_Velocity.y > FALL_BOOST:
			p2_Velocity.y = FALL_BOOST
		
		p2_Height_Reached = p2_Node.position.y

func Move_P1(delta):
	p1_Node.position.x = p1_Bowl.global_position.x
	
	match p1_State:
		player_States.BOWL:
			p1_Node.position.y = p1_Bowl.global_position.y
		player_States.JUMP:
			p1_Velocity.y -= GRAVITY * delta
			
			if p1_Velocity.y < MIN_SPEED:
				p1_Velocity.y = MIN_SPEED
			
			p1_Node.position.y -= p1_Velocity.y
			
			if p1_Velocity.y <= -4 && p1_Height_Reached == -1:
				p1_Height_Reached = p1_Node.position.y
		player_States.FAST_FALL:
			p1_Velocity.y -= GRAVITY_BOOST * GRAVITY * delta
			
			if p1_Velocity.y < MIN_SPEED * GRAVITY_BOOST:
				p1_Velocity.y = MIN_SPEED * GRAVITY_BOOST
			
			p1_Node.position.y -= p1_Velocity.y

func Move_P2(delta):
	p2_Node.position.x = p2_Bowl.global_position.x
	
	match p2_State:
		player_States.BOWL:
			p2_Node.position.y = p2_Bowl.global_position.y
		player_States.JUMP:
			p2_Velocity.y -= GRAVITY * delta
			
			if p2_Velocity.y < MIN_SPEED:
				p2_Velocity.y = MIN_SPEED
			
			p2_Node.position.y -= p2_Velocity.y
			
			if p2_Velocity.y <= -4 && p2_Height_Reached == -1:
				p2_Height_Reached = p2_Node.position.y
		player_States.FAST_FALL:
			p2_Velocity.y -= GRAVITY_BOOST * GRAVITY * delta
			
			if p2_Velocity.y < MIN_SPEED * GRAVITY_BOOST:
				p2_Velocity.y = MIN_SPEED * GRAVITY_BOOST
			
			p2_Node.position.y -= p2_Velocity.y

func Bowl_Check():
	Bowl_Reset()
	
	if p1_Node.position.y > p1_Bowl.global_position.y && p1_State != player_States.BOWL:
		p1_Node.position.y = p1_Bowl.global_position.y
		p1_State = player_States.BOWL
		
		Update_Score_Text(p1_Height_Reached)
		p1_Height_Reached = -1
	
	if p2_Node.position.y > p2_Bowl.global_position.y && p2_State != player_States.BOWL:
		p2_Node.position.y = p2_Bowl.global_position.y
		p2_State = player_States.BOWL
		
		Update_Score_Text(p2_Height_Reached)
		p2_Height_Reached = -1

func Bowl_Rotation(tilt_Direction):
	bowl_Tween = create_tween()
	bowl_Tween.tween_property(bowl, "rotation_degrees", MAX_BOWL_ANGLE * tilt_Direction, 0.5)
	bowl_Tween.tween_property(bowl, "rotation_degrees", 0, 1)

func Bowl_Reset():
	
	if !is_Able_To_Jump:
		return
	
	p1_Node.modulate = Color(1, 1, 1, 1)
	p2_Node.modulate = Color(1, 1, 1, 1)
	
	if bowl.rotation_degrees == 0:
		return
	
	if p1_State != player_States.BOWL || p2_State != player_States.BOWL:
		return
	
	is_Able_To_Jump = false
	p1_Node.modulate = Color(0.2, 0.2, 0.2, 1)
	p2_Node.modulate = Color(0.2, 0.2, 0.2, 1)
	
	bowl_Tween = create_tween()
	bowl_Tween.tween_property(bowl, "rotation_degrees", 0, 1.5).finished.connect(set.bind("is_Able_To_Jump", true))

func Update_Score_Text(height):
	var score = remap(height, 180, 100, 2, 18)
	score *= 100
	score = round(score)
	score /= 100
	
	if score >= 18:
		score = 18
	
	if score <= -5:
		score = -5

	mix_Bar.value += score 
	
	current_Score = mix_Bar.value
	
	score_Text.text = ("[right]Score " + str(current_Score) + "%[/right]   ")
	
	if current_Score >= mix_Bar.max_value:
		End_Minigame()

func End_Minigame():
	if !is_Game_Started:
		return
	
	bowl_Tween.stop()
	timmer_Tween.stop()
	
	is_Game_Started = false
	start_Timmer.modulate = Color(0, 0, 0, 1)
	
	start_Timmer.text = "[font_size=100][center]Your score is " + str(current_Score) + "%[/center]" 
	
	emit_signal("Minigame_Finished", current_Score)
