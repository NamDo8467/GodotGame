extends Node

# Load score from a file
var score = 0

# Load level from a file
var level = 1

var score_from_minigames = 0.0

# Map of each food's ingredient
var food = {
	"pasta": ["tomato", "dough", "cheese", "mushroom"],
	"friedRice": ["rice", "egg", "garlic", "onions"]
}

# Current food in the level
var current_food = "pasta"

# Current collected ingredient
var current_ingredient_list = []

# Current possesing weapon
var player1_current_weapon_list = []
var player2_current_weapon_list = []

# Check if the trampoline is picked up so that when transition betweeen scenes, the trampoline won't be rendered once picked
var is_trampoline_picked_up = false

# Spawning position
# when x = 130, thats the spawning x coordinate in the elevator
# when x = 1053, thats the spawning x cooridinate in the room
var spawning_position_x = 130
var spawning_position_y = 863

# Die outside of the room or not
var die_outside_of_the_room = false
var is_Inisde_Room = false # Habib

# set of players to transition to the elevator section
var player_set_to_show_elevator = {}

# Total number of floor levels
var total_floor_level = 3
var current_floor = 1
func go_up_one_floor_level():
	current_floor += 1
	
func go_down_one_floor_level():
	current_floor -= 1
	
func add_score():
	score += 1
	
func reset_score():
	# Load score from a file
	score = 0
	
func reset_apartment_scene():
	score = 0
	spawning_position_y = 927

func transition_to_minigames():
	SceneTransitionAnimation.change_scene()
	await SceneTransitionAnimation.animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/Minigames/Minigame_Menu/Minigame_Menu.tscn")

func transition_to_serving():
	SceneTransitionAnimation.change_scene()
	await SceneTransitionAnimation.animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/serving.tscn")
	
