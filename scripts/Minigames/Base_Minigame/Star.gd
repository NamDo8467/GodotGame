extends Node2D

@onready var anim = $AnimationPlayer

func Display():
	anim.play("Load_In")

func Section_Selection(number : int):
	anim.play("Piece_" + str(number))
