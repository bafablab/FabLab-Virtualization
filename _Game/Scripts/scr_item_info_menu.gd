extends Control

export (String) var label_str
onready var panel = $Panel
onready var tab_container = $Panel/TabContainer
onready var item_name_label = $Panel/ItemNameLabel
onready var info_text = $Panel/TabContainer/Panel/InfoText
var item
var inFocus

# Called when the node enters the scene tree for the first time.
#func _ready():
	
	
func init(itm):
	item = itm
	item_name_label.text = item.name
	tab_container.set_tab_title(0, "Tietoja")
	print_debug(("Device menu visible"))
	info_text.text = item.info_text
	self.visible = true
	
func _on_mouse_entered():
	inFocus = true

func _on_mouse_exited():
	inFocus = false

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		var evLocal = make_input_local(event)
		if !Rect2(panel.rect_position, panel.rect_size).has_point(evLocal.position):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			self.visible = false
		
