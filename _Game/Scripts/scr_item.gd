extends Spatial

var overlay_material
export(Resource) var item
export (PackedScene) var itemInfoScene = preload("res://test/Scenes/UI/UI_item_info_scene.tscn")
export (PackedScene) var itemLabel = preload("res://_Game/Scenes/UI/UI_ItemLabel.tscn")
onready var collisionShape  = $StaticBody/CollisionShape
onready var hoverText = $HoverTextPosition
var inFocus = false
var staticBody
var infoLabel
var gameManager
 
# Called when the node enters the scene tree for the first time.
func _ready():
	gameManager = get_node("/root/FabLab")
	print_debug(gameManager)
	infoLabel = itemLabel.instance()
	staticBody = get_node("StaticBody")
	staticBody.connect("mouse_entered", self, "enter_focus")
	staticBody.connect("mouse_exited", self, "exit_focus")
	set_infoLabel()
	overlay_material = get_child(0).get_material_overlay()
	get_child(0).set_material_overlay(null)

func enter_focus():
	inFocus = true
	infoLabel.visible = true
	get_child(0).set_material_overlay(overlay_material)	

func exit_focus():
	inFocus = false
	get_child(0).set_material_overlay(null)
	infoLabel.visible = false

func _input(_event):
	if inFocus:
		if Input.is_action_just_pressed("mouse_click"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			var infoScene=itemInfoScene.instance()
			infoScene.init(item)
			self.add_child(infoScene)
			# set inFocus false to prevent re-click when closing menu
			inFocus = false

func set_infoLabel():
	self.add_child(infoLabel)
	infoLabel.text = item.name
	if hoverText:
		infoLabel.transform.origin = hoverText.transform.origin
	else:
		infoLabel.global_transform.origin.y += collisionShape.shape.extents.y + 0.2
	infoLabel.visible = false
