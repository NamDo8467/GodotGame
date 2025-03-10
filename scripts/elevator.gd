extends Node2D

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_UP) or Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER):
		if self.position.y > -590:
			self.position.y -= 4
			Global.spawning_position_y -= 1.6
		
	elif Input.is_key_pressed(KEY_DOWN) or Input.is_joy_button_pressed(0, JOY_BUTTON_LEFT_SHOULDER):
		if self.position.y < 2:
			self.position.y += 4
			Global.spawning_position_y += 1.6
