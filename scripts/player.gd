extends CharacterBody2D

const SPEED = 320.0
const JUMP_VELOCITY = -800.0
#var weapon_list = []
var current_weapon_index = -1

var trampoline_x_when_facing_left = -80
var trampoline_x_when_facing_right = -43
var trampoline_y = -120

const PUSH_FORCE := 15
const BLOCK_MAX_VELOCITY = 120
const MIN_PUSH_FORCE := 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var MIN_GRAVITY_MULTI = 4.0 # HABIB
var MAX_GRAVITY_MULTI = 1.5 # HABIB
var gravity_Multi # HABIB
var trampoline_scene = preload("res://scenes/trampoline.tscn")
@onready var player_sprite = $AnimatedSprite2D
@onready var timer = $Timer



var starting_position = Vector2(787, 888)

var player2 : CharacterBody2D
var is_picking_player2_up = false
var can_pickup = false

@onready var collision_shape = $CollisionShape2D

# These variables are used when this player is getting thrown away
var time: float = 0.0

var throw_direction : Vector2
var is_being_picked = false

var is_thrown = false
var throw_velocity = Vector2.ZERO
var throw_time = 0.0  # Time since throw started
#var time = 0.0

func _physics_process(delta):
	# Add the gravity.
	var direction = Input.get_axis("move_left", "move_right")
	time += delta
	#print(direction)
	#if Input.is_action_just_pressed("DEBUG_THROW"):
			##throw_player(800, 60, -1) # throw left
			#throw_player(800, 60, 1) # throw right
	if is_being_picked:
		return
	if is_thrown:
		throw_time += delta  # Track time since thrown
		
		# Apply gravity
		throw_velocity.y += gravity * delta
		
		# Predict movement
		var motion = throw_velocity * delta
		var collision = move_and_collide(motion)  # Check for mid-air collision
		
		if collision:  # If player hits something in mid-air
			throw_velocity.x = 0  # Stop forward motion
			velocity = Vector2(0, throw_velocity.y)  # Only fall down
		else:
			velocity = throw_velocity
		
		move_and_slide()

		# Stop when landing
		if is_on_floor():
			land()
	else:
		if not is_on_floor():
			gravity_Multi = MIN_GRAVITY_MULTI
			
			if velocity.y < 0:
				gravity_Multi = MAX_GRAVITY_MULTI
			
			velocity.y += gravity * gravity_Multi * delta
		
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# direction = -1, 0, 1

		# Flip the player to the direction it is going
		if direction > 0:
			player_sprite.flip_h = false
			if collision_shape != null:
				collision_shape.position.x = 28
				collision_shape.position.y = -58
			if current_weapon_index != -1:
				Global.player1_current_weapon_list[current_weapon_index].position = Vector2(trampoline_x_when_facing_right, trampoline_y)
			#print("yes")
		elif direction < 0:
			if current_weapon_index != -1:
				Global.player1_current_weapon_list[current_weapon_index].position = Vector2(trampoline_x_when_facing_left, trampoline_y)
			player_sprite.flip_h = true
			#print(collision_shape == null)
			if collision_shape != null:
				collision_shape.position.x = -37
				collision_shape.position.y = -58
			
		# Play animations
		if is_on_floor():
			if direction == 0:
				player_sprite.play("idle")
			elif direction == -1 or direction == 1:
				player_sprite.play("run")
		elif not is_on_floor():
			player_sprite.play("jump")
		
			
		if direction:
			velocity.x = direction * SPEED
			change_position_of_player2_after_picking_up()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			change_position_of_player2_after_picking_up()
			
		move_and_slide()
		if can_pickup and current_weapon_index == -1 or current_weapon_index >= len(Global.player1_current_weapon_list):
			if Input.is_action_just_pressed("pickup"):
				player2 = get_node("../Player2")
				if is_picking_player2_up == false:
					player2.is_being_picked = true
					is_picking_player2_up = true
					change_position_of_player2_after_picking_up()
				else:
					if player_sprite.flip_h == false:
						player2.throw_player(420, 30, 1)
					else:
						player2.throw_player(420, 30, -1)
					player2.is_being_picked = false
					is_picking_player2_up = false
					can_pickup = false

		# Handle choosing weapon
		if Input.is_action_just_pressed("choose_weapon") and is_picking_player2_up == false:
			if len(Global.player1_current_weapon_list) > 0:
				if current_weapon_index + 1 >= len(Global.player1_current_weapon_list):
					remove_child(get_node("Trampoline"))
					#remove_child(Global.player1_current_weapon_list[current_weapon_index])
					current_weapon_index = -1
				else:
					var new_weapon = trampoline_scene.instantiate()
					new_weapon.picked_up = true
					new_weapon.position = Vector2(trampoline_x_when_facing_right, trampoline_y)
					Global.player1_current_weapon_list[current_weapon_index] = new_weapon
					current_weapon_index = current_weapon_index + 1

					if player_sprite.flip_h == false:
						new_weapon.position = Vector2(trampoline_x_when_facing_right, trampoline_y)
					elif player_sprite.flip_h == true:
						new_weapon.position = Vector2(trampoline_x_when_facing_left, trampoline_y)
					add_child(new_weapon)
				
						
			
func add_to_weapon_list(weapon):
	Global.player1_current_weapon_list.append(weapon)

# Function to throw the player
func throw_player(speed: float, angle_degrees: float, direction: int):
	var angle_radians = deg_to_rad(angle_degrees)
	throw_velocity = Vector2(
		direction * speed * cos(angle_radians),  # Multiply by direction (-1 for left, 1 for right)
		-speed * sin(angle_radians)  # Vertical velocity stays the same
	)
	is_thrown = true
	throw_time = 0.0

func land():
	is_thrown = false
	velocity = Vector2.ZERO  # Fully stop the player
	throw_velocity = Vector2.ZERO
	throw_time = 0.0

func _on_pickup_zone_body_entered(body):
	can_pickup = true

func change_position_of_player2_after_picking_up():
	if is_picking_player2_up and player2 != null:
		player2.position.y = self.position.y - 112
		var player2_sprite = player2.get_node("AnimatedSprite2D")
		if player_sprite.flip_h == true and player2_sprite.flip_h == false:
			player2.position.x = position.x - 50
		elif player_sprite.flip_h == false and player2_sprite.flip_h == false:
			player2.position.x = position.x
		elif player_sprite.flip_h == false and player2_sprite.flip_h == true:
			player2.position.x = position.x + 50
		else:
			player2.position.x = position.x


func _on_pickup_zone_body_exited(body):
	can_pickup = false
