extends Control

onready var button_finnish = $Panel/Panel/Button_Finnish
onready var checkbox_inverty = $Panel/HBoxContainer/CheckBox
onready var fps_controller = $"../FPSController"
onready var firststart = true
onready var welcome_window = get_node("/root/FabLab/UI_WelcomeWindow")
onready var device_info_menu = get_node("/root/FabLab/UI_DeviceInfoMenu")
onready var item_info_menu = get_node("/root/FabLab/UI_ItemInfoMenu")
onready var generic_info_menu = get_node("/root/FabLab/UI_GenericInfoMenu")
onready var HUD = get_node("/root/FabLab/HUD")

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
	# Call all nodes with troublesome texts and tell them to update their text fields
	welcome_window.updatetexts()
	device_info_menu.updatetexts()
	item_info_menu.updatetexts()
	generic_info_menu.updatetexts()


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

# Pause game. Hide main menu. Change mouse to captured.
func start_game():
	# Change the button text from Start to Continue after first press
	if firststart:
		firststart = false
		$Panel/Button.text = "MAIN_MENU_CONTINUE"
		welcome_window.show()
	get_tree().paused = false
	HUD.append_debugtext("Game resumed")
	self.hide()

func pause_game():
	HUD.append_debugtext("Game paused")
	self.show()
	get_tree().paused = true

# Quit the game
func _on_ExitButton_pressed():
	if OS.get_name() == "HTML5":
		JavaScript.eval('document.getElementById("canvas").remove();') # removes the game canvas from the HTML file so that a halted game is not shown
		# TODO: Add a quit message to the HTML template and maybe a restart button?
	get_tree().quit()

# Pressing escape pauses the game and shows the main menu
func _input(_event):
	if self.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("escape"):
		if !self.visible:
			pause_game()
		else:
			start_game()
