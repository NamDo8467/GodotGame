extends AudioStreamPlayer


const title_screen_background_music = preload("res://assets/Audio/level_background_music.wav")

const level_background_music = preload("res://assets/Audio/title_screen_background_sound.mp3")


func play_music(music: AudioStream, volume=0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
	
func play_title_screen_music():
	play_music(title_screen_background_music, 22)
	
func play_level_music():
	play_music(level_background_music, 24)
