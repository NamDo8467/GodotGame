extends Node2D

signal Minigame_Finished(score)

@onready var start_Timmer = $CanvasLayer/Start_Timmer
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

enum player_States {BOWL, JUMP, FAST_FALL, STUMBLE}

var is_Able_To_Jump = true

var p1_Velocity = Vector2.ZERO
var p1_State = player_States.BOWL

var p2_Velocity = Vector2.ZERO
var p2_State = player_States.BOWL

# Bowl Variables
var MAX_BOWL_ANGLE = 30.0
var bowl_Tween : Tween
var tilt_Direction = 1.0
var tilt_Speed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	P1_Actions()
	P2_Actions()
	
	Move_P1(delta)
	Move_P2(delta)
	
	Bowl_Check()

func P1_Actions():
	if Input.is_action_just_pressed("P1_Minigame_Action_1") && p1_State == player_States.BOWL:
		p1_State = player_States.JUMP
		p1_Velocity.y = JUMP_VELOCITY
		
		Bowl_Rotation()

	
	if Input.is_action_just_pressed("P1_Minigame_Action_2") && p1_State == player_States.JUMP:
		p1_State = player_States.FAST_FALL
		if p1_Velocity.y > FALL_BOOST:
			p1_Velocity.y = FALL_BOOST
	

func P2_Actions():
	if Input.is_action_just_pressed("P2_Minigame_Action_1") && p2_State == player_States.BOWL:
		p2_State = player_States.JUMP
		p2_Velocity.y = JUMP_VELOCITY
		
		Bowl_Rotation()

	
	if Input.is_action_just_pressed("P2_Minigame_Action_2") && p2_State == player_States.JUMP:
		p2_State = player_States.FAST_FALL
		if p2_Velocity.y > FALL_BOOST:
			p2_Velocity.y = FALL_BOOST

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
		
		Update_Mix_Bar()
	
	if p2_Node.position.y > p2_Bowl.global_position.y && p2_State != player_States.BOWL:
		p2_Node.position.y = p2_Bowl.global_position.y
		p2_State = player_States.BOWL
		
		Update_Mix_Bar()

func Bowl_Rotation():
	if p1_State != player_States.BOWL:
		print(p1_State)
		tilt_Direction = 1
	
	if p2_State != player_States.BOWL:
		tilt_Direction = -1
	
	
	bowl_Tween = create_tween()
	bowl_Tween.tween_property(bowl, "rotation_degrees", MAX_BOWL_ANGLE * tilt_Direction, 0.5)

func Bowl_Reset():
	if p1_State != player_States.BOWL || p2_State != player_States.BOWL:
		return
	
	is_Able_To_Jump = false
	
	bowl_Tween = create_tween()
	bowl_Tween.tween_property(bowl, "rotation_degrees", 0, 0.5)

func Update_Mix_Bar():
	mix_Bar.value += 10

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
