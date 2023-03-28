extends Spatial

var overlay_material
export(Resource) var item
export (PackedScene) var item_menu_scene = preload("res://test/Scenes/UI/UI_item_info_scene.tscn")
export (PackedScene) var hover_text_scene = preload("res://_Game/Scenes/UI/UI_Hover_Text_Label.tscn")
onready var collision_shape  = $StaticBody/CollisionShape
onready var hover_text_position = $HoverTextPosition
var in_focus = false
var static_body
var game_manager
var hover_text
 
# Called when the node enters the scene tree for the first time.
func _ready():
	game_manager = get_node("/root/FabLab")	
	static_body = get_node("StaticBody")
	static_body.connect("mouse_entered", self, "enter_focus")
	static_body.connect("mouse_exited", self, "exit_focus")
	set_hover_text()
	overlay_material = get_child(0).get_material_overlay()
	get_child(0).set_material_overlay(null)

func enter_focus():
	in_focus = true
	hover_text.visible = true
	get_child(0).set_material_overlay(overlay_material)	

func exit_focus():
	in_focus = false
	get_child(0).set_material_overlay(null)
	hover_text.visible = false

func _input(_event):
	if in_focus:
		if Input.is_action_just_pressed("mouse_click"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			var item_menu=item_menu_scene.instance()
			item_menu.init(item)
			self.add_child(item_menu)
			# set inFocus false to prevent re-click when closing menu
			in_focus = false

func set_hover_text():
	if $HoverTextPosition:
		hover_text_position = $HoverTextPosition
	hover_text = hover_text_scene.instance()
	self.add_child(hover_text)
	hover_text.text = item.name
	if hover_text_position:
		hover_text.transform.origin = hover_text_position.transform.origin
	else:
		hover_text.global_transform.origin.y += collision_shape.shape.extents.y + 0.2
	hover_text.visible = false
