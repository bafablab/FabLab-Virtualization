extends ViewportContainer

onready var item = $Viewport/Spatial/Item
onready var mesh_instance = $Viewport/Spatial/Item/MeshInstance
onready var camera = $Viewport/Spatial/Camera
var mouse_sensitivity = 1
var min_distance = 0.09 # Minimum camera distance from object
var max_distance = 1 # and maximum

func _ready():
	pass

func init(mesh):
	mesh_instance.mesh = mesh.mesh
	item.transform.basis = Basis()
	camera.translation = Vector3(0,0,0.3)

func _input(event):
	if(is_visible_in_tree()):
		if event is InputEventMouseMotion:
			if Input.is_action_pressed("mouse_click"):
				item.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
				item.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
			elif Input.is_action_pressed("right_mouse_click"):
				camera.transform.origin.z += event.relative.y * mouse_sensitivity * 0.005
		elif event is InputEventMouseButton:
			if Input.is_action_pressed("mouse_wheel_up"):
				camera.transform.origin.z -= 0.1
			elif Input.is_action_pressed("mouse_wheel_down"):
				camera.transform.origin.z += 0.1
		
		# Prevent zooming too far or too close
		if camera.transform.origin.z < min_distance:
			camera.transform.origin.z = min_distance
		elif camera.transform.origin.z > max_distance:
			camera.transform.origin.z = max_distance
