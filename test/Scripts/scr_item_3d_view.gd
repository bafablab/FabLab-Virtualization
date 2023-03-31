extends ViewportContainer

onready var item = $Viewport/Spatial/Item
#var mesh_instance

func _ready():
	pass

func init(mesh):
	print_debug(mesh)
	var mesh_instance = MeshInstance.new()
	mesh_instance.mesh = mesh.mesh
	item.add_child(mesh_instance)
