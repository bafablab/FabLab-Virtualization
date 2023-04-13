extends Panel

onready var button_finnish = $Panel/Button_Finnish
var fps_controller

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fps_controller = get_node("/root/FabLab/FPSController")

func change_language():
	var group = button_finnish.group
	
	match group.get_pressed_button().name:
		"Button_Finnish":
			TranslationServer.set_locale("fi")
			print_debug(("Suomi"))
		"Button_Swedish":
			TranslationServer.set_locale("se")
			print_debug(("Ruotsi"))
		"Button_English":
			TranslationServer.set_locale("en")
			print_debug(("Englanti"))


func _on_CheckBox_toggled(button_pressed):
	if button_pressed == false:
		fps_controller.inverse_mouse = 1
	else:
		fps_controller.inverse_mouse = -1
	print_debug(button_pressed)


func start_game():
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_pressed("escape"):
		self.show()
	if self.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
