extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"

@onready var mix_Bar = $CanvasLayer/Mix_Bar
@onready var bowl = $Bowl
@onready var p1_Bowl = $Bowl/Bowl_P1
@onready var p1_Ladder = $Ladder_P1
@onready var p2_Bowl = $Bowl/Bowl_P2
@onready var p2_Ladder = $Ladder_P2

var rng = RandomNumberGenerator.new()

# Game Variables
var BAD_POINTS = -15
var GOOD_POINTS = 15
var GREAT_POINTS = 30
var PERFECT_POINTS = 45

# Player Variables
enum States { WALKING_BOTTOM, CLIMBING, WALKING_TOP, JUMPING, FALLING, STUMBLE }

var MIN_SPEED = -250.0
var JUMP_VELOCITY = 400.0
var GRAVITY = 350.0
var FALL_BOOST = -360.0
var GRAVITY_BOOST = 5.0
var BASE_CLIMB_SPEED = 45.0
var MIN_CLIMB_SPEED_MULTI = 0.1
var MAX_CLIMB_SPEED_MULTI = 5.0
var MASH_CLIMB_SPEED = 0.2
var MASH_CLIMB_SPEED_LOSS = 0.05
var CLIMB_SPEED_MULTI_STARTING = 0.5
var WALK_SPEED = 60.0
var MAX_WALK_SPEED_MULTI = 2.0

var climbing_Top_Y_Pos
var climbing_Bottom_Y_Pos
var climbing_X_Pos

# Player 1 Variables
var p1_Velocity = Vector2.ZERO
var p1_State
var p1_walk_Speed_Multi = 1.0
var p1_climb_speed_multi = 0.5
# Player 2 Variables
var p2_Velocity = Vector2.ZERO
var p2_State
var p2_walk_Speed_Multi = 1.0
var p2_climb_speed_multi = 0.5

# Bowl Variables
var MAX_BOWL_ANGLE = 30.0
var bowl_Current_Rotation = 0.0
var bowl_Left_Force = 0.0
var bowl_Right_Force = 0.0
var MIN_FORCE = 0.0
var MAX_FORCE = 1.0
var FORCE_DEC_RATE = 1.0
var bowl_Tilt_Speed = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 20.0 # Change this to adjust timers
	
	climbing_Top_Y_Pos = p1_Ladder.get_child(1).global_position.y
	climbing_Bottom_Y_Pos = p1_Ladder.get_child(0).global_position.y
	climbing_X_Pos = p1_Ladder.get_child(0).global_position.x
	
	rng.randomize()
	match 0:#rng.randi_range(0, 1):
			0:
				p1_State = States.WALKING_TOP
				p2_State = States.CLIMBING
			1:
				p1_State = States.CLIMBING
				p2_State = States.WALKING_TOP
	
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
	
	#Bowl_Check()
	#Bowl_Rotation(delta)
	
	super(delta)

func P1_Actions():
	if Input.is_action_just_pressed("P1_Minigame_Action_1") && p1_State == States.CLIMBING:
		p1_climb_speed_multi += MASH_CLIMB_SPEED
	
	if Input.is_action_just_pressed("P1_Minigame_Action_2") && p1_State == States.WALKING_TOP:
		p1_walk_Speed_Multi = MAX_WALK_SPEED_MULTI
		p1_Ladder.Stop_Cursor()

func P2_Actions():
	if Input.is_action_just_pressed("P2_Minigame_Action_1") && p2_State == States.CLIMBING:
		p2_climb_speed_multi += MASH_CLIMB_SPEED
	if Input.is_action_just_pressed("P2_Minigame_Action_2") && p2_State == States.WALKING_TOP:
		p2_walk_Speed_Multi = MAX_WALK_SPEED_MULTI
		p2_Ladder.Stop_Cursor()

func Update_P1_Game_State():
	match p1_State:
		States.WALKING_BOTTOM:
			# TODO: Setup animation that starts walking
			p1.position = p1_Bowl.global_position
			p1_walk_Speed_Multi = 1.0
			print("Walking Bottom")
			pass
		States.CLIMBING:
			# TODO: Setup animation that starts climbing
			#p1.position = Vector2(climbing_X_Pos, climbing_Bottom_Y_Pos)
			p1_climb_speed_multi = CLIMB_SPEED_MULTI_STARTING
			print("Climbing")
			pass
		States.WALKING_TOP:
			# TODO: Setup animation that starts walking
			p1.position = Vector2(climbing_X_Pos, climbing_Top_Y_Pos)
			p1_Ladder.Start_Cursor()
			print("Walking Top")
			pass
		States.JUMPING:
			# TODO: Setup animation that starts Jumping
			#p1.position = p1_Ladder.jumping_Point.global_position
			p1_Velocity.y = JUMP_VELOCITY
			print("Jumping")
			pass
		States.FALLING:
			# TODO: Setup animation that starts Falling
			print("Falling")
			pass
		States.STUMBLE:
			# TODO: Setup animation that starts Stumble
			print("Stumble")
			pass

func Update_P2_Game_State():
	pass


func Move_P1(delta):
	match p1_State:
		States.WALKING_BOTTOM:
			if p1.position.x >= climbing_X_Pos:
				p1.position.x -= WALK_SPEED * p1_walk_Speed_Multi * 3 * delta
			
			if p1.position.y <= climbing_Bottom_Y_Pos:
				p1.position.y += WALK_SPEED * p1_walk_Speed_Multi * 3 * delta
			
			if p1.position.x <= climbing_X_Pos && p1.position.y >= climbing_Bottom_Y_Pos:
				p1_climb_speed_multi = MIN_CLIMB_SPEED_MULTI
				p1_State = States.CLIMBING
				Update_P1_Game_State()
		States.CLIMBING:
			p1.position.y -= BASE_CLIMB_SPEED * p1_climb_speed_multi * delta
			
			p1_climb_speed_multi -= MASH_CLIMB_SPEED_LOSS * delta
			p1_climb_speed_multi = clamp(p1_climb_speed_multi, MIN_CLIMB_SPEED_MULTI, MAX_CLIMB_SPEED_MULTI)
			
			if p1.position.y <= climbing_Top_Y_Pos:
				p1_State = States.WALKING_TOP
				Update_P1_Game_State()
		States.WALKING_TOP:
			p1.position.x += WALK_SPEED * p1_walk_Speed_Multi * delta
			
			if p1.position.x > p1_Ladder.jumping_Point.position.x:
				p1_State = States.JUMPING
				Update_P1_Game_State()
		States.JUMPING:
			p1_Velocity.y -= GRAVITY * delta
			p1_Velocity.y = max(p1_Velocity.y, MIN_SPEED)
			p1.position.y -= p1_Velocity.y * delta
			
			print("Velocity Delta: " + str(p1_Velocity.y * delta))
			print("p1.position.x: " + str(p1.position.x))
			if p1.position.x < p1_Bowl.global_position.x:
				p1.position.x += WALK_SPEED * p1_walk_Speed_Multi * delta
				print(p1.position.x)
			else:
				p1_State = States.FALLING
				Update_P1_Game_State()
		States.FALLING:
			p1.position.x = p1_Bowl.global_position.x
			
			p1_Velocity.y -= GRAVITY_BOOST * GRAVITY * delta
			p1.position.y -= p1_Velocity.y * delta
			
			if p1.position.y > p1_Bowl.global_position.y:
				p1_State = States.WALKING_BOTTOM
				Calculate_Score()
				Update_P1_Game_State()
		States.STUMBLE:
			pass

func Move_P2(delta):
	return delta

#func Bowl_Check():
	#Bowl_Reset()
	##
	##if p1.position.y > p1_Bowl.global_position.y && p1_State != States.BOWL:
		##p1.position.y = p1_Bowl.global_position.y
		##p1_State = States.BOWL
		##
		###bowl_Left_Force = Calculate_Force(p1_Height_Reached)
		##
		##Calculate_Score(p1_Height_Reached)
		##p1_Height_Reached = -1
	##
	##if p2.position.y > p2_Bowl.global_position.y && p2_State != States.BOWL:
		##p2.position.y = p2_Bowl.global_position.y
		##p2_State = States.BOWL
		##
		###bowl_Right_Force = Calculate_Force(p2_Height_Reached)
		##
		##Calculate_Score(p2_Height_Reached)
		##p2_Height_Reached = -1
##
##func Calculate_Force(height_Reached):
		##var final_Force = MAX_FORCE * remap(height_Reached, MIN_POINTS_HEIGHT, MAX_POINTS_HEIGHT, MIN_FORCE, MAX_FORCE)
		##
		##clamp(final_Force, MIN_FORCE, MAX_FORCE)
		##
		##return final_Force
#
#func Bowl_Rotation(delta):
	#var bowl_Rotation_Velocity = bowl_Right_Force - bowl_Left_Force
	#
	#bowl.rotation_degrees += bowl_Rotation_Velocity * bowl_Tilt_Speed * delta
	#
	#if (bowl.rotation_degrees >= 30):
		#bowl_Right_Force = 0
		#bowl.rotation_degrees = 30
	#if (bowl.rotation_degrees <= -30):
		#bowl_Left_Force = 0
		#bowl.rotation_degrees = -30
	#
	#if bowl_Left_Force > MIN_FORCE:
		#bowl_Left_Force -= FORCE_DEC_RATE * delta
	#else:
		#bowl_Left_Force = MIN_FORCE
	#
	#if bowl_Right_Force > MIN_FORCE:
		#bowl_Right_Force -= FORCE_DEC_RATE * delta
	#else:
		#bowl_Right_Force = MIN_FORCE
#
#func Bowl_Reset():
	##p1.modulate = Color(1, 1, 1, 1)
	##p2.modulate = Color(1, 1, 1, 1)
	##
	##if bowl.rotation_degrees == 0:
		##return
	##
	##if p1_State != States.BOWL || p2_State != States.BOWL:
		##return
	##
	##is_Able_To_Jump = false
	##
	##bowl_Left_Force = 0
	##bowl_Right_Force = 0
	##
	##p1.modulate = Color(0.2, 0.2, 0.2, 1)
	##p2.modulate = Color(0.2, 0.2, 0.2, 1)
	##
	##var bowl_Tween = create_tween()
	##bowl_Tween.tween_property(bowl, "rotation_degrees", 0, 1.5).finished.connect(set.bind("is_Able_To_Jump", true))
	#pass

func Calculate_Score():
	# TODO: Update this to calculate score based on how fast they got to the top (through how far down the bowl has gone) + how accurate they were too the 
	var score = 0
	
	match p1_Ladder.Calculate_Grade():
		p1_Ladder.Grade.BAD:
			score = BAD_POINTS
		p1_Ladder.Grade.GOOD:
			score = GOOD_POINTS
		p1_Ladder.Grade.GREAT:
			score = GREAT_POINTS
		p1_Ladder.Grade.PERFECT:
			score = PERFECT_POINTS
	
	Update_Mix_Bar(score)
	
	current_Score = mix_Bar.value
	
	score_Text.text = ("[right]Score " + str(current_Score) + "%[/right]   ")

func Update_Mix_Bar(score):
	mix_Bar.value += score

func Game_Finished_Check():
	if current_Score >= mix_Bar.max_value:
		End_Minigame()
