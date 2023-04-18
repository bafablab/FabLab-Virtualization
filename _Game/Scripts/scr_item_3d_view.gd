extends ViewportContainer

onready var item = $Viewport/Spatial/Item
onready var mesh_instance = $Viewport/Spatial/Item/MeshInstance
onready var camera = $Viewport/Spatial/Camera
var mouse_sensitivity = 1

func _ready():
	pass

func init(mesh):
	mesh_instance.mesh = mesh.mesh
	item.transform.basis = Basis()
	camera.translation = Vector3(0,0,2.9)

func _input(event):
	if(is_visible_in_tree()):
		if event is InputEventMouseMotion:
			if Input.is_action_pressed("mouse_click"):
				item.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
				item.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
			elif Input.is_action_pressed("right_mouse_click"):
				camera.transform.origin.z += -event.relative.y * mouse_sensitivity * 0.1
