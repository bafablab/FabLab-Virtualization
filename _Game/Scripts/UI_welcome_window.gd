extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add texts to header and textbox since Godot doesn't automatically translate text in the bbcode-field
	$VBoxContainer/Panel/WelcomeHeader.bbcode_text = "[center][b]" + tr("WELCOME_HEADER") + "[/b][/center]"
	$VBoxContainer/Panel/WelcomeText.bbcode_text = tr("WELCOME_TEXT")
	
	# Handle clicking hyperlinks
	if OS.get_name() != "HTML5":
		$VBoxContainer/Panel/WelcomeText.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
	
	self.hide()

# Recapture mouse and hide window
func close():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.hide()
	
# Function for opening hyperlinks
func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
