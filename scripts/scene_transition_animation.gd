extends CanvasLayer
@onready var animation_player = $AnimationPlayer
@onready var color_rect = $ColorRect
@onready var label = $Label

func _ready():
	color_rect.visible = false
#
func change_scene():
	color_rect.visible = true
	animation_player.play("fade_in")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		animation_player.play("fade_out")
	elif anim_name == 'fade_out':
		color_rect.visible = false
			
