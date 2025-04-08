extends Node2D

@onready var progress_Bar = $ProgressBar
@onready var anim = $AnimationPlayer

var MIN_SKIP_PROGRESS = 0.0
var MAX_SKIP_PROGRESS = 3.0
var PROGRESS_GAIN = 1.0
var skip_Progress = 0.0

var Cutscene_Finished = false

func _ready():
	progress_Bar.visible = false
	progress_Bar.max_value = MAX_SKIP_PROGRESS
	
	Update_Skip_Progress()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Cutscene_Finished:
		if Input.is_action_just_pressed("P1_Minigame_Action_1") || Input.is_action_just_pressed("P2_Minigame_Action_1"):
			Start_Fade_Out()
		
		return
	
	if skip_Progress < MAX_SKIP_PROGRESS:
		if Input.is_action_pressed("P1_Minigame_Action_1") || Input.is_action_pressed("P2_Minigame_Action_1"):
			skip_Progress += PROGRESS_GAIN * delta
		else:
			skip_Progress -= PROGRESS_GAIN * delta
	
	skip_Progress = clamp(skip_Progress, MIN_SKIP_PROGRESS, MAX_SKIP_PROGRESS)
	
	if progress_Bar.value >= progress_Bar.max_value:
		Finish_Cutscene()
	elif progress_Bar.value > 0:
		progress_Bar.visible = true
	else:
		progress_Bar.visible = false
	
	Update_Skip_Progress()

func Finish_Cutscene():
	anim.play("RESET")
	progress_Bar.visible = false
	Cutscene_Finished = true
	Start_Fade_Out()

func Update_Skip_Progress():
	progress_Bar.value = skip_Progress

func Start_Fade_Out():
	anim.play("Fade_Out")

func Start_First_Floor():
	get_tree().change_scene_to_file("res://scenes/first_floor.tscn")
