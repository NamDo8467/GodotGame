extends Node2D

signal Minigame_Finished(score)

@onready var start_Timmer = $CanvasLayer/Start_Timmer
@onready var p1_Node = $Player_1
@onready var p1_X_Position = $Bowl/Player_1_X_Position
@onready var p2_Node = $Player_2
@onready var p2_X_Position = $Bowl/Player_2_X_Position

# Timmer Variables
var timmer_Tween : Tween
var is_Game_Started = false
var current_Time = 0.0
var minigame_Time = 15.0
var transition : ColorRect
var tansition_Time = 2.0

var current_Score = 0

var p1_Velocity = Vector2.ZERO
var is_P1_On_Bowl = true
var is_P1_Jumping = false
var is_P1_Fast_Falling = false

var p2_Velocity = Vector2.ZERO
var is_P2_On_Bowl = true
var is_P2_Jumping = false
var is_P2_Fast_Falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	P1_Actions()
	P2_Actions()
	
	Move_P1()
	Move_P2()
	

func P1_Actions():
	if Input.is_action_just_pressed("P1_Minigame_Action_1") && !is_P1_Jumping:
		is_P1_Jumping = true
		p1_Node
	
	if Input.is_action_just_pressed("P1_Minigame_Action_2") && !is_P1_Fast_Falling:
		is_P1_Fast_Falling = true
	

func P2_Actions():
	pass

func Move_P1():
	p1_Node.position.x = p1_X_Position.global_position.x
	
	if is_P1_On_Bowl:
		p1_Node.position.y = p1_X_Position.global_position.y
	else:
		p1_Node.position.y += p1_Velocity.y

func Move_P2():
	p2_Node.position.x = p2_X_Position.global_position.x

	if is_P2_On_Bowl:
		p2_Node.position.y = p2_X_Position.global_position.y
	else:
		p2_Node.position.y += p2_Velocity.y

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
