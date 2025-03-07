extends Node2D

@onready var knife = $CanvasLayer/Knife
@onready var p1 = $CanvasLayer/Player_1
@onready var p2 = $CanvasLayer/Player_2

var BASE_POSITION = Vector2(40,300)

var player_Speed = 1 

# Called when the node enters the scene tree for the first time.
func _ready():
	knife.position = BASE_POSITION
	p1.position = Vector2(BASE_POSITION.x, 64)
	p2.position = Vector2(BASE_POSITION.x, 536)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Move_P1()
	Move_P2()
	
	Move_Knife()

func Move_P1():
	if Input.is_action_pressed("P1_Minigame_Move_Right"):
		p1.position.x += player_Speed
	if Input.is_action_pressed("P1_Minigame_Move_Left"):
		p1.position.x -= player_Speed


func Move_P2():
	if Input.is_action_pressed("P2_Minigame_Move_Right"):
		p2.position.x += player_Speed
	if Input.is_action_pressed("P2_Minigame_Move_Left"):
		p2.position.x -= player_Speed

func Move_Knife():
	knife.position.x = (p1.position.x + p2.position.x) / 2 # position of centre of knife equal to half the distance between them
	
	var Hypotenuse = p1.position.distance_to(knife.position)
	var Adjacent = (p1.position.x - p2.position.x) / 2
	knife.rotation = PI/2 - acos(Adjacent / Hypotenuse)
