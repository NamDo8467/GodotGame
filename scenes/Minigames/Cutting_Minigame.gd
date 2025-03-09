extends Node2D

@onready var knife = $Knife
@onready var p1 = $Player_1
@onready var p2 = $Player_2

var BASE_POSITION = Vector2(40,300)

var player_Speed = 1 


# Knife Cutting Variables
var isCutting = false
var original_Knife_Scale
var knife_Shrink_Percent = 0.95
var knife_Shirnk_Time = 0.6 # Total Time /2 for going down then back up

# Cutting Line Variables
var Cutting_Line_Sprite = preload("res://scenes/Minigames/Cutting_Minigame/Cutting_Line.tscn")

var MIN_CUTTING_ZONE = 160 # Arbitrary
var MAX_CUTTING_ZONE = 610 # Arbitrary
var BASE_CUTTING_ZONE = 450

# Called when the node enters the scene tree for the first time.
func _ready():
	Create_CutLines()
	
	knife.position = BASE_POSITION
	p1.position = Vector2(BASE_POSITION.x, 64)
	p2.position = Vector2(BASE_POSITION.x, 536)
	
	original_Knife_Scale = knife.scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Can_Move()):
		Move_P1()
		Move_P2()
		Move_Knife()
	#print("P1 Position: " + str(p1.position))
	#print("P2 Position: " + str(p2.position))
	#print("Knife Rotation: " + str(knife.rotation))
	
	Cut_Knife()

func Can_Move():
	if isCutting: return false
	if isCutting: return false
	return true

func Move_P1():
	if Input.is_action_pressed("P1_Minigame_Move_Right") && knife.rotation < 0.3:
		p1.position.x += player_Speed
	if Input.is_action_pressed("P1_Minigame_Move_Left") && knife.rotation > -0.3:
		p1.position.x -= player_Speed

func Move_P2():
	if Input.is_action_pressed("P2_Minigame_Move_Right") && knife.rotation > -0.3:
		p2.position.x += player_Speed
	if Input.is_action_pressed("P2_Minigame_Move_Left") && knife.rotation < 0.3:
		p2.position.x -= player_Speed

func Move_Knife():
	knife.position.x = (p1.position.x + p2.position.x) / 2 # position of centre of knife equal to half the distance between them
	
	var Hypotenuse = p1.position.distance_to(knife.position)
	var Adjacent = (p1.position.x - p2.position.x) / 2
	knife.rotation = PI/2 - acos(Adjacent / Hypotenuse)
	
	if (knife.rotation > 0.3):
		knife.rotation = 0.3
	
	if (knife.rotation < -0.3):
		knife.rotation = -0.3

func Cut_Knife():
	if Input.is_action_pressed("P1_Minigame_Action_1") && !isCutting:
		var tween = get_tree().create_tween()
		
		isCutting = true
		
		tween.tween_property(knife, "scale", original_Knife_Scale * knife_Shrink_Percent, knife_Shirnk_Time/2)
		tween.tween_property(knife, "scale", original_Knife_Scale, knife_Shirnk_Time/2).finished.connect(set.bind("isCutting", false))


func Create_CutLines():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num_CutLines = rng.randi_range(5, 6)
	var cutting_Zone_length = BASE_CUTTING_ZONE / num_CutLines
	
	var tmp_X_Position = MIN_CUTTING_ZONE
	var tmp_Angle = 0
	
	for zone in num_CutLines:
		rng.randomize()
		tmp_X_Position = MIN_CUTTING_ZONE + cutting_Zone_length * zone
		tmp_X_Position += rng.randi_range(0, cutting_Zone_length)
		
		rng.randomize()
		tmp_Angle = rng.randf_range(-0.3, 0.3)
		
		var instance = Cutting_Line_Sprite.instantiate()
		
		instance.position.x = tmp_X_Position
		instance.rotation = tmp_Angle
		
		add_child(instance)
