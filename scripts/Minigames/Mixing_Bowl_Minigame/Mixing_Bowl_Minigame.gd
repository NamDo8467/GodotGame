extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"

@onready var mix_Bar = $CanvasLayer/Mix_Bar
@onready var bowl = $Bowl
@onready var p1_Bowl = $Bowl/Player_1_Bowl
@onready var p2_Bowl = $Bowl/Player_2_Bowl

var rng = RandomNumberGenerator.new()

# Constants
var MIN_SPEED = -250.0
var JUMP_VELOCITY = 500.0
var GRAVITY = 350.0
var FALL_BOOST = -360.0
var GRAVITY_BOOST = 5.0

var MAX_POINTS_HEIGHT = 100
var MIN_POINTS_HEIGHT = 220
var MAX_POINTS_EARNED = 18
var MIN_POINTS_EARNED = -10

# Player Variables
enum States {WALKING, CLIMBING, JUMPING, FALLING, STUMBLE}
var is_Able_To_Jump = true
# Player 1 Variables
var p1_Velocity = Vector2.ZERO
var p1_State
# Player 2 Variables
var p2_Velocity = Vector2.ZERO
var p2_State

# Bowl Variables
var MAX_BOWL_ANGLE = 30.0
var bowl_Current_Rotation = 0.0
var bowl_Left_Force = 0.0
var bowl_Right_Force = 0.0
var MAX_FORCE = 1.0
var MIN_FORCE = 0.0
var FORCE_DEC_RATE = 1.0
var bowl_Tilt_Speed = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 15.0 # Change this to adjust timers
	
	rng.randomize()
	match rng.randi_range(0, 1):
			0:
				p1_State = States.JUMPING
				p2_State = States.CLIMBING
			1:
				p1_State = States.CLIMBING
				p2_State = States.JUMPING
	
	Update_Game_State()
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_Game_Started:
		return
	
	Update_Game_State()
	
	if is_Able_To_Jump:
		P1_Actions()
		P2_Actions()
	
	Move_P1(delta)
	Move_P2(delta)
	
	Bowl_Check()
	Bowl_Rotation(delta)
	
	super(delta)

func Update_Game_State():
	match p1_State:
		States.WALKING:
			
		States.CLIMBING:
		
		States.JUMPING:
		
		States.FALLING:
		
		States.STUMBLE:

func P1_Actions():
	if Input.is_action_just_pressed("P1_Minigame_Action_1") && p1_State == States.BOWL:
		p1_State = States.JUMP
		p1_Velocity.y = JUMP_VELOCITY
		
		bowl_Left_Force = MAX_FORCE
	
	if Input.is_action_just_pressed("P1_Minigame_Action_2") && p1_State == States.JUMP:
		p1_State = States.FAST_FALL
		if p1_Velocity.y > FALL_BOOST:
			p1_Velocity.y = FALL_BOOST
		
		p1_Height_Reached = p1.position.y

func P2_Actions():
	if Input.is_action_just_pressed("P2_Minigame_Action_1") && p2_State == States.BOWL:
		p2_State = States.JUMP
		p2_Velocity.y = JUMP_VELOCITY
		
		bowl_Right_Force = MAX_FORCE
	
	if Input.is_action_just_pressed("P2_Minigame_Action_2") && p2_State == States.JUMP:
		p2_State = States.FAST_FALL
		if p2_Velocity.y > FALL_BOOST:
			p2_Velocity.y = FALL_BOOST
		
		p2_Height_Reached = p2.position.y

func Move_P1(delta):
	p1.position.x = p1_Bowl.global_position.x
	
	match p1_State:
		States.BOWL:
			p1.position.y = p1_Bowl.global_position.y
		States.JUMP:
			p1_Velocity.y -= GRAVITY * delta
			
			if p1_Velocity.y < MIN_SPEED:
				p1_Velocity.y = MIN_SPEED
			
			p1.position.y -= p1_Velocity.y * delta
			
			if p1_Velocity.y <= MIN_SPEED && p1_Height_Reached == -1:
				p1_Height_Reached = p1.position.y
		States.FAST_FALL:
			p1_Velocity.y -= GRAVITY_BOOST * GRAVITY * delta
			
			if p1_Velocity.y < MIN_SPEED * GRAVITY_BOOST:
				p1_Velocity.y = MIN_SPEED * GRAVITY_BOOST
			
			p1.position.y -= p1_Velocity.y * delta

func Move_P2(delta):
	p2.position.x = p2_Bowl.global_position.x
	
	match p2_State:
		States.BOWL:
			p2.position.y = p2_Bowl.global_position.y
		States.JUMP:
			p2_Velocity.y -= GRAVITY * delta
			
			if p2_Velocity.y < MIN_SPEED:
				p2_Velocity.y = MIN_SPEED
			
			p2.position.y -= p2_Velocity.y * delta
			
			if p2_Velocity.y <= MIN_SPEED && p2_Height_Reached == -1:
				p2_Height_Reached = p2.position.y
		States.FAST_FALL:
			p2_Velocity.y -= GRAVITY_BOOST * GRAVITY * delta
			
			if p2_Velocity.y < MIN_SPEED * GRAVITY_BOOST:
				p2_Velocity.y = MIN_SPEED * GRAVITY_BOOST
			
			p2.position.y -= p2_Velocity.y * delta

func Bowl_Check():
	Bowl_Reset()
	
	if p1.position.y > p1_Bowl.global_position.y && p1_State != States.BOWL:
		p1.position.y = p1_Bowl.global_position.y
		p1_State = States.BOWL
		
		#bowl_Left_Force = Calculate_Force(p1_Height_Reached)
		
		Calculate_Score(p1_Height_Reached)
		p1_Height_Reached = -1
	
	if p2.position.y > p2_Bowl.global_position.y && p2_State != States.BOWL:
		p2.position.y = p2_Bowl.global_position.y
		p2_State = States.BOWL
		
		#bowl_Right_Force = Calculate_Force(p2_Height_Reached)
		
		Calculate_Score(p2_Height_Reached)
		p2_Height_Reached = -1

func Calculate_Force(height_Reached):
		var final_Force = MAX_FORCE * remap(height_Reached, MIN_POINTS_HEIGHT, MAX_POINTS_HEIGHT, MIN_FORCE, MAX_FORCE)
		
		clamp(final_Force, MIN_FORCE, MAX_FORCE)
		
		return final_Force

func Bowl_Rotation(delta):
	var bowl_Rotation_Velocity = bowl_Right_Force - bowl_Left_Force
	
	bowl.rotation_degrees += bowl_Rotation_Velocity * bowl_Tilt_Speed * delta
	
	if (bowl.rotation_degrees >= 30):
		bowl_Right_Force = 0
		bowl.rotation_degrees = 30
	if (bowl.rotation_degrees <= -30):
		bowl_Left_Force = 0
		bowl.rotation_degrees = -30
	
	if bowl_Left_Force > MIN_FORCE:
		bowl_Left_Force -= FORCE_DEC_RATE * delta
	else:
		bowl_Left_Force = MIN_FORCE
	
	if bowl_Right_Force > MIN_FORCE:
		bowl_Right_Force -= FORCE_DEC_RATE * delta
	else:
		bowl_Right_Force = MIN_FORCE

func Bowl_Reset():
	if !is_Able_To_Jump:
		return
	
	p1.modulate = Color(1, 1, 1, 1)
	p2.modulate = Color(1, 1, 1, 1)
	
	if bowl.rotation_degrees == 0:
		return
	
	if p1_State != States.BOWL || p2_State != States.BOWL:
		return
	
	is_Able_To_Jump = false
	
	bowl_Left_Force = 0
	bowl_Right_Force = 0
	
	p1.modulate = Color(0.2, 0.2, 0.2, 1)
	p2.modulate = Color(0.2, 0.2, 0.2, 1)
	
	var bowl_Tween = create_tween()
	bowl_Tween.tween_property(bowl, "rotation_degrees", 0, 1.5).finished.connect(set.bind("is_Able_To_Jump", true))

func Calculate_Score(height):
	# TODO: Update this to calculate score based on how fast they got to the top (through how far down the bowl has gone) + how accurate they were too the 
	var score = remap(height, MAX_POINTS_HEIGHT, MIN_POINTS_HEIGHT, MIN_POINTS_EARNED, MAX_POINTS_EARNED)
	score *= 100
	score = round(score)
	score /= 100
	
	clamp(score, MIN_POINTS_EARNED, MAX_POINTS_EARNED)
	
	Update_Mix_Bar(score)
	
	current_Score = mix_Bar.value
	
	score_Text.text = ("[right]Score " + str(current_Score) + "%[/right]   ")

func Update_Mix_Bar(score):
	mix_Bar.value += score

func Game_Finished_Check():
	if current_Score >= mix_Bar.max_value:
		End_Minigame()

