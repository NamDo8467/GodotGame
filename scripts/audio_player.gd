extends AudioStreamPlayer


const title_screen_background_music = preload("res://assets/Audio/level_background_music.wav")

const level_background_music = preload("res://assets/Audio/title_screen_background_sound.wav")

var current_music = null

var global_volume = 5

var current_volume_slider_value = 100

func play_music(music: AudioStream,  type:String):
	if current_music == type:
		return
	#if stream == music:
		#return
		
	stream = music
	volume_db = global_volume
	play()
	
func play_title_screen_music():
	play_music(title_screen_background_music, "title_screen")
	current_music = "title_screen"
	
func play_level_music():
	play_music(level_background_music, "level")
	current_music = "level"

func Stop_All_Music():
	self.stop()
	
func change_music_volume(volume: int):
	volume_db = volume
	global_volume = volume
