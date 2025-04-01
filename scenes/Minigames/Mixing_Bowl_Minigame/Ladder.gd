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
var min_Score_Range
var max_Score_Range
var score_Buffer

# Cursor Variables
var min_Cursor_Range
var max_Cursor_Range
var MIN_CURSOR_SPEED = 50
var MAX_CURSOR_SPEED = 90
var cursor_speed = 50
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#jumping_Point.modulate = OFF
	
	var bar_size = 100
	score_Buffer = (bar_size * range_Good.scale.x)
	
	min_Cursor_Range = bar_size / -2
	max_Cursor_Range = bar_size / 2
	
	min_Score_Range = 0
	max_Score_Range = bar_size - score_Buffer
	
	Start_Cursor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cursor.position.x = clamp((cursor.position.x + cursor_speed * direction * delta) , min_Cursor_Range, max_Cursor_Range)
	
	if cursor.position.x <= min_Cursor_Range || cursor.position.x >= max_Cursor_Range:
		direction *= -1
	
	pass

func Start_Cursor():
	rng.randomize()
	cursor.position.x = rng.randi_range(min_Cursor_Range, max_Cursor_Range)
	print("cursor.position.x: " + str(cursor.position.x))
	cursor_speed = rng.randi_range(MIN_CURSOR_SPEED, MAX_CURSOR_SPEED)
	
	rng.randomize()
	range_Good.position.x = min_Score_Range#rng.randi_range(min_Score_Range, max_Score_Range)
	
	
	jumping_Point.modulate = ON

func Stop_Cursor() -> int:
	rng.randomize()
	cursor_speed = rng.randi_range(MIN_CURSOR_SPEED, MAX_CURSOR_SPEED)
	
	jumping_Point.visible()
	
	return 0

func Fade_Out():
	var tween = get_tree().create_tween()
	tween.tween_property(jumping_Point, "modulate", OFF, 3.0)

func Send_Score():
	pass
