extends Control

export (String) var label_str
onready var menu_window = $VBoxContainer
onready var tab_container = $VBoxContainer/TabContainer
#onready var item_name_label = $VBoxContainer/Panel/NameLabel
onready var info_text = $VBoxContainer/TabContainer/Panel/InfoText
onready var device_info_menu = get_node("/root/FabLab/UI_DeviceInfoMenu")
var item
var inFocus
var wasCalledFromDeviceMenu = false
onready var item_3d_view = $VBoxContainer/TabContainer/Panel/Item3DView

# Called when the node enters the scene tree for the first time.
func _ready():
	# Handle clicking hyperlinks in other than HTML5 versions of the game
	if OS.get_name() != "HTML5":
# warning-ignore:return_value_discarded
		$VBoxContainer/TabContainer/Panel/InfoText.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
	

func init(itm):
	
	# This window was opened from a device info window, hide it and show it again after closing
	if device_info_menu.visible:
		wasCalledFromDeviceMenu = true
		device_info_menu.hide()
	
	item = itm
	#item_name_label.text = item.name
	updatetexts()
	
	# Initialize the object 3d view
	item_3d_view.init(item.mesh_instance)
	
	self.visible = true
	
	# Consumes the event so it is not triggered in other
	# scripts. For example close the window immidiately.
	get_tree().get_root().set_input_as_handled()

func updatetexts():
	if item != null:
		tab_container.set_tab_title(0, "ITEM_INFO_TITLE")
		# tr() is used when godot doesn't automatically detect translatable text
		info_text.bbcode_text = "[b]" + tr(item.name) + "[/b]\n\n" + tr(item.info_text)

func _input(event):
	if self.visible:
		if (event is InputEventMouseButton) and event.pressed:
			var evLocal = make_input_local(event)
			# Close the menu by clicking anywhere outside of it
			if !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
				exit_window()

# Function for opening hyperlinks in other than HTML5-based exports
func _on_RichTextLabel_meta_clicked(meta):
# warning-ignore:return_value_discarded
	OS.shell_open(meta)

func exit_window():
	self.visible = false
	if wasCalledFromDeviceMenu:
		device_info_menu.show()
		wasCalledFromDeviceMenu = false
	item = null
