extends Control

onready var button_finnish = $Panel/Panel/Button_Finnish
onready var device_menu = $"../UI_DeviceInfoMenu"
onready var item_menu = $"../UI_ItemInfoMenu"
var fps_controller

func _ready():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fps_controller = get_node("/root/FabLab/FPSController")
	

func change_language():
	var group = button_finnish.group
	
	match group.get_pressed_button().name:
		"Button_Finnish":
			TranslationServer.set_locale("fi")
		"Button_Swedish":
			TranslationServer.set_locale("se")
		"Button_English":
			TranslationServer.set_locale("en")

func _on_CheckBox_toggled(button_pressed):
	if button_pressed == false:
		fps_controller.inverse_mouse = 1
	else:
		fps_controller.inverse_mouse = -1

func start_game():
	self.hide()
	if !(device_menu.visible or item_menu.visible):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if !self.visible:
		if Input.is_action_pressed("escape"):
			self.show()
	if self.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
