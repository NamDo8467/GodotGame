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
var current_weapon_list = []

# Spawning position
var spawning_position_y = 863

# set of players to transition to the elevator section
var player_set_to_show_elevator = {}

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
	
