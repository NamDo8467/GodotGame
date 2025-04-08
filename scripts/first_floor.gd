extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.is_trampoline_picked_up == true:
		get_node("Trampoline").queue_free()

	AudioPlayer.play_level_music()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
