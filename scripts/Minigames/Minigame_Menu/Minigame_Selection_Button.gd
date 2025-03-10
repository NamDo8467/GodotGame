extends Button

@onready var step_Name = $Step_Name
@onready var step_Descritpion = $Step_Descritpion
@onready var step_Controls = $Step_Controls

var name_Text : String
var descritpion_Text : String
var controls_Text : String

var name_font_size = 24

# Called when the node enters the scene tree for the first time.
func _ready():
	Set_Step_Text()

func Set_Step_Text():
	name_Text = step_Name.text
	descritpion_Text = step_Descritpion.text
	controls_Text = step_Controls.text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_focus_entered():
	Bold_Text()

func _on_focus_exited():
	Normalize_Text()

func Bold_Text():
	step_Name.text = "[b]" + name_Text
	step_Descritpion.text = "[b]" + descritpion_Text
	step_Controls.text = "[b]" + controls_Text

func Normalize_Text():
	step_Name.text = name_Text
	step_Descritpion.text = descritpion_Text
	step_Controls.text = controls_Text

