extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("move_elevator_up"):
	#if Input.is_key_pressed(KEY_UP) or Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER):
		Global.go_up_one_floor_level()
		print(Global.current_floor)
		if Global.current_floor > Global.total_floor_level:
			Global.go_down_one_floor_level()
			return
		else:
			if len(Global.player_set_to_show_elevator) > 1:
				move_elevator()
				
	elif Input.is_action_just_released("move_elevator_down"):
	#elif Input.is_key_pressed(KEY_DOWN) or Input.is_joy_button_pressed(0, JOY_BUTTON_LEFT_SHOULDER):
		Global.go_down_one_floor_level()
		#print("hahah")
		if Global.current_floor < 0:
			Global.go_up_one_floor_level()
			return
		else:
			if len(Global.player_set_to_show_elevator) > 1:
				move_elevator()

func move_elevator():
	#print(Global.current_floor)
	SceneTransitionAnimation.change_scene()
	await SceneTransitionAnimation.animation_player.animation_finished
	if Global.current_floor == 1:
		get_tree().change_scene_to_file("res://scenes/first_floor.tscn")
	elif Global.current_floor == 2:
		get_tree().change_scene_to_file("res://scenes/second_floor.tscn")
	elif Global.current_floor == 3:
		get_tree().change_scene_to_file("res://scenes/third_floor.tscn")
