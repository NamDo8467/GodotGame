extends Node2D

@onready var star_1 = $Star_1
@onready var star_2 = $Star_2
@onready var star_3 = $Star_3
@onready var star_4 = $Star_4
@onready var star_5 = $Star_5

var NUM_STARS = 5
var STAR_SECTIONS = 5
var FULL_STAR_PERCENT = 20
var STAR_LOAD_TIME = 0.2
var score_Value = 0

func _ready():
	#Set_Stars(99)
	pass

func Set_Stars(number : int):
	score_Value = number
	
	Display_Empty_Stars()


func Display_Empty_Stars():
	star_1.Display()
	await get_tree().create_timer(STAR_LOAD_TIME).timeout
	star_2.Display()
	await get_tree().create_timer(STAR_LOAD_TIME).timeout
	star_3.Display()
	await get_tree().create_timer(STAR_LOAD_TIME).timeout
	star_4.Display()
	await get_tree().create_timer(STAR_LOAD_TIME).timeout
	star_5.Display()
	await get_tree().create_timer(STAR_LOAD_TIME).timeout
	
	Calculate_Star_Scores()

func Calculate_Star_Scores():
	var Score_Split = score_Value / FULL_STAR_PERCENT
	var Full_Stars = int(Score_Split)
	var Semi_Stars = int((score_Value % FULL_STAR_PERCENT) / (FULL_STAR_PERCENT / STAR_SECTIONS))
	
	if Score_Split >= 1.0:
		star_1.Section_Selection(STAR_SECTIONS)
	else:
		star_1.Section_Selection(Semi_Stars)
		return
	
	Score_Split -= 1
	await get_tree().create_timer(STAR_LOAD_TIME * 2).timeout
	
	if Score_Split >= 1.0:
		star_2.Section_Selection(STAR_SECTIONS)
	else:
		star_2.Section_Selection(Semi_Stars)
		return
	
	Score_Split -= 1
	await get_tree().create_timer(STAR_LOAD_TIME * 2).timeout
	
	if Score_Split >= 1.0:
		star_3.Section_Selection(STAR_SECTIONS)
	else:
		star_3.Section_Selection(Semi_Stars)
		return
	
	Score_Split -= 1
	await get_tree().create_timer(STAR_LOAD_TIME * 2).timeout
	
	if Score_Split >= 1.0:
		star_4.Section_Selection(STAR_SECTIONS)
	else:
		star_4.Section_Selection(Semi_Stars)
		return
	
	Score_Split -= 1
	await get_tree().create_timer(STAR_LOAD_TIME * 2).timeout
	
	if Score_Split >= 1.0:
		star_5.Section_Selection(STAR_SECTIONS)
	else:
		star_5.Section_Selection(Semi_Stars)
		return
