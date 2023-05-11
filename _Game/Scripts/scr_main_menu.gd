extends Control

onready var button_finnish = $Panel/Panel/Button_Finnish
onready var device_menu = $"../UI_DeviceInfoMenu"
onready var item_menu = $"../UI_ItemInfoMenu"
onready var fps_controller = $"../FPSController"

func _ready():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func change_language():
	var group = button_finnish.group
	
	# match is similar to switch-case
	match group.get_pressed_button().name:
		"Button_Finnish":
			TranslationServer.set_locale("fi")
		"Button_Swedish":
			TranslationServer.set_locale("sv")
		"Button_English":
			TranslationServer.set_locale("en")


func _on_CheckBox_toggled(button_pressed):
	if button_pressed == false:
		fps_controller.inverse_mouse = 1
	else:
		fps_controller.inverse_mouse = -1

# Hide main menu. Hide mouse pointer if no menu is open.
func start_game():
	self.hide()
	if !(device_menu.visible or item_menu.visible):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(_event):
	if !self.visible:
		if Input.is_action_pressed("escape"):
			self.show()
	if self.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
