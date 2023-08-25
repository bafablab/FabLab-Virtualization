extends Control

onready var button_finnish = $Panel/Panel/Button_Finnish
onready var button_english = $Panel/Panel/Button_English
onready var checkbox_inverty = $Panel/InvertYContainer/CheckBox
onready var checkbox_gamepadtoggle = $Panel/GamepadToggleContainer/CheckBox
onready var fps_controller = $"../FPSController"
onready var firststart = true
onready var welcome_window = get_node("/root/FabLab/UI_WelcomeWindow")
onready var device_info_menu = get_node("/root/FabLab/UI_DeviceInfoMenu")
onready var item_info_menu = get_node("/root/FabLab/UI_ItemInfoMenu")
onready var generic_info_menu = get_node("/root/FabLab/UI_GenericInfoMenu")
onready var HUD = get_node("/root/FabLab/HUD")

func _ready():
	pause_game()
	

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

func _on_GamepadToggle_toggled(button_pressed):
	if button_pressed == false:
		fps_controller.gamepad_enabled = false
	else:
		fps_controller.gamepad_enabled = true
	
func _on_GamepadToggleContainer_gui_input(event:InputEvent):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if !checkbox_gamepadtoggle.pressed:
			checkbox_gamepadtoggle.pressed = true
		else:
			checkbox_gamepadtoggle.pressed = false

func _on_InvertY_toggled(button_pressed):
	if button_pressed == false:
		fps_controller.inverse_mouse = 1
	else:
		fps_controller.inverse_mouse = -1

# If the container for invert mouse y checkbox is clicked, manipulate the checkbox also
func _on_InvertYContainer_gui_input(event:InputEvent):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if !checkbox_inverty.pressed:
			checkbox_inverty.pressed = true
		else:
			checkbox_inverty.pressed = false

# Pause game. Hide main menu. Change mouse to captured.
func start_game():
	get_tree().paused = false
	HUD.append_debugtext("Game resumed")
	self.hide()
	# Change the button text from Start to Continue after first press
	if firststart:
		firststart = false
		$Panel/StartButton.text = "MAIN_MENU_CONTINUE"
		welcome_window.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	HUD.append_debugtext("Game paused")
	self.show()
	get_tree().paused = true

# Quit the game
func _on_ExitButton_pressed():
	if OS.get_name() == "HTML5":
		JavaScript.eval('document.getElementById("canvas").remove();') # removes the game canvas from the HTML file so that a halted game is not shown
	get_tree().quit()


func _input(_event):
	if self.visible:
		if Input.is_action_just_pressed("ui_right"):
			button_english.pressed = true
			button_english.emit_signal("pressed")
		if Input.is_action_just_pressed("ui_left"):
			button_finnish.pressed = true
			button_finnish.emit_signal("pressed")
			
		if Input.is_action_just_pressed("ui_x_button"):
			if !checkbox_inverty.pressed:
				checkbox_inverty.pressed = true
			else:
				checkbox_inverty.pressed = false
		
		if Input.is_action_just_pressed("ui_cancel"):
			start_game()
		
		# Quit on gamepad by pressing select
		if Input.is_action_just_pressed("ui_select_button"):
			_on_ExitButton_pressed()
			
	# Pressing escape pauses the game and shows the main menu
	if Input.is_action_just_pressed("escape"):
		if !self.visible:
			pause_game()
		else:
			start_game()
			
	# Ctrl + F12 resets the game
	if Input.is_action_just_pressed("reset_game"):
		get_tree().reload_current_scene()
