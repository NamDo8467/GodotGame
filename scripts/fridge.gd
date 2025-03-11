extends Area2D

@onready var fridge_animation = $AnimatedSprite2D

var player_standing_in_front_of_it = false
var fridge_close_or_open = "close"
# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_standing_in_front_of_it == true:
		if Input.is_key_pressed(KEY_SHIFT) and fridge_close_or_open == "close":
			fridge_animation.play("open")
			fridge_close_or_open = "open"
		elif Input.is_key_pressed(KEY_CTRL) and fridge_close_or_open == "open":
			fridge_animation.play("close")
			fridge_close_or_open = "close"
		


func _on_body_entered(body):
	player_standing_in_front_of_it = true
	#pass # Replace with function body.


func _on_body_exited(body):
	player_standing_in_front_of_it= false
	#pass # Replace with function body.
