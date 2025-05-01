extends Node2D
@onready var volume_slider = $TabContainer/Sound/VolumeSlider
var current_volume_slider_value
var original_volume = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	current_volume_slider_value = AudioPlayer.current_volume_slider_value
	volume_slider.value = current_volume_slider_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")


func _on_volume_slider_drag_ended(value_changed):
	if value_changed == true:
		var current_audio_volume = AudioPlayer.volume_db
		
		var new_volume_slider_value = volume_slider.value
		
		if new_volume_slider_value == 0:
			AudioPlayer.stream_paused = true
			AudioPlayer.change_music_volume(-160)
			current_volume_slider_value = 0
		elif new_volume_slider_value == 100:
			AudioPlayer.change_music_volume(original_volume)
			current_volume_slider_value = 100
			AudioPlayer.stream_paused = false
			
		else:
			# Formula to calculate new_audio_volume
			#new_volume_slider_value/100 = new_audio_volume/5
			var new_audio_volume
			if current_volume_slider_value == 0:
				AudioPlayer.stream_paused = false
			
			if new_volume_slider_value < current_volume_slider_value: # if going down
				new_audio_volume = (new_volume_slider_value/100)*5 - 8
			elif new_volume_slider_value >= current_volume_slider_value: # if going up
				new_audio_volume = (new_volume_slider_value/100)*5 + 2
				
			AudioPlayer.change_music_volume(new_audio_volume)
			#AudioPlayer.stream_paused = false
			current_volume_slider_value = new_volume_slider_value
			
			
	volume_slider.value = current_volume_slider_value
	AudioPlayer.current_volume_slider_value = current_volume_slider_value
			
		


#func _on_volume_slider_value_changed(value):
	#current_volume_slider_value = value
	#var new_audio_volume
	#var current_audio_volume = AudioPlayer.volume_db
	#var new_volume_slider_value = volume_slider.value
	#new_audio_volume = (new_volume_slider_value * current_audio_volume)/current_volume_slider_value
	
