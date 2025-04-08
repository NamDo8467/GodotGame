extends AudioStreamPlayer


const title_screen_background_music = preload("res://assets/Audio/level_background_music.wav")

const level_background_music = preload("res://assets/Audio/title_screen_background_sound.mp3")

var current_music = null

func play_music(music: AudioStream,  type:String, volume=0.0):
	if current_music == type:
		return
	#if stream == music:
		#return
		
	stream = music
	volume_db = volume
	play()
	
func play_title_screen_music():
	play_music(title_screen_background_music, "title_screen", 22)
	current_music = "title_screen"
	
func play_level_music():
	play_music(level_background_music, "level", 0)
	current_music = "level"
