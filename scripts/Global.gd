extends Node

# Load score from a file
var score = 0

# Load level from a file
var level = 1

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
var current_weapon = null

func add_score():
	score += 1
	
func reset_score():
	# Load score from a file
	score = 0
	
