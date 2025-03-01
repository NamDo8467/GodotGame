extends Area2D


# Called when the node enters the scene tree for the first time.
@onready var timer = $Timer
@onready var trampoline_animation = $AnimatedSprite2D

#timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#timer.start()


func _on_body_entered(body):
	trampoline_animation.play("push")
	var player = body
	player.velocity.y = -650
	
	
	
	#var player = body
	


func _on_timer_timeout():
	pass
	

