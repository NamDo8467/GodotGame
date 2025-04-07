extends "res://scripts/Minigames/Base_Minigame/Base_Minigame.gd"

# Sound Variables
@onready var cutting_Sound = $CanvasLayer/Sound/Sound_Effects/Cutting_Sound
@onready var p1_Walking_Sounds = $CanvasLayer/Sound/Sound_Effects/Walking_Sounds/P1
@onready var p2_Walking_Sounds = $CanvasLayer/Sound/Sound_Effects/Walking_Sounds/P2

@onready var knife = $Knife

var BASE_POSITION = Vector2(50,448.5)


# Player Variables
var is_P1_Action1 = 0.0 # 0 is false
var is_P2_Action1 = 0.0 # 0 is false
var SYNC_PRESS_TIME = 1.0
var player_Speed = 450

# Knife Cutting Variables
var is_Cutting = false
var original_Knife_Scale : Vector2
var knife_Shrink_Percent = 0.95
var knife_Shirnk_Time = 0.6 # Total Time /2 for going down then back up
var cut_Scores = []
var MAX_KNIFE_ROTATION = 0.3
var DISTANCE_THRESHOLD = 40
var DISTANCE_CUTOFF = 5
var ANGLE_THRESHOLD = 0.2
var ANGLE_CUTOFF = 0.05

# Cutting Line Variables
var Cutting_Line_Sprite = preload("res://scenes/Minigames/Cutting_Minigame/Cutting_Line.tscn")
var Cut_Line_Nodes = Array()
var MIN_CUTTING_ZONE = 250.0 # Arbitrary
var MAX_CUTTING_ZONE = 1030.0 # Arbitrary
var BASE_CUTTING_ZONE = MAX_CUTTING_ZONE - MIN_CUTTING_ZONE

# Called when the node enters the scene tree for the first time.
func _ready():
	minigame_Time = 15.0 # Change this to adjust timers
	
	Start_Countdown()
	
	Rotate_P1()
	Rotate_P2()
	original_Knife_Scale = knife.scale
	
	await get_tree().create_timer(3).timeout
	
	Create_CutLines()

func Create_CutLines():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num_CutLines = rng.randi_range(5, 6)
	var cutting_Zone_length = BASE_CUTTING_ZONE / num_CutLines
	
	var tmp_X_Position = MIN_CUTTING_ZONE
	var tmp_Angle = 0
	
	for zone in num_CutLines:
		cut_Scores.append(-1)
		
		rng.randomize()
		tmp_X_Position = MIN_CUTTING_ZONE + cutting_Zone_length * zone
		tmp_X_Position += rng.randi_range(0, cutting_Zone_length)
		
		rng.randomize()
		tmp_Angle = rng.randf_range(-0.3, 0.3)
		
		var instance = Cutting_Line_Sprite.instantiate()
		
		instance.position.x = tmp_X_Position
		instance.rotation = tmp_Angle
		
		Cut_Line_Nodes.append(instance)
		add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_Game_Started:
		return
	
	if Can_Move():
		Move_P1(delta)
		Move_P2(delta)
	
	Move_Knife()
	
	if Can_Cut(delta):
		Cut_Knife()
	
	Game_Finished_Check()
	Update_Timmer(delta)

func Can_Move():
	if is_Cutting: return false

	return true

func Move_P1(delta):
	if Input.is_action_pressed("P1_Minigame_Move_Right") && knife.rotation < MAX_KNIFE_ROTATION:
		p1.position.x += player_Speed * delta
		p1.flip_h = false
		p1.play("Top_Down_P1_Walking")
		Rotate_P1()
		return
	if Input.is_action_pressed("P1_Minigame_Move_Left") && knife.rotation > -MAX_KNIFE_ROTATION:
		p1.position.x -= player_Speed * delta
		p1.flip_h = true
		p1.play("Top_Down_P1_Walking")
		Rotate_P1()
		return
	
	Rotate_P1()
	p1.play("Top_Down_P1_A_Default")

func Move_P2(delta):
	if Input.is_action_pressed("P2_Minigame_Move_Right") && knife.rotation > -MAX_KNIFE_ROTATION:
		p2.position.x += player_Speed * delta
		p2.flip_h = true
		p2.play("Top_Down_P2_Walking")
		Rotate_P2()
		return
	if Input.is_action_pressed("P2_Minigame_Move_Left") && knife.rotation < MAX_KNIFE_ROTATION:
		p2.position.x -= player_Speed * delta
		p1.flip_h = false
		p2.play("Top_Down_P2_Walking")
		Rotate_P2()
		return
	
	Rotate_P2()
	p2.play("Top_Down_P2_A_Default")

func Rotate_P1():
	p1.look_at(knife.global_position)
	p1.rotation_degrees += 90

func Rotate_P2():
	p2.look_at(knife.global_position)
	p2.rotation_degrees -= 90

func Move_Knife():
	knife.position.x = (p1.position.x + p2.position.x) / 2 # position of centre of knife equal to half the distance between them
	
	var Hypotenuse = p1.position.distance_to(knife.position)
	var Adjacent = (p1.position.x - p2.position.x) / 2
	var Angle = PI/2 - acos(Adjacent / Hypotenuse)
	
	knife.rotation = clamp(Angle, -MAX_KNIFE_ROTATION, MAX_KNIFE_ROTATION)

func Can_Cut(time_delta):
	is_P1_Action1 -= time_delta
	is_P2_Action1 -= time_delta
	
	if is_Cutting:
		return false
	
	if Input.is_action_pressed("P1_Minigame_Action_1") && is_P1_Action1 <= 0:
		is_P1_Action1 = SYNC_PRESS_TIME
	if Input.is_action_pressed("P2_Minigame_Action_1") && is_P2_Action1 <= 0:
		is_P2_Action1 = SYNC_PRESS_TIME
	
	if (is_P1_Action1 <= 0) || (is_P2_Action1 <= 0):
		return false
	
	is_P1_Action1 = 0
	is_P2_Action1 = 0
	
	return true

func Cut_Knife():
	var tween = get_tree().create_tween()
		
	is_Cutting = true
	
	tween.tween_property(knife, "scale", original_Knife_Scale * knife_Shrink_Percent, knife_Shirnk_Time/2)
	tween.tween_property(knife, "scale", original_Knife_Scale, knife_Shirnk_Time/2).finished.connect(set.bind("is_Cutting", false))
	
	
	await get_tree().create_timer(knife_Shirnk_Time/4).timeout
	
	cutting_Sound.play()
	
	await get_tree().create_timer(knife_Shirnk_Time/4).timeout
	
	var distance_Diff = 0
	var angle_Diff = 0
	var index = 0
	
	for line in Cut_Line_Nodes:
		if !Cut_Line_Nodes[index].is_visible_in_tree():
			index += 1
			continue
		
		distance_Diff = abs(knife.position.x - line.position.x)
		angle_Diff = abs(knife.rotation - line.rotation)
		
		if distance_Diff < DISTANCE_THRESHOLD:
			if angle_Diff < ANGLE_THRESHOLD:
				Cut_Line_Nodes[index].hide()
				Calculate_Score(index, distance_Diff, angle_Diff)
				break
			
		index += 1
	
	Game_Finished_Check()

func Calculate_Score(index, distance, angle):
	var distance_Score = 65
	var angle_Score = 65
	
	if distance > DISTANCE_CUTOFF:
		distance_Score -= distance_Score * distance / DISTANCE_THRESHOLD 
	if angle > ANGLE_CUTOFF:
		angle_Score -= angle_Score * angle / ANGLE_THRESHOLD 
	
	cut_Scores[index] = 1
	
	var score_Remapped = remap(distance_Score + angle_Score, 0, 130, 0, 26)
	
	current_Score += clamp(score_Remapped, 0, 20)
	
	current_Score = clamp(current_Score, 0.0, 100.0)

func Game_Finished_Check():
	var index = 0
	
	for score in cut_Scores:
		index += 1
		
		if score < 0:
			return
		
		if index == cut_Scores.size():
			End_Minigame()

func End_Minigame():
	p1.stop()
	p2.stop()
	
	super()
