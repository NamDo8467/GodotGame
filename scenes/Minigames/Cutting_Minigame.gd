extends Node2D

@onready var Knife = $CanvasLayer/Knife
@onready var P1_Pos = Vector2(0,0)
@onready var P2_Pos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	Knife.position = Vector2(40, 300)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_P1()
	move_P2()
	
	move_Knife()

func move_P1():
	if Input.is_action_pressed("P1_Minigame_Move_Right"):
		P1_Pos.x += 1

func move_P2():
	if Input.is_action_pressed("P2_Minigame_Move_Right"):
		P2_Pos.x += 1

func move_Knife():
	Knife.position.x = (P1_Pos.x + P2_Pos.x) / 2 # position of centre of knife equal to half the distance between them
	


