extends Spatial

var overlay_material
export(Resource) var device
export (PackedScene) var videoScene = preload("res://test/Scenes/UI/UI_Theme_test_scene.tscn")
export (PackedScene) var deviceLabel = preload("res://_Game/Scenes/UI/UI_DeviceLabel.tscn")
var inFocus = false
var staticBody
var infoLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	infoLabel = deviceLabel.instance()
	staticBody = get_node("StaticBody")
	staticBody.connect("mouse_entered", self, "enter_focus")
	staticBody.connect("mouse_exited", self, "exit_focus")
	print_debug(infoLabel)
	self.add_child(infoLabel)
	infoLabel.text = device.model
	infoLabel.global_transform.origin.y += 0.5
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

func _input(_event):
	if inFocus:
		if Input.is_action_pressed("mouse_click"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			var deviceVideoScene=videoScene.instance()
			deviceVideoScene.init(device)
			self.add_child(deviceVideoScene)
