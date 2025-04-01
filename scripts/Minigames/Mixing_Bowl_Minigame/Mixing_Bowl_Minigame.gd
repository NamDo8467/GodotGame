extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"

@onready var mix_Bar = $CanvasLayer/Mix_Bar
@onready var bowl = $Bowl
@onready var p1_Bowl = $Bowl/Bowl_P1
@onready var p1_Ladder = $Ladder_P1
@onready var p2_Bowl = $Bowl/Bowl_P2
@onready var p2_Ladder = $Ladder_P2

var rng = RandomNumberGenerator.new()

# Player Variables
enum States {WALKING, CLIMBING, JUMPING, FALLING, STUMBLE}

var MIN_SPEED = -250.0
var JUMP_VELOCITY = 500.0
var GRAVITY = 350.0
var FALL_BOOST = -360.0
var GRAVITY_BOOST = 5.0
var BASE_CLIMB_SPEED = 45.0
var MASH_CLIMB_SPEED = 10.0

var climbing_top_Y_Pos
var climbing_bottom_Y_Pos
var climbing_X_Pos

# Player 1 Variables
var p1_Velocity = Vector2.ZERO
var p1_State
var is_P1_Ready_To_Jump = false
# Player 2 Variables
var p2_Velocity = Vector2.ZERO
var p2_State
var is_P2_Ready_To_Jump = false

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
	
	climbing_top_Y_Pos = p1_Ladder.get_child(1).global_position.y
	climbing_bottom_Y_Pos = p1_Ladder.get_child(0).global_position.y
	climbing_X_Pos = p1_Ladder.get_child(0).global_position.y
	
	rng.randomize()
	match rng.randi_range(0, 1):
			0:
				p1_State = States.JUMPING
				p2_State = States.CLIMBING
			1:
				p1_State = States.CLIMBING
				p2_State = States.JUMPING
	
	Update_P1_Game_State()
	Update_P2_Game_State()
	
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_Game_Started:
		return
	
	P1_Actions()
	P2_Actions()
	
	Move_P1(delta)
	Move_P2(delta)
	
	Bowl_Check()
	Bowl_Rotation(delta)
	
	super(delta)

func Update_P1_Game_State():
	match p1_State:
		States.WALKING:
			pass
		States.CLIMBING:
			p1.position = Vector2(climbing_X_Pos, climbing_bottom_Y_Pos)
			pass
		States.JUMPING:
			# TODO: Setup animation that sets is_P1_Ready_To_Jump to true at the end
			
			p1_Ladder.get_script().Start_Cursor()
			pass
		States.FALLING:
			pass
		States.STUMBLE:
			pass

func Update_P2_Game_State():
	pass

func P1_Actions():
	if Input.is_action_just_pressed("P1_Minigame_Action_1") && p1_State == States.CLIMBING:
		p1.position.y -= MASH_CLIMB_SPEED
		
		if p1.position.y <= climbing_top_Y_Pos:
			p1.position.y = climbing_top_Y_Pos
			
			p1_State = States.JUMPING
			Update_P1_Game_State()
	
	if Input.is_action_just_pressed("P1_Minigame_Action_2") && is_P1_Ready_To_Jump:
		Calculate_Score(p1_Ladder.get_script().Stop_Cursor())
	

func P2_Actions():
	if Input.is_action_just_pressed("P2_Minigame_Action_1") && p2_State == States.CLIMBING:
		pass
	if Input.is_action_just_pressed("P2_Minigame_Action_2") && is_P2_Ready_To_Jump:
		pass

func Move_P1(delta):
	
	match p1_State:
		States.WALKING:
			pass
		States.CLIMBING:
			p1.position.y -= BASE_CLIMB_SPEED * delta
		States.JUMPING:
			p1_Velocity.y -= GRAVITY * delta
			
			if p1_Velocity.y < MIN_SPEED:
				p1_Velocity.y = MIN_SPEED
			
			p1.position.y -= p1_Velocity.y * delta
			
		States.FALLING:
			p1_Velocity.y -= GRAVITY_BOOST * GRAVITY * delta
			
			if p1_Velocity.y < MIN_SPEED * GRAVITY_BOOST:
				p1_Velocity.y = MIN_SPEED * GRAVITY_BOOST
			
			p1.position.y -= p1_Velocity.y * delta
		States.STUMBLE:
			pass

func Move_P2(delta):
	pass

func Bowl_Check():
	Bowl_Reset()
	#
	#if p1.position.y > p1_Bowl.global_position.y && p1_State != States.BOWL:
		#p1.position.y = p1_Bowl.global_position.y
		#p1_State = States.BOWL
		#
		##bowl_Left_Force = Calculate_Force(p1_Height_Reached)
		#
		#Calculate_Score(p1_Height_Reached)
		#p1_Height_Reached = -1
	#
	#if p2.position.y > p2_Bowl.global_position.y && p2_State != States.BOWL:
		#p2.position.y = p2_Bowl.global_position.y
		#p2_State = States.BOWL
		#
		##bowl_Right_Force = Calculate_Force(p2_Height_Reached)
		#
		#Calculate_Score(p2_Height_Reached)
		#p2_Height_Reached = -1
#
#func Calculate_Force(height_Reached):
		#var final_Force = MAX_FORCE * remap(height_Reached, MIN_POINTS_HEIGHT, MAX_POINTS_HEIGHT, MIN_FORCE, MAX_FORCE)
		#
		#clamp(final_Force, MIN_FORCE, MAX_FORCE)
		#
		#return final_Force

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
	#p1.modulate = Color(1, 1, 1, 1)
	#p2.modulate = Color(1, 1, 1, 1)
	#
	#if bowl.rotation_degrees == 0:
		#return
	#
	#if p1_State != States.BOWL || p2_State != States.BOWL:
		#return
	#
	#is_Able_To_Jump = false
	#
	#bowl_Left_Force = 0
	#bowl_Right_Force = 0
	#
	#p1.modulate = Color(0.2, 0.2, 0.2, 1)
	#p2.modulate = Color(0.2, 0.2, 0.2, 1)
	#
	#var bowl_Tween = create_tween()
	#bowl_Tween.tween_property(bowl, "rotation_degrees", 0, 1.5).finished.connect(set.bind("is_Able_To_Jump", true))
	pass

func Calculate_Score(score):
	# TODO: Update this to calculate score based on how fast they got to the top (through how far down the bowl has gone) + how accurate they were too the 
	Update_Mix_Bar(score)
	
	current_Score = mix_Bar.value
	
	score_Text.text = ("[right]Score " + str(current_Score) + "%[/right]   ")

func Update_Mix_Bar(score):
	mix_Bar.value += score

func Game_Finished_Check():
	if current_Score >= mix_Bar.max_value:
		End_Minigame()
