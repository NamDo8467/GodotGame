extends Sprite2D

@onready var jumping_Point = $Jumping_Point
@onready var timing_Bar = $Jumping_Point/Timing_Bar
@onready var cursor = $Jumping_Point/Timing_Bar/Cursor
@onready var range_Good = $Jumping_Point/Timing_Bar/Background/Range_Good
@onready var range_Great = $Jumping_Point/Timing_Bar/Background/Range_Good/Range_Great
@onready var range_Perfect = $Jumping_Point/Timing_Bar/Background/Range_Good/Range_Great/Range_Perfect

var rng = RandomNumberGenerator.new()

# Constants
var ON = Color(1, 1, 1, 1)
var OFF = Color(1, 1, 1, 0)

# Score Variables
enum Grade { BAD, GOOD, GREAT, PERFECT }

var min_Score_Range
var max_Score_Range
var score_Buffer
var score_Range_Center
var good_Score_Range
var great_Score_Range
var perfect_Score_Range

# Cursor Variables
var min_Cursor_Range
var max_Cursor_Range
var MIN_CURSOR_SPEED = 50
var MAX_CURSOR_SPEED = 90
var cursor_speed = 50
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	jumping_Point.modulate = OFF
	
	var bar_size = 100
	score_Buffer = (bar_size * range_Good.scale.x)
	
	min_Cursor_Range = bar_size / -2.0
	max_Cursor_Range = bar_size / 2.0
	
	min_Score_Range = 0
	max_Score_Range = bar_size - score_Buffer
	
	good_Score_Range = score_Buffer / 2.0
	great_Score_Range = good_Score_Range * range_Great.scale.x
	perfect_Score_Range = great_Score_Range * range_Perfect.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if jumping_Point.modulate == OFF:
		return
	
	cursor.position.x = clamp((cursor.position.x + cursor_speed * direction * delta) , min_Cursor_Range, max_Cursor_Range)
	
	if cursor.position.x <= min_Cursor_Range || cursor.position.x >= max_Cursor_Range:
		direction *= -1
	
	# Testing Call
	#if Input.is_action_just_pressed("P1_Minigame_Action_1"):
		#Stop_Cursor()

func Start_Cursor():
	rng.randomize()
	cursor.position.x = rng.randi_range(min_Cursor_Range, max_Cursor_Range)
	cursor_speed = rng.randi_range(MIN_CURSOR_SPEED, MAX_CURSOR_SPEED)
	
	rng.randomize()
	range_Good.position.x = rng.randi_range(min_Score_Range, max_Score_Range)
	score_Range_Center = range_Good.position.x + good_Score_Range - max_Cursor_Range
	
	jumping_Point.modulate = ON

func Stop_Cursor():
	cursor_speed = 0
	Fade_Out()

func Fade_Out():
	var tween = get_tree().create_tween()
	tween.tween_property(jumping_Point, "modulate", OFF, 2.0)

func Calculate_Grade() -> Grade:
	Stop_Cursor()
	
	var cursor_x_pos = cursor.position.x
	
	if cursor_x_pos >= score_Range_Center - perfect_Score_Range && cursor_x_pos <= score_Range_Center + perfect_Score_Range:
		return Grade.PERFECT
	if cursor_x_pos >= score_Range_Center - great_Score_Range && cursor_x_pos <= score_Range_Center + great_Score_Range:
		return Grade.GREAT
	if cursor_x_pos >= score_Range_Center - good_Score_Range && cursor_x_pos <= score_Range_Center + good_Score_Range:
		return Grade.GOOD
	
	return Grade.BAD
