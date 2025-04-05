extends Control
@onready var menu_Container = $Menu_Container
@onready var steps = $Menu_Container/Forground/Steps
@onready var p1_Ready = $Menu_Container/Forground/Player_1_Ready
@onready var p2_Ready = $Menu_Container/Forground/Player_2_Ready
@onready var current_Minigame_Node = $Current_Minigame

@onready var bg_Music = $Menu_Container/Sound/BG_Music

@onready var transition = $Transition
var tansition_Time = 1.0

var p1_State = false
var p2_State = false

var current_scores = []
var current_Minigame
var current_Minigame_num = 0
var Minigame_0 = preload("res://scenes/Minigames/Cutting_Minigame/Cutting_Minigame.tscn")
var Minigame_1 = preload("res://scenes/Minigames/Button_Mashing_Minigame/Button_Mashing_Minigame.tscn")
var Minigame_2 = preload("res://scenes/Minigames/Mixing_Bowl_Minigame/Mixing_Bowl_Minigame.tscn")
var is_Minigame_Started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var colour = Color(0.2, 0.2, 0.2, 1)
	
	p1_Ready.modulate = colour
	p2_Ready.modulate = colour
	
	for child in steps.get_children():
		child.disabled = true
	
	Update_Current_Minigame(current_Minigame_num)

func Update_Current_Minigame(number):
	steps.get_child(number).disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_Minigame_Started:
		return
	
	if Input.is_action_just_released("go_to_minigames"):
		current_scores = [85.23, 85.21, 85.48]
		End_Minigames_Mode()
	
	Ready_Buttons()
	
	if p1_State && p2_State:
		Select_Minigame(current_Minigame_num)
		Start_Minigame()
	if Input.is_action_just_released("go_to_serving"):
		Global.transition_to_serving()

func Ready_Buttons():
	if Input.is_action_just_pressed("P1_Minigame_Action_1"):
		Toggle_P1_Ready()
	if Input.is_action_just_pressed("P2_Minigame_Action_1"):
		Toggle_P2_Ready()

func Toggle_P1_Ready():
	var colour = Color(1, 1, 1, 1)
	
	if p1_State:
		colour = Color(0.2, 0.2, 0.2, 1)
	
	p1_Ready.modulate = colour
	
	p1_State = !p1_State

func Toggle_P2_Ready():
	var colour = Color(1, 1, 1, 1)
	
	if p2_State:
		colour = Color(0.2, 0.2, 0.2, 1)
	
	p2_Ready.modulate = colour
	
	p2_State = !p2_State

func Select_Minigame(number):
	match number:
		0:
			current_Minigame = Minigame_0.instantiate()
		1:
			current_Minigame = Minigame_1.instantiate()
		2:
			current_Minigame = Minigame_2.instantiate()

func Start_Minigame():
	is_Minigame_Started = true
	
	Update_BGM()
	
	var tween = create_tween()
	
	tween.tween_property(transition, "color", Color(0,0,0,1), tansition_Time)
	tween.tween_property(transition, "color", Color(0,0,0,0), tansition_Time / 2)
	
	await get_tree().create_timer(tansition_Time).timeout

	Toggle_P1_Ready()
	Toggle_P2_Ready()
	
	current_Minigame.transition = transition
	current_Minigame.connect("Minigame_Finished", Minigame_Finished)
	current_Minigame_Node.add_child(current_Minigame)

func Minigame_Finished(score):
	current_scores.append(score)
	
	steps.get_child(current_Minigame_num).get_child(0).text = "[font_size=14]Score:    " + str(score) + "%" #TODO: Make this better and cleaner
	steps.get_child(current_Minigame_num).get_child(0).visible = true #TODO: Make this better and cleaner
	
	var tween = create_tween()
	
	tween.tween_property(transition, "color", Color(0,0,0,1), tansition_Time)
	
	if current_Minigame_num == 2:
		End_Minigames_Mode()
		return
	
	tween.tween_property(transition, "color", Color(0,0,0,0), tansition_Time / 2)
	await get_tree().create_timer(tansition_Time).timeout
	
	current_Minigame.queue_free()
	
	is_Minigame_Started = false
	current_Minigame_num += 1
	
	Update_BGM()
	
	Update_Current_Minigame(current_Minigame_num)
	Select_Minigame(current_Minigame_num)

func Update_BGM():
	match is_Minigame_Started:
		true:
			bg_Music.stop()
		false:
			bg_Music.play()


func End_Minigames_Mode():
	var total = 0
	for score in current_scores:
		total += score
	
	total /= current_scores.size()
	
	Global.score_from_minigames = total
	
	SceneTransitionAnimation.change_scene()
	await SceneTransitionAnimation.animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/serving.tscn")
