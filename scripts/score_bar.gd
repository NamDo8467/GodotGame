extends ProgressBar

@onready var text_Thank_You = $Thank_You_Text #PlaceHolder for playetest

var score_from_minigames = Global.score_from_minigames
var serving_score = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	#if len(score_from_minigames) != 0:
		#var sum = 0
		#for score in score_from_minigames:
			#sum += score
		#serving_score = score_from_minigames
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if value < score_from_minigames:
		value += 30 * delta
	
	if value >= score_from_minigames:
		text_Thank_You.visible = true

#func Minigame_Finished(score):
	#score_from_minigames.append(score)
	#print(score_from_minigames)
