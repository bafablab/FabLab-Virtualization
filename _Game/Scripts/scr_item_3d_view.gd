extends ViewportContainer

onready var item = $Viewport/Spatial/Item
onready var mesh_instance = $Viewport/Spatial/Item/MeshInstance
var mouse_sensitivity = 1

func _ready():
	pass

func init(mesh):
	mesh_instance.mesh = mesh.mesh

func _input(event):
	if(is_visible_in_tree()):
		if event is InputEventMouseMotion:
			if Input.is_action_pressed("mouse_click"):
				item.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
				item.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity ))
