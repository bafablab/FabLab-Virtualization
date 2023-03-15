extends Spatial


var overlay_material
export(Resource) var device
export (PackedScene) var videoScene = preload("res://test/Scenes/UI/UI_Theme_test_scene.tscn")
var infoLabel
var inFocus = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(device)
	infoLabel = Label.new()
	infoLabel.text = device.model
	self.add_child(infoLabel)
	infoLabel.visible = false
	overlay_material = get_child(0).get_material_overlay()
	get_child(0).set_material_overlay(null)

func enter_focus():
	inFocus = true
	infoLabel.visible = true
	get_child(0).set_material_overlay(overlay_material)	

func exit_focus():
	inFocus = false
	get_child(0).set_material_overlay(null)
	infoLabel.visible = false

func _input(event):
	if inFocus:
		if Input.is_action_pressed("mouse_click"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			var deviceVideoScene=videoScene.instance()
			deviceVideoScene.init(device)
			self.add_child(deviceVideoScene)
