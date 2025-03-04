extends Control

func StartGame_Pressed():
	Button_Pressed_Sound()
	#TODO: Change this to move to a level select screen
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func Settings_Pressed():
	Button_Pressed_Sound()
	#TODO: Connect this to a menu
	print("Open Settings screen")

func Credits_Pressed():
	Button_Pressed_Sound()
	#TODO: Connect this to a menu
	print("Open Credits screen")
	
func Quit_Pressed():
	Button_Pressed_Sound()
	get_tree().quit()


func Button_Pressed_Sound():
	#TODO: Add a button clicking sound effect
	$SFX_Button_Pressed.play()
	return
