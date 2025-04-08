extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.play_title_screen_music()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://scenes/settings_scene.tscn")


func _on_about_us_button_pressed():
	get_tree().change_scene_to_file("res://scenes/about_scene.tscn")
