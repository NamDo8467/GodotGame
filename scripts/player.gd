extends CharacterBody2D

const SPEED = 320.0
const JUMP_VELOCITY = -550.0
var weapon_list = []
var current_weapon_index = -1

var trampoline_x_when_facing_left = -80
var trampoline_x_when_facing_right = -43
var trampoline_y = -120

const PUSH_FORCE := 15
const BLOCK_MAX_VELOCITY = 120
const MIN_PUSH_FORCE := 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player_sprite = $AnimatedSprite2D
@onready var timer = $Timer



var starting_position = Vector2(787, 888)

@onready var collision_shape = $CollisionShape2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# direction = -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")

	# Flip the player to the direction it is going
	if direction > 0:
		player_sprite.flip_h = false
		if collision_shape != null:
			collision_shape.position.x = 26
			collision_shape.position.y = -60.285
		if current_weapon_index != -1:
			weapon_list[current_weapon_index].position = Vector2(trampoline_x_when_facing_right, trampoline_y)
		#print("yes")
	elif direction < 0:
		if current_weapon_index != -1:
			weapon_list[current_weapon_index].position = Vector2(trampoline_x_when_facing_left, trampoline_y)
		player_sprite.flip_h = true
		#print(collision_shape == null)
		if collision_shape != null:
			collision_shape.position.x = -41
			collision_shape.position.y = -60.285
		
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
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_block = collision.get_collider()
		if collision_block is RigidBody2D:
			#print("UYes")
			var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
			print(push_force)
			collision_block.apply_central_impulse(-collision.get_normal() * push_force)	
			
	# Handle choosing weapon
	if Input.is_action_just_pressed("choose_weapon"):
		if len(weapon_list) > 0:
			if current_weapon_index + 1 >= len(weapon_list):
				remove_child(weapon_list[current_weapon_index])
				current_weapon_index = -1
			else:
				current_weapon_index = current_weapon_index + 1
				var new_weapon = weapon_list[current_weapon_index]
				#new_weapon.position = Vector2(trampoline_x_when_facing_right, trampoline_y)
				if player_sprite.flip_h == false:
					new_weapon.position = Vector2(trampoline_x_when_facing_right, trampoline_y)
				elif player_sprite.flip_h == true:
					new_weapon.position = Vector2(trampoline_x_when_facing_left, trampoline_y)
				add_child(new_weapon)
			
func add_to_weapon_list(weapon):
	weapon_list.append(weapon)



