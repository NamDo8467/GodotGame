extends CharacterBody2D

const SPEED = 320.0
const JUMP_VELOCITY = -550.0
var weapon_list = []
var current_weapon_index = -1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player_sprite = $AnimatedSprite2D

var starting_position = Vector2(787, 888)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump_2") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# direction = -1, 0, 1
	var direction = Input.get_axis("move_left_2", "move_right_2")

	# Flip the player to the direction it is going
	if direction > 0:
		player_sprite.flip_h = false
		if current_weapon_index != -1:
			weapon_list[current_weapon_index].position = Vector2(-43, -34)
		#print("yes")
	elif direction < 0:
		if current_weapon_index != -1:
			weapon_list[current_weapon_index].position = Vector2(-52, -34)
		player_sprite.flip_h = true
		#print("No")
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			player_sprite.play("idle")
		elif direction == -1 or direction == 1:
			player_sprite.play("run")
	else:
		player_sprite.play("jump")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	# Handle choosing weapon
	if Input.is_action_just_pressed("choose_weapon_2"):
		if len(weapon_list) > 0:
			if current_weapon_index + 1 >= len(weapon_list):
				remove_child(weapon_list[current_weapon_index])
				current_weapon_index = -1
			else:
				current_weapon_index = current_weapon_index + 1
				var new_weapon = weapon_list[current_weapon_index]
				# -52, -43
				new_weapon.position = Vector2(-43, -34)
				if direction > 0:
					new_weapon.position = Vector2(-43, -34)
				elif direction < 0:
					new_weapon.position = Vector2(-52, -34)
		
				add_child(new_weapon)
		
func add_to_weapon_list(weapon):
	weapon_list.append(weapon)
	



