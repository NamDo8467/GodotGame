extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player_sprite = $AnimatedSprite2D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# direction = -1, 0, 1
	var direction = Input.get_axis("ui_left", "ui_right")

	
	# Flip the player to the direction it is facing
	if direction > 0:
		player_sprite.flip_h = false
	elif direction <0:
		player_sprite.flip_h = true
		
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
