extends CharacterBody2D


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var push = false
var direction = 0
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if push:
		velocity.x = direction * delta * 9000
	else:
		velocity.x = 0

	move_and_slide()


func _on_left_body_entered(body):
	if body.name == "Player" or body.name == "Player2":
		direction = 1
		push = true

func _on_left_body_exited(body):
	if body.name == "Player" or body.name == "Player2":
		direction = 0
		push = false
	
func _on_right_body_entered(body):
	print(body.name)
	if body.name == "Player" or body.name == "Player2":
		direction = -1
		push = true


func _on_right_body_exited(body):
	if body.name == "Player" or body.name == "Player2":
		direction = 0
		push = false
