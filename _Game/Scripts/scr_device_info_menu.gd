extends Control

export (String) var label_str
#export (PackedScene) var videoplayer = preload("res://_Game/Scenes/UI/VideoPlayerScene.tscn")
#var videoplayer_scene
onready var menu_window = $VBoxContainer
onready var tab_container = $VBoxContainer/TabContainer
onready var intro_text = $VBoxContainer/TabContainer/Panel/InfoText
onready var details_text = $VBoxContainer/TabContainer/Panel2/InfoText
onready var example_text = $VBoxContainer/TabContainer/Panel/ExampleText
onready var item_list = $VBoxContainer/TabContainer/Panel/HBoxContainer
onready var item_menu = get_node("/root/FabLab/UI_ItemInfoMenu")
#var video_tab
var device
var inFocus

# Called when the node enters the scene tree for the first time.
func _ready():
	# Handle clicking hyperlinks in other than HTML5 versions of the game
	intro_text.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
	details_text.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")

func init(dev):
	device = dev
	
	updatetexts()
	
	self.visible = true
	
	# set_input_as_handled()
	# consumes the event so it is not triggered in other
	# scripts, for example close the window immidiately.
	get_tree().get_root().set_input_as_handled()
	


func updatetexts():
	if device != null:
		tab_container.set_tab_title(0, "   " + tr("DEV_MENU_INFO") + "   ")
		tab_container.set_tab_title(1, "   " + tr("DEV_MENU_DETAILS") + "   ")
		
		# tr() fetches a translation from translations.csv
		# bbcode_text enables rich text such as bolding, hyperlinks, etc.
		intro_text.bbcode_text = "[b]" + tr(device.generic_name) + "[/b] - [b]" + tr(device.name) + "[/b]\n\n" + tr(device.info_text)
		details_text.bbcode_text = "[b]" + tr(device.generic_name) + "[/b] - [b]" + tr(device.name) + "[/b]\n\n" + tr(device.details_text)
		
		clear_example_items()
		
			# Create buttons for example items done with this device, if any and show "example products"-text
		if len(device.example_items) > 0:
			example_text.bbcode_text = "[b]" + tr("DEV_MENU_EXAMPLES") + "[/b]"
			create_example_items()

func _input(event):
	# Hide menu if clicked outside of it
	if self.visible:
		if (event is InputEventMouseButton) and event.pressed:
			var evLocal = make_input_local(event)
			if !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
				exit_window()
		
		if Input.is_action_just_pressed("ui_cancel"):
			exit_window()
			
		if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right"):
			if tab_container.current_tab == 0:
				tab_container.set_current_tab(1)
			elif tab_container.current_tab == 1:
				tab_container.set_current_tab(0)

func clear_example_items():
	example_text.bbcode_text = ""
	for button in item_list.get_children():
		item_list.remove_child(button)

func exit_window():
	self.visible = false
	
	# set first tab active when menu is closed so next time it is opened it is on the first tab
	tab_container.current_tab = 0
	
	# Clear example items
	clear_example_items()
		
	# Clear device
	device = null

# Function for opening hyperlinks
func _on_RichTextLabel_meta_clicked(meta):
	# For other than web exports
	if OS.get_name() != "HTML5":
# warning-ignore:return_value_discarded
		OS.shell_open(meta)
	else:
		JavaScript.eval('window.open("' + meta + '")') # open the link in a new window

func create_example_items():
	# clear the example item before adding current device's example items
	for button in item_list.get_children():
		item_list.remove_child(button)

	for item in device.example_items:
		var button = Button.new()
		button.text = "   " + tr(item.name) + "   "
		item_list.add_child(button)
		button.connect("pressed", self, "_item_button_pressed", [item])

# open item info window and initialize with the selected example item
func _item_button_pressed(item):
	item_menu.init(item)
