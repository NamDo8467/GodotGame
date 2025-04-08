extends Node2D
@onready var animation_player:AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
