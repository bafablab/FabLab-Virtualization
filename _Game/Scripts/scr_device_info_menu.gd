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
var item_menu
#var video_tab
var device
var inFocus

# Called when the node enters the scene tree for the first time.
#func _ready():
	

func init(dev):
	device = dev
	tab_container.set_tab_title(0, "DEV_MENU_INFO")
	tab_container.set_tab_title(1, "DEV_MENU_DETAILS")
	item_menu = get_node("/root/FabLab/UI_ItemInfoMenu")
	
	# tr() funktio hakee käännöksen translation-tiedostosta
	# attribuutti bbcode_text mahdollistaa rikkaamman tekstin näytön (esim lihavointi)
	intro_text.bbcode_text = "[b]" + tr(device.generic_name) + "[/b] - [b]" + tr(device.name) + "[/b]\n\n" + tr(device.info_text)
	details_text.bbcode_text = tr(device.details_text)
	
	# Handle clicking hyperlinks in other than HTML5 versions of the game
	if OS.get_name() != "HTML5":
		intro_text.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
		details_text.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
	
	self.visible = true
	
	# set_input_as_handled()
	# consumes the event so it is not triggered in other
	# scripts, for example close the window immidiately.
	get_tree().get_root().set_input_as_handled()
	
	# Create buttons for example items done with this device, if any and show "example products"-text
	if len(device.example_items) > 0:
		example_text.bbcode_text = "[b]" + tr("DEV_MENU_EXAMPLES") + "[/b]"
		create_example_items()
	else:
		example_text.bbcode_text = ""
		# Clear any previous example items shown
		for button in item_list.get_children():
			item_list.remove_child(button)
		
	# clear video menu so that previous device's videos are not shown on it
#	clear_video_menu()
#	if len(device.videos) > 0:
#		create_video_menu()

func _input(event):
	# Hide menu if clicked outside of it
	if self.visible:
		if (event is InputEventMouseButton) and event.pressed:
			var evLocal = make_input_local(event)
			# Do not close if videoplayer scene is open
#			if videoplayer_scene == null and !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
			if !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
				exit_window()

func exit_window():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	# set first tab active when menu is closed so next time it is opened it is on the first tab
	tab_container.current_tab = 0

# Function for opening hyperlinks in other than HTML5-based exports
func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)

func create_example_items():
	# clear the example item before adding current device's example items
	for button in item_list.get_children():
		item_list.remove_child(button)

	for item in device.example_items:
		var button = Button.new()
		button.text = " " + tr(item.name) + " "
		item_list.add_child(button)
		button.connect("pressed", self, "_item_button_pressed", [item])

# open item info window and initialize with the selected example item
func _item_button_pressed(item):
	item_menu.init(item)

#func create_video_menu():
#	video_tab = VBoxContainer.new()
#	tab_container.add_child(video_tab)
#	tab_container.set_tab_title(2, "DEV_MENU_VIDEOS")
#	# Create buttons for videos from the device's DeviceInfo resource.
#	for i in range(len(device.videos)):
#		var button = Button.new()
#		# if video has a corresponding title set use it for the button text.
#		if len(device.video_titles) > i and len(device.video_titles[i]) > 0:
#			button.text = tr(device.video_titles[i])
#		# if the video doesn't have title set use "Video {video number}" for the text
#		else:
#			button.text = "Video " + str(i+1)
#		# Connect the button signal to _button_pressed(video_number) function
#		button.connect("pressed", self, "_button_pressed", [i])
#		video_tab.add_child(button)
#		# add description to video if it has one.
#		if len(device.video_descriptions) > i and len(device.video_descriptions[i]) > 0:
#			var label = Label.new()
#			label.text = tr(device.video_descriptions[i])
#			video_tab.add_child(label)
#
#
#func clear_video_menu():
#	if videoplayer_scene != null:
#		if videoplayer_scene.is_inside_tree():
#			self.remove_child(videoplayer_scene)
#			videoplayer_scene.queue_free()
#
#	if video_tab != null:
#		tab_container.remove_child(video_tab)
#		#print_debug(video_tab)
#		video_tab.queue_free()
#		video_tab = null
#
#	for button in item_list.get_children():
#		item_list.remove_child(button)
#
## open videoplayer scene and initialize it with current device's resource, selected video number and reference to self
#func _button_pressed(video_number):
#	videoplayer_scene = videoplayer.instance()
#	videoplayer_scene.init(device, video_number, self)
#	self.add_child(videoplayer_scene)
