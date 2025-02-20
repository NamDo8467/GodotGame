extends Node2D
#@onready var scene_transition_animation = $SceneTransitionAnimation/AnimationPlayer
@onready var scene_transition_animation = SceneTransitionAnimation


# Called when the node enters the scene tree for the first time.
func _ready():
	scene_transition_animation.color_rect.color.a = 255
	scene_transition_animation.animation_player.play("fade_out")	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
