extends Spatial

onready var HUD = get_node("/root/FabLab/HUD")
onready var crosshair = get_node("/root/FabLab/UI_Crosshair")

var static_body
var in_focus = false
var table_up = false
var table_moving = false


func _ready():
	pass
	
func enter_focus():
	in_focus = true
	HUD.append_debugtext("Mouse on " + self.name)
	
func exit_focus():
	in_focus = false
	crosshair.clear_tooltip()

func _input(_event):
	if in_focus:
		
		if !table_moving:
			if table_up:
				crosshair.show_tooltip(tr("TOOLTIP_LOWER_TABLE"))
			elif !table_up:
				crosshair.show_tooltip(tr("TOOLTIP_RAISE_TABLE"))
		else:
			crosshair.clear_tooltip()
			
		if Input.is_action_just_pressed("mouse_click") && !table_moving:
			if table_up == false:
				$AnimationPlayer.play("01_height_adjust")
				table_moving = true
				table_up = true;
			else:
				$AnimationPlayer.play_backwards("01_height_adjust")	
				table_moving = true
				table_up = false;
			#in_focus = false
	

# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	table_moving = false
