extends Control

onready var menu_window = $VBoxContainer
onready var itemlist = $VBoxContainer/Panel/ItemList
var sensor

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.hide()
	
func init(resource):
	sensor = resource
	updatetexts()
	
	itemlist.add_item ("test1", null, false)
	itemlist.add_item ("test2", null, false)
	itemlist.add_item ("test3", null, false)
	
	self.visible = true
	
	# set_input_as_handled()
	# consumes the event so it is not triggered in other
	# scripts, for example close the window immidiately.
	#get_tree().get_root().set_input_as_handled()
	
	
func updatetexts():
	if sensor != null:
		# Add texts to header and textbox since Godot doesn't automatically translate text in the bbcode-field
		$VBoxContainer/Panel/Header.bbcode_text = "[center][b]" + tr(sensor.header_text) + "[/b][/center]"
		$VBoxContainer/Panel/Button.text = tr("BUTTON_CLOSE")

func _input(event):
	if self.visible:
		if (event is InputEventMouseButton) and event.pressed:
			var evLocal = make_input_local(event)
			# Close the menu by clicking anywhere outside of it
			if !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
				close()
				
		if Input.is_action_just_pressed("ui_cancel"):
			close()


# show window
func open():
	self.show()

# hide window, Close button connects here
func close():
	self.hide()
	sensor = null
