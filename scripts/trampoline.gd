extends Area2D


# Called when the node enters the scene tree for the first time.
@onready var timer = $Timer
@onready var trampoline_animation = $AnimatedSprite2D
var picked_up = false

#timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#timer.start()


func _on_body_entered(body):
	if picked_up == true:
		trampoline_animation.play("push")
		var player = body
		player.velocity.y = -1500
	else:
		picked_up = true
		Global.is_trampoline_picked_up = true
		body.add_to_weapon_list(self)
		self.position = Vector2(0,0)
		get_parent().call_deferred("remove_child", self)

func _on_timer_timeout():
	pass
	

