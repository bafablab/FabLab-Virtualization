extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add texts to header and textbox since Godot doesn't automatically translate text in the bbcode-field
	$VBoxContainer/Panel/WelcomeHeader.bbcode_text = "[center][b]" + tr("WELCOME_HEADER") + "[/b][/center]"
	$VBoxContainer/Panel/WelcomeText.bbcode_text = tr("WELCOME_TEXT")
	self.hide()

# Recapture mouse and close this window instance
func close():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
