extends Control

onready var menu_window = $VBoxContainer
var generic_info

# Called when the node enters the scene tree for the first time.
func _ready():
	# Handle clicking hyperlinks in other than HTML5 versions of the game
	if OS.get_name() != "HTML5":
		$VBoxContainer/Panel/InfoText.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
	
	self.hide()
	
func init(resource):
	generic_info = resource
	updatetexts()
	self.visible = true
	
	# set_input_as_handled()
	# consumes the event so it is not triggered in other
	# scripts, for example close the window immidiately.
	get_tree().get_root().set_input_as_handled()
	
func updatetexts():
	if generic_info != null:
		# Add texts to header and textbox since Godot doesn't automatically translate text in the bbcode-field
		$VBoxContainer/Panel/Header.bbcode_text = "[center][b]" + tr(generic_info.header_text) + "[/b][/center]"
		$VBoxContainer/Panel/InfoText.bbcode_text = tr(generic_info.info_text)
		$VBoxContainer/Panel/Button.text = tr("BUTTON_CLOSE")

func _input(event):
	if self.visible:
		if (event is InputEventMouseButton) and event.pressed:
			var evLocal = make_input_local(event)
			# Close the menu by clicking anywhere outside of it
			if !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
				close()


# show window
func open():
	self.show()

# hide window, Close button connects here
func close():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.hide()
	generic_info = null
	
# Function for opening hyperlinks in other than HTML5-based exports
func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)
