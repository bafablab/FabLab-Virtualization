extends Control

export (String) var label_str
export (PackedScene) var videoplayer = preload("res://_Game/Scenes/UI/VideoPlayerScene.tscn")
var videoplayer_scene
onready var menu_window = $VBoxContainer
onready var tab_container = $VBoxContainer/Panel/TabContainer
onready var device_name_label = $VBoxContainer/Panel/NameLabel
onready var info_text = $VBoxContainer/Panel/TabContainer/Panel/InfoText
onready var item_list = $VBoxContainer/Panel/TabContainer/Panel/HBoxContainer
var item_menu
var video_tab
var device
var inFocus

# Called when the node enters the scene tree for the first time.
#func _ready():
	

func init(dev):
	device = dev
	device_name_label.text = device.name
	tab_container.set_tab_title(0, "DEV_MENU_INFO")
	item_menu = get_node("/root/FabLab/UI_ItemInfoMenu")
	#print_debug(("Device menu visible"))
	
	# tr() funktio hakee käännöksen translation-tiedostosta
	info_text.bbcode_text = tr(device.info_text)
	self.visible = true
	# set_input_as_handled()
	# consumes the event so it is not triggered in other
	# scripts, for example close the window immidiately.
	get_tree().get_root().set_input_as_handled()
	# clear video menu so that previous device's videos are not shown on it
	clear_video_menu()
	if len(device.videos) > 0:
		create_video_menu()

func _input(event):
	# Hide menu if clicked outside of it
	if self.visible:
		if (event is InputEventMouseButton) and event.pressed:
			var evLocal = make_input_local(event)
			# Do not close if videoplayer scene is open
			if videoplayer_scene == null and !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				self.visible = false
				# set first tab active when menu is closed so next time it is opened it is on the first tab
				tab_container.current_tab = 0

func create_video_menu():
	video_tab = VBoxContainer.new()
	tab_container.add_child(video_tab)
	tab_container.set_tab_title(1, "DEV_MENU_VIDEOS")
	# Create buttons for videos from the device's DeviceInfo resource.
	for i in range(len(device.videos)):
		var button = Button.new()
		# if video has a corresponding title set use it for the button text.
		if len(device.video_titles) > i and len(device.video_titles[i]) > 0:
			button.text = tr(device.video_titles[i])
		# if the video doesn't have title set use "Video {video number}" for the text
		else:
			button.text = "Video " + str(i+1)
		# Connect the button signal to _button_pressed(video_number) function
		button.connect("pressed", self, "_button_pressed", [i])
		video_tab.add_child(button)
		# add description to video if it has one.
		if len(device.video_descriptions) > i and len(device.video_descriptions[i]) > 0:
			var label = Label.new()
			label.text = tr(device.video_descriptions[i])
			video_tab.add_child(label)
	
	# clear the example item before adding current device's example items
	for button in item_list.get_children():
		item_list.remove_child(button)
		
	for item in device.example_items:
		# print_debug(item.name)
		var button = Button.new()
		button.text = item.name
		item_list.add_child(button)
		button.connect("pressed", self, "_item_button_pressed", [item])
		

func clear_video_menu():
	if videoplayer_scene != null:
		if videoplayer_scene.is_inside_tree():
			self.remove_child(videoplayer_scene)
			videoplayer_scene.queue_free()
			
	if video_tab != null:
		tab_container.remove_child(video_tab)
		#print_debug(video_tab)
		video_tab.queue_free()
		video_tab = null
		
	for button in item_list.get_children():
		item_list.remove_child(button)

# open videoplayer scene and initialize it with current device's resource, selected video number and reference to self
func _button_pressed(video_number):
	videoplayer_scene = videoplayer.instance()
	videoplayer_scene.init(device, video_number, self)
	self.add_child(videoplayer_scene)

# open item menu and initialize it with 
func _item_button_pressed(item):
	item_menu.init(item)
