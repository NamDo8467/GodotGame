extends Area2D

@onready var banana = $AnimatedSprite2D

func _on_body_entered(body):
	banana.play("collected")
	print("I print here")

func _on_animated_sprite_2d_animation_finished():
	Global.add_score()
	if banana.animation == "collected":
		queue_free()
