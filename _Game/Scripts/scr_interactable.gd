extends Spatial

var overlay_material		# Shader to use when crosshair is on the interactable
export(Resource) var interactable
# hover text label is a simple scene with only a label. It shows the name of the interactable
export (PackedScene) var hover_text_scene = preload("res://_Game/Scenes/UI/UI_hover_text_label.tscn")
onready var collision_shape  = $StaticBody/CollisionShape
onready var main_menu = $"../../UI_MainMenu"
onready var HUD = $"../../HUD"
# Empty resources are shown when interactable doesn't have any resource added. 
var empty_device_resource = preload("res://_Game/Resources/dev_empty_device_info.tres")
var empty_item_resource = preload("res://_Game/Resources/itm_empty_item_info.tres")
var mesh_instance
var menu
var hover_text
var hover_text_position
var in_focus = false
var static_body
var game_manager
var animation

 
# Called when the node enters the scene tree for the first time.
func _ready():
	# Select which menu to show based on interactable's group
	if self.is_in_group("Device"):
		menu = get_node("/root/FabLab/UI_DeviceInfoMenu")
	elif self.is_in_group("Item"):
		menu = get_node("/root/FabLab/UI_ItemInfoMenu")
	# For possible future use. Only debug stuff currently
	game_manager = get_node("/root/FabLab")	
	static_body = get_node("StaticBody")
	
	# connect signals that are emitted when mouse enters and exits static body
	# FPSController emits same signals when objectSelect raycast is colliding with static body
	# Mouse over is currently used only while debugging, but may be useful if
	# different movement controls are added.
	static_body.connect("mouse_entered", self, "enter_focus")
	static_body.connect("mouse_exited", self, "exit_focus")	
	
	#   Find MeshInstance and add it to ItemInfo-resource and get highlight shader 
	### TODO: FIX to not use MeshInstance
	for child in get_children():
		if child is MeshInstance:
			overlay_material = child.get_material_overlay()
			#if overlay_material == null:
				#HUD.append_debugtext("No overlay material (highlight shader)")
			child.set_material_overlay(null)
			mesh_instance = child
			if self.is_in_group("Item"):
				interactable.mesh_instance = child
			break
			
	# if interactable doesn't have DeviceInfo- or ItemInfo-resource add empty-resource that
	# notifies to add a correct one. 
	if interactable == null:
		if self.is_in_group(("Device")):
			HUD.append_debugtext("Empty device")
			interactable = empty_device_resource
		elif self.is_in_group("Item"):
			HUD.append_debugtext("Empty")
			interactable = empty_item_resource
			
	set_hover_text()

# this function is called when mouse or crosshair is over the interactable
func enter_focus():
	in_focus = true
	hover_text.visible = true
	play_animation()
	if overlay_material:
		mesh_instance.set_material_overlay(overlay_material)	
	else:
		HUD.append_debugtext("Hovered object has no overlay material")

# THis function is called when mouse or crosshair moves away from the interactable
func exit_focus():
	in_focus = false
	mesh_instance.set_material_overlay(null)
	hover_text.visible = false


func _input(_event):
	if main_menu.visible:			#Do not read mouse clicks here if main menu is visible
		in_focus = false
	if in_focus:
		if Input.is_action_just_pressed("mouse_click"):
			# Reveal mouse pointer to interact with the menu
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			#print_debug("Clicked interactable!")
			# initialize menu with interactable's information
			menu.init(interactable)
			# set in_focus false to prevent re-click when closing menu
			in_focus = false

# Initializes and show interactable name hovering over the interactable
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
	
func play_animation():
	animation = get_node_or_null("AnimationPlayer")
	if animation:
		print_debug("Animation detected!")
		if interactable.animationNames:
			$AnimationPlayer.play(interactable.animationNames[0])
