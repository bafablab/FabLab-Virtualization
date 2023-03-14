extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var overlay_material

# Called when the node enters the scene tree for the first time.
func _ready():
	overlay_material = get_child(0).get_material_overlay()
	get_child(0).set_material_overlay(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func enter_focus():
	print_debug(get_child(0).material_overlay)
	get_child(0).set_material_overlay(overlay_material)

func _on_mouse_entered():
	enter_focus()

func _on_mouse_exited():
	get_child(0).set_material_overlay(null)
