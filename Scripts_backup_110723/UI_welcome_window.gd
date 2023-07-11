extends Control

onready var menu_window = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	updatetexts()
	
	# Handle clicking hyperlinks in other than HTML5 versions of the game
	if OS.get_name() != "HTML5":
		$VBoxContainer/Panel/WelcomeText.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
	
	self.hide()
	
func updatetexts():
	# Add texts to header and textbox since Godot doesn't automatically translate text in the bbcode-field
	$VBoxContainer/Panel/WelcomeHeader.bbcode_text = "[center][b]" + tr("WELCOME_HEADER") + "[/b][/center]"
	$VBoxContainer/Panel/WelcomeText.bbcode_text = tr("WELCOME_TEXT")
	$VBoxContainer/Panel/Button.text = tr("BUTTON_CLOSE")

func _input(event):
	if self.visible:
		if (event is InputEventMouseButton) and event.pressed:
			var evLocal = make_input_local(event)
			# Close the menu by clicking anywhere outside of it
			if !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
				close()
				
	# Show welcome window again if F3 pressed
	# Bug: if device or item info windows are open, input handling is out of whack
	if Input.is_action_just_pressed("show_welcome"):
		if !self.visible:
			open()
		else:
			close()

# show window
func open():
	self.show()

# hide window, Close button connects here
func close():
	self.hide()
	
# Function for opening hyperlinks in other than HTML5-based exports
func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
