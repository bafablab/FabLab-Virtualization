extends Control

export (String) var label_str
onready var menu_window = $VBoxContainer
onready var tab_container = $VBoxContainer/Panel/TabContainer
onready var item_name_label = $VBoxContainer/Panel/NameLabel
onready var info_text = $VBoxContainer/Panel/TabContainer/Panel/InfoText
var item
var mesh_instance
var inFocus
onready var item_3d_view = $VBoxContainer/Panel/TabContainer/Item3DTab/Item3DView

# Called when the node enters the scene tree for the first time.
#func _ready():
	
	
func init(itm, mesh):
	item = itm
	mesh_instance = mesh
	item_name_label.text = item.name
	tab_container.set_tab_title(0, "Tietoja")
	print_debug(("Item menu visible"))
	info_text.text = item.info_text
	self.visible = true
	# Consumes the event so it is not triggered in other
	# scripts. For example close the window immidiately.
	get_tree().get_root().set_input_as_handled()
	
func _on_mouse_entered():
	inFocus = true

func _on_mouse_exited():
	inFocus = false

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		var evLocal = make_input_local(event)
		if !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			self.visible = false		


func _on_TabContainer_tab_selected(tab):
	if tab == 1:
		item_3d_view.init(mesh_instance)
