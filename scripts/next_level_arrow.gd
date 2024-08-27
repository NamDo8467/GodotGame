extends Area2D
@onready var arrow = $AnimatedSprite2D
#@onready var scene_transition_animation = $"../SceneTransitionAnimation/AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	arrow.play("hit")
	#print(scene_transition_animation)
	SceneTransitionAnimation.change_scene()
	
	#scene_transition_animation.play("fade_in")
	#get_tree().change_scene_to_file("res://scenes/level_2.tscn")
