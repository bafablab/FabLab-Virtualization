extends Spatial

var overlay_material
export(Resource) var device

# Called when the node enters the scene tree for the first time.
func _ready():
	#overlay_material = get_child(0).get_material_overlay()
	#get_child(0).set_material_overlay(null)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func enter_focus():
	print_debug(get_child(0).material_overlay)
	#get_child(0).set_material_overlay(overlay_material)
	scale *= 1.01

func _on_mouse_entered():
	enter_focus()

func _on_mouse_exited():
	scale /= 1.01
	get_child(0).set_material_overlay(null)
