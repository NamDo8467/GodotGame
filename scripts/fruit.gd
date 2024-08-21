extends Area2D
@onready var fruit = $AnimatedSprite2D

var fruit_names = ["apple", "banana", "cherries","kiwi", "melon", "orange", "pineapple", "strawberry"]
var current_fruit_name = ""
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	current_fruit_name = fruit_names[rng.randi_range(0, len(fruit_names) - 1)]
	fruit.play(current_fruit_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	fruit.play("collected")


func _on_animated_sprite_2d_animation_finished():
	if fruit.animation == "collected":
		queue_free()
		
