extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (String) var label_str

onready var label = $Label
onready var pos_x_orig=label.rect_position.x
onready var scale_orig=label.rect_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button2_focus_entered():
	label.rect_position.x +=10
	label.rect_pivot_offset=rect_scale/2
	label.rect_scale+=Vector2(0.05,0.05)
	



func _on_Button2_focus_exited():
	label.rect_position.x = pos_x_orig
	label.rect_scale = scale_orig
	label.rect_pivot_offset=Vector2(0,0)
