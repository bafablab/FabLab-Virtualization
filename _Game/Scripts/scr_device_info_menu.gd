# $$-etuliitteellä olevat tekstit ovat avaimia StringKeys lisäosaa varten

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
	tab_container.set_tab_title(0, "device_menu$$Tietoja")
	item_menu = get_node("/root/FabLab/UI_ItemInfoMenu")
	#print_debug(("Device menu visible"))
	
	# tr() funktio hakee käännöksen translation-tiedostosta
	info_text.text = tr(device.info_text)
	self.visible = true
	# set_input_as_handled()
	# consumes the event so it is not triggered in other
	# scripts. For example close the window immidiately.
	get_tree().get_root().set_input_as_handled()
	clear_video_menu()
	if len(device.videos) > 0:
		create_video_menu()

func _on_mouse_entered():
	inFocus = true

func _on_mouse_exited():
	inFocus = false

func _input(event):
	if self.visible:
		if (event is InputEventMouseButton) and event.pressed:
			var evLocal = make_input_local(event)
			if videoplayer_scene == null and !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				self.visible = false
				tab_container.current_tab = 0

func create_video_menu():
	video_tab = VBoxContainer.new()
	tab_container.add_child(video_tab)
	tab_container.set_tab_title(1, "device_menu$$Videot")
	for i in range(len(device.videos)):
		var button = Button.new()
		# info_textis shown on first tab.
		if len(device.video_titles) > i and len(device.video_titles[i]) > 0:
			button.text = tr(device.video_titles[i])
		else:
			button.text = "Video " + str(i+1)
		button.connect("pressed", self, "_button_pressed", [i])
		video_tab.add_child(button)
		if len(device.video_descriptions) > i and len(device.video_descriptions[i]) > 0:
			var label = Label.new()
			label.text = tr(device.video_descriptions[i])
			video_tab.add_child(label)
	
	for item in device.example_items:
		print_debug(item.name)
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
		print_debug(video_tab)
		video_tab.queue_free()
		video_tab = null

func _button_pressed(video_number):
	videoplayer_scene = videoplayer.instance()
	videoplayer_scene.init(device, video_number, self)
	self.add_child(videoplayer_scene)

func _item_button_pressed(item):
	item_menu.init(item, item.mesh)
