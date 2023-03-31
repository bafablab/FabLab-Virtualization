extends Spatial

var overlay_material
export(Resource) var interactable
export (PackedScene) var hover_text_scene = preload("res://_Game/Scenes/UI/UI_Hover_Text_Label.tscn")
onready var collision_shape  = $StaticBody/CollisionShape
var empty_device_resource = preload("res://_Game/Resources/dev_empty_device_info.tres")
var empty_item_resource = preload("res://_Game/Resources/itm_empty_item_info.tres")
var mesh_instance
var menu
var hover_text
var hover_text_position
var in_focus = false
var static_body
var game_manager
 
# Called when the node enters the scene tree for the first time.
func _ready():
	if self.is_in_group("Device"):
		menu = get_node("/root/FabLab/UI_DeviceInfoMenu")
	elif self.is_in_group("Item"):
		menu = get_node("/root/FabLab/UI_ItemInfoMenu")
	game_manager = get_node("/root/FabLab")	
	static_body = get_node("StaticBody")
	static_body.connect("mouse_entered", self, "enter_focus")
	static_body.connect("mouse_exited", self, "exit_focus")
	
	
	#   Find MeshInstance and get highlight shader
	for child in get_children():
		if child is MeshInstance:
			overlay_material = child.get_material_overlay()
			if overlay_material == null:
				print_debug("No overlay material! (highlight shader)")
			child.set_material_overlay(null)
			mesh_instance = child
			break
			
	if interactable == null:
		if self.is_in_group(("Device")):
			print_debug("Empty device")
			interactable = empty_device_resource
		elif self.is_in_group("Item"):
			print_debug("Empty")
			interactable = empty_item_resource
			
	set_hover_text()

func enter_focus():
	in_focus = true
	hover_text.visible = true
	if overlay_material:
		mesh_instance.set_material_overlay(overlay_material)	
	else:
		print_debug("No overlay material! (highlight shader)")

func exit_focus():
	in_focus = false
	mesh_instance.set_material_overlay(null)
	hover_text.visible = false

func _input(_event):
	if in_focus:
		if Input.is_action_just_pressed("mouse_click"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			print_debug("Clicked interactable!")
			if self.is_in_group("Item"):
				menu.init(interactable, mesh_instance)
			elif self.is_in_group("Device"):
				menu.init(interactable)
			# set in_focus false to prevent re-click when closing menu
			in_focus = false

func set_hover_text():
	hover_text_position = get_node_or_null("HoverTextPosition")
	hover_text = hover_text_scene.instance()
	self.add_child(hover_text)
	hover_text.text = interactable.name
	if hover_text_position:
		hover_text.transform.origin = hover_text_position.transform.origin
	else:
		hover_text.global_transform.origin.y += collision_shape.shape.extents.y + 0.2
	hover_text.visible = false
