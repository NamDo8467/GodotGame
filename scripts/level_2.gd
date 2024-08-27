extends Node2D
@onready var scene_transition_animation = $SceneTransitionAnimation/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	scene_transition_animation.get_parent().get_node("ColorRect").color.a = 255
	#await get_tree().create_timer(0.5).timeout
	scene_transition_animation.play("fade_out")	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
