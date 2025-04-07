extends Node2D

@onready var star_1 = $Star_1
@onready var star_2 = $Star_2
@onready var star_3 = $Star_3
@onready var star_4 = $Star_4
@onready var star_5 = $Star_5

var Star_Load_Time = 0.2

func _ready():
	Display_Empty_Stars()

func Display_Empty_Stars():
	star_1.Display()
	await get_tree().create_timer(Star_Load_Time).timeout
	star_2.Display()
	await get_tree().create_timer(Star_Load_Time).timeout
	star_3.Display()
	await get_tree().create_timer(Star_Load_Time).timeout
	star_4.Display()
	await get_tree().create_timer(Star_Load_Time).timeout
	star_5.Display()
	await get_tree().create_timer(Star_Load_Time).timeout
	
	Set_Stars(0.0)

func Set_Stars(score_Percent : float):
	star_1.Section_Selection(1)
	await get_tree().create_timer(Star_Load_Time).timeout
	star_2.Section_Selection(2)
	await get_tree().create_timer(Star_Load_Time).timeout
	star_3.Section_Selection(3)
	await get_tree().create_timer(Star_Load_Time).timeout
	star_4.Section_Selection(4)
	await get_tree().create_timer(Star_Load_Time).timeout
	star_5.Section_Selection(5)
	await get_tree().create_timer(Star_Load_Time).timeout
