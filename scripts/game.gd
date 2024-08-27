extends Node2D
@onready var score_board = $ScoreBoard


# Called when the node enters the scene tree for the first time.
func _ready():
	score_board.get_child(0).text = " Score: " + str(Global.score)
	
func _process(delta):
	score_board.get_child(0).text = " Score: " + str(Global.score)
	
