extends Node

# Load score from a file
var score = 0

# Load level from a file
var level = 1

func add_score():
	score += 1
	
func reset_score():
	# Load score from a file
	score = 0
	
