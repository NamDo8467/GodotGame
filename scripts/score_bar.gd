extends ProgressBar

var scores_from_minigames = Global.scores_from_minigames
var serving_score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if len(scores_from_minigames) != 0:
		var sum = 0
		for score in scores_from_minigames:
			sum += score
		serving_score = sum/len(scores_from_minigames)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	
	if value < serving_score:
		value += 10 * delta

func Minigame_Finished(score):
	scores_from_minigames.append(score)
	print(scores_from_minigames)
