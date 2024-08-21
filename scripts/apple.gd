extends Area2D
@onready var apple = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	apple.play("collected")
	

func _on_animated_sprite_2d_animation_finished():
	if apple.animation == "collected":
		queue_free()
	
