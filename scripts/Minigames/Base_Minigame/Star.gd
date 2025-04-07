extends Node2D

@onready var anim = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.reset()


func Section_Selection(number : int):
	anim.play(str(number) + "_Piece")
