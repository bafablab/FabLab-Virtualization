extends Control

onready var button_finnish = $Panel/Panel/Button_Finnish
onready var checkbox_inverty = $Panel/HBoxContainer/CheckBox
onready var device_menu = $"../UI_DeviceInfoMenu"
onready var item_menu = $"../UI_ItemInfoMenu"
onready var fps_controller = $"../FPSController"
onready var HUD = $"../HUD"

func _ready():
	HUD.hide_all()
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

# If the container for invert mouse y checkbox is clicked, manipulate the checkbox also
func _on_HBoxContainer_gui_input(event:InputEvent):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if !checkbox_inverty.pressed:
			checkbox_inverty.pressed = true
		else:
			checkbox_inverty.pressed = false

# Hide main menu. Hide mouse pointer if no menu is open.
func start_game():
	self.hide()
	#show HUD with debug on
	HUD.show_hud(true)
	if !(device_menu.visible or item_menu.visible):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
# Quit the game
func _on_ExitButton_pressed():
	get_tree().quit()

func _input(_event):
	if !self.visible:
		if Input.is_action_pressed("escape"):
			self.show()
	if self.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
