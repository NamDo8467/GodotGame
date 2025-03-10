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
	name_Text = step_Name.text
	descritpion_Text = step_Descritpion.text
	controls_Text = step_Controls.text
	
	step_Name.push_font_size(name_font_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_focus_entered():
	Toggle_Highlight_Text()

func _on_focus_exited():
	Toggle_Highlight_Text()

func Toggle_Highlight_Text():
	step_Name.text = "[b]" + step_Name.text

