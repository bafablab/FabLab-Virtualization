# $$-etuliitteellä olevat tekstit ovat avaimia StringKeys lisäosaa varten

extends Control

export (String) var label_str
onready var menu_window = $VBoxContainer
onready var tab_container = $VBoxContainer/Panel/TabContainer
onready var item_name_label = $VBoxContainer/Panel/NameLabel
onready var info_text = $VBoxContainer/Panel/TabContainer/Panel/InfoText
var item
var inFocus
onready var item_3d_view = $VBoxContainer/Panel/TabContainer/Item3DTab/Item3DView

# Called when the node enters the scene tree for the first time.
#func _ready():
	

func init(itm):
	item = itm
	item_name_label.text = item.name
	tab_container.set_tab_title(0, "ITEM_INFO_TITLE")
	tab_container.set_tab_title(1, "ITEM_INFO_3D_MODEL_TITLE")
	#print_debug(("Item menu visible"))
	# tr() is used when godot doesn't automatically detect translatable text
	info_text.bbcode_text = tr(item.info_text)
	self.visible = true
	# Consumes the event so it is not triggered in other
	# scripts. For example close the window immidiately.
	get_tree().get_root().set_input_as_handled()


func _input(event):
	if self.visible:
		if (event is InputEventMouseButton) and event.pressed:
			var evLocal = make_input_local(event)
			# Close the menu by clicking anywhere outside of it
			if !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				self.visible = false
				# select first tab when item-menu is closed so it is selected when it is opened again
				tab_container.current_tab = 0


func _on_TabContainer_tab_selected(tab):
	if tab == 1:
		item_3d_view.init(item.mesh_instance)


func _on_CloseButton_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = false
	# select first tab when item-menu is closed so it is selected when it is opened again
	tab_container.current_tab = 0
