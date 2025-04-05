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
enum States { WALKING_BOTTOM, CLIMBING, WALKING_TOP, JUMPING, FALLING, BOWL, STUMBLE }

var MIN_SPEED = -250.0
var JUMP_VELOCITY = 400.0
var GRAVITY = 350.0
var FALL_BOOST = -360.0
var GRAVITY_BOOST = 5.0
var BASE_CLIMB_SPEED = 45.0
var MIN_CLIMB_SPEED_MULTI = 0.1
var MAX_CLIMB_SPEED_MULTI = 5.0
var MASH_CLIMB_SPEED = 0.3
var MASH_CLIMB_SPEED_LOSS = 0.1
var CLIMB_SPEED_MULTI_STARTING = 1
var WALK_SPEED = 60.0
var MAX_WALK_SPEED_MULTI = 3.0

var climbing_Top_Y_Pos
var climbing_Bottom_Y_Pos

# Player 1 Variables
var p1_Velocity = Vector2.ZERO
var p1_State
var p1_walk_Speed_Multi = 1.0
var p1_Climbing_X_Pos
var p1_Climb_Speed_Multi = 0.5
# Player 2 Variables
var p2_Velocity = Vector2.ZERO
var p2_State
var p2_walk_Speed_Multi = 1.0
var p2_Climbing_X_Pos
var p2_Climb_Speed_Multi = 0.5

# Bowl Variables
var MAX_BOWL_ANGLE = 30.0
var bowl_Current_Rotation = 0.0
var p2_Bowl_Force = 0.0
var p1_Bowl_Force = 0.0
var MIN_FORCE = 0.0
var MAX_FORCE = 1.0
var BOWL_RETURN_MULTI = 0.2
var FORCE_DEC_RATE = 1.0
var bowl_Tilt_Speed = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 20.0 # Change this to adjust timers
	
	climbing_Top_Y_Pos = p1_Ladder.get_child(1).global_position.y
	climbing_Bottom_Y_Pos = p1_Ladder.get_child(0).global_position.y
	
	p1_Climbing_X_Pos = p1_Ladder.get_child(0).global_position.x
	p2_Climbing_X_Pos = p2_Ladder.get_child(0).global_position.x
	
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
	
	if bg_Music.playing == false:
		bg_Music.play()
	
	P1_Actions()
	P2_Actions()
	
	Move_P1(delta)
	Move_P2(delta)
	
	Bowl_Rotation(delta)
	
	super(delta)

func P1_Actions():
	if Input.is_action_just_pressed("P1_Minigame_Action_1") && p1_State == States.CLIMBING:
		p1_Climb_Speed_Multi += MASH_CLIMB_SPEED
	
	if Input.is_action_just_pressed("P1_Minigame_Action_2") && p1_State == States.WALKING_TOP:
		p1_walk_Speed_Multi = MAX_WALK_SPEED_MULTI
		p1_Ladder.Stop_Cursor()

func P2_Actions():
	if Input.is_action_just_pressed("P2_Minigame_Action_1") && p2_State == States.CLIMBING:
		p2_Climb_Speed_Multi += MASH_CLIMB_SPEED
	if Input.is_action_just_pressed("P2_Minigame_Action_2") && p2_State == States.WALKING_TOP:
		p2_walk_Speed_Multi = MAX_WALK_SPEED_MULTI
		p2_Ladder.Stop_Cursor()

func Update_P1_Game_State():
	match p1_State:
		States.WALKING_BOTTOM:
			# TODO: Setup animation that starts walking
			#p1.position = p1_Bowl.global_position
			p1_walk_Speed_Multi = 1.0
			print("Walking Bottom")
			pass
		States.CLIMBING:
			# TODO: Setup animation that starts climbing
			p1.position = Vector2(p1_Climbing_X_Pos, climbing_Bottom_Y_Pos)
			p1_Climb_Speed_Multi = CLIMB_SPEED_MULTI_STARTING
			print("Climbing")
			pass
		States.WALKING_TOP:
			# TODO: Setup animation that starts walking
			p1.position = Vector2(p1_Climbing_X_Pos, climbing_Top_Y_Pos)
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
		States.BOWL:
			# TODO: Setup animation that starts Bowl (Just turn the rat around or not and do it in walk bottom anim)
			p1_Bowl_Force = MAX_FORCE
			print("Falling")
		States.STUMBLE:
			# TODO: Setup animation that starts Stumble
			print("Stumble")
			pass

func Update_P2_Game_State():
	match p2_State:
		States.WALKING_BOTTOM:
			# TODO: Setup animation that starts walking
			#p2.position = p2_Bowl.global_position
			p2_walk_Speed_Multi = 1.0
			print("Walking Bottom")
			pass
		States.CLIMBING:
			# TODO: Setup animation that starts climbing
			p2.position = Vector2(p2_Climbing_X_Pos, climbing_Bottom_Y_Pos)
			p2_Climb_Speed_Multi = CLIMB_SPEED_MULTI_STARTING
			print("Climbing")
			pass
		States.WALKING_TOP:
			# TODO: Setup animation that starts walking
			p2.position = Vector2(p2_Climbing_X_Pos, climbing_Top_Y_Pos)
			p2_Ladder.Start_Cursor()
			print("Walking Top")
			pass
		States.JUMPING:
			# TODO: Setup animation that starts Jumping
			#p2.position = p2_Ladder.jumping_Point.global_position
			p2_Velocity.y = JUMP_VELOCITY
			print("Jumping")
			pass
		States.FALLING:
			# TODO: Setup animation that starts Falling
			print("Falling")
			pass
		States.BOWL:
			# TODO: Setup animation that starts Bowl (Just turn the rat around or not and do it in walk bottom anim)
			p2_Bowl_Force = MAX_FORCE
			print("Falling")
		States.STUMBLE:
			# TODO: Setup animation that starts Stumble
			print("Stumble")
			pass


func Move_P1(delta):
	match p1_State:
		States.WALKING_BOTTOM:
			if p1.position.x >= p1_Climbing_X_Pos:
				p1.position.x -= WALK_SPEED * p1_walk_Speed_Multi * 3 * delta
			
			if p1.position.y <= climbing_Bottom_Y_Pos:
				p1.position.y += WALK_SPEED * p1_walk_Speed_Multi * 3 * delta
			
			if p1.position.x <= p1_Climbing_X_Pos && p1.position.y >= climbing_Bottom_Y_Pos:
				p1_Climb_Speed_Multi = MIN_CLIMB_SPEED_MULTI
				p1_State = States.CLIMBING
				Update_P1_Game_State()
		States.CLIMBING:
			p1.position.y -= BASE_CLIMB_SPEED * p1_Climb_Speed_Multi * delta
			
			p1_Climb_Speed_Multi -= MASH_CLIMB_SPEED_LOSS * delta
			p1_Climb_Speed_Multi = clamp(p1_Climb_Speed_Multi, MIN_CLIMB_SPEED_MULTI, MAX_CLIMB_SPEED_MULTI)
			
			if p1.position.y <= climbing_Top_Y_Pos:
				p1_State = States.WALKING_TOP
				Update_P1_Game_State()
		States.WALKING_TOP:
			p1.position.x += WALK_SPEED * p1_walk_Speed_Multi * delta
			
			if p1.position.x > p1_Ladder.jumping_Point.global_position.x:
				p1_State = States.JUMPING
				Update_P1_Game_State()
		States.JUMPING:
			p1_Velocity.y -= GRAVITY * delta
			p1_Velocity.y = max(p1_Velocity.y, MIN_SPEED)
			p1.position.y -= p1_Velocity.y * delta
			
			if p1.position.x < p1_Bowl.global_position.x:
				p1.position.x += WALK_SPEED * p1_walk_Speed_Multi * delta
			else:
				p1_State = States.FALLING
				Update_P1_Game_State()
		States.FALLING:
			p1.position.x = p1_Bowl.global_position.x
			
			p1_Velocity.y -= GRAVITY_BOOST * GRAVITY * delta
			p1.position.y -= p1_Velocity.y * delta
			
			if p1.position.y > p1_Bowl.global_position.y:
				p1_State = States.BOWL
				Calculate_Score(p1_Ladder)
				Update_P1_Game_State()
		States.BOWL:
			p1.position = p1_Bowl.global_position
			if bowl.rotation_degrees <= -MAX_BOWL_ANGLE:
				p1_State = States.WALKING_BOTTOM
				Update_P1_Game_State()
		States.STUMBLE:
			pass

func Move_P2(delta):
	match p2_State:
		States.WALKING_BOTTOM:
			if p2.position.x <= p2_Climbing_X_Pos:
				p2.position.x += WALK_SPEED * p2_walk_Speed_Multi * 3 * delta
			
			if p2.position.y <= climbing_Bottom_Y_Pos:
				p2.position.y += WALK_SPEED * p2_walk_Speed_Multi * 3 * delta
			
			if p2.position.x >= p2_Climbing_X_Pos && p2.position.y >= climbing_Bottom_Y_Pos:
				p2_Climb_Speed_Multi = MIN_CLIMB_SPEED_MULTI
				p2_State = States.CLIMBING
				Update_P2_Game_State()
		States.CLIMBING:
			p2.position.y -= BASE_CLIMB_SPEED * p2_Climb_Speed_Multi * delta
			
			p2_Climb_Speed_Multi -= MASH_CLIMB_SPEED_LOSS * delta
			p2_Climb_Speed_Multi = clamp(p2_Climb_Speed_Multi, MIN_CLIMB_SPEED_MULTI, MAX_CLIMB_SPEED_MULTI)
			
			if p2.position.y <= climbing_Top_Y_Pos:
				p2_State = States.WALKING_TOP
				Update_P2_Game_State()
		States.WALKING_TOP:
			p2.position.x -= WALK_SPEED * p2_walk_Speed_Multi * delta
			
			if p2.position.x < p2_Ladder.jumping_Point.global_position.x:
				p2_State = States.JUMPING
				Update_P2_Game_State()
		States.JUMPING:
			p2_Velocity.y -= GRAVITY * delta
			p2_Velocity.y = max(p2_Velocity.y, MIN_SPEED)
			p2.position.y -= p2_Velocity.y * delta
			
			if p2.position.x > p2_Bowl.global_position.x:
				p2.position.x -= WALK_SPEED * p2_walk_Speed_Multi * delta
			else:
				p2_State = States.FALLING
				Update_P2_Game_State()
		States.FALLING:
			p2.position.x = p2_Bowl.global_position.x
			
			p2_Velocity.y -= GRAVITY_BOOST * GRAVITY * delta
			p2.position.y -= p2_Velocity.y * delta
			
			if p2.position.y > p2_Bowl.global_position.y:
				p2_State = States.BOWL
				Calculate_Score(p2_Ladder)
				Update_P2_Game_State()
		States.BOWL:
			p2.position = p2_Bowl.global_position
			if bowl.rotation_degrees >= MAX_BOWL_ANGLE:
				p2_State = States.WALKING_BOTTOM
				Update_P2_Game_State()
		States.STUMBLE:
			pass

func Bowl_Rotation(delta):
	if p1_Bowl_Force == MIN_FORCE && p2_Bowl_Force == MIN_FORCE:
		if bowl.rotation_degrees < 0:
			bowl.rotation_degrees += bowl_Tilt_Speed * BOWL_RETURN_MULTI * delta
			bowl.rotation_degrees = min(bowl.rotation_degrees, 0)
		elif bowl.rotation_degrees > 0:
			bowl.rotation_degrees -= bowl_Tilt_Speed * BOWL_RETURN_MULTI * delta
			bowl.rotation_degrees = max(bowl.rotation_degrees, 0)
	
	var bowl_Rotation_Velocity =  p2_Bowl_Force - p1_Bowl_Force
	
	bowl.rotation_degrees += bowl_Rotation_Velocity * bowl_Tilt_Speed * delta
	
	if (bowl.rotation_degrees <= -30):
		p1_Bowl_Force = 0
		bowl.rotation_degrees = -30
	if (bowl.rotation_degrees >= 30):
		p2_Bowl_Force = 0
		bowl.rotation_degrees = 30
	
	if p1_Bowl_Force > MIN_FORCE:
		p1_Bowl_Force -= FORCE_DEC_RATE * delta
	else:
		p1_Bowl_Force = MIN_FORCE
	
	if p2_Bowl_Force > MIN_FORCE:
		p2_Bowl_Force -= FORCE_DEC_RATE * delta
	else:
		p2_Bowl_Force = MIN_FORCE

func Calculate_Score(ladder):
	# TODO: Update this to calculate score based on how fast they got to the top (through how far down the bowl has gone) + how accurate they were too the 
	var score = 0
	
	match ladder.Calculate_Grade():
		ladder.Grade.BAD:
			score = BAD_POINTS
		ladder.Grade.GOOD:
			score = GOOD_POINTS
		ladder.Grade.GREAT:
			score = GREAT_POINTS
		ladder.Grade.PERFECT:
			score = PERFECT_POINTS
	
	Update_Mix_Bar(score)
	
	current_Score = mix_Bar.value
	
	score_Text.text = ("[right]Score " + str(current_Score) + "%[/right]   ")

func Update_Mix_Bar(score):
	mix_Bar.value += score

func Game_Finished_Check():
	if current_Score >= mix_Bar.max_value:
		End_Minigame()
