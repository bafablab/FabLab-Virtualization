extends ViewportContainer

onready var item = $Viewport/Spatial/Item
onready var mesh_instance = $Viewport/Spatial/Item/MeshInstance
onready var camera = $Viewport/Spatial/Camera
export var mouse_sensitivity = 1
var min_camera_distance = 0.09 # Minimum camera distance from object
var max_camera_distance = 0.5 # and maximum
var max_camera_x = 0.25 # Limits to camera movement
var max_camera_y = 0.25

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
			elif Input.is_action_pressed("middle_mouse_click"):
				camera.transform.origin.y += event.relative.y * mouse_sensitivity * 0.003
				camera.transform.origin.x += -event.relative.x * mouse_sensitivity * 0.003
		elif event is InputEventMouseButton:
			if Input.is_action_pressed("mouse_wheel_up"):
				camera.transform.origin.z -= 0.1
			elif Input.is_action_pressed("mouse_wheel_down"):
				camera.transform.origin.z += 0.1
		
		# Prevent zooming too far or too close
		if camera.transform.origin.z < min_camera_distance:
			camera.transform.origin.z = min_camera_distance
		elif camera.transform.origin.z > max_camera_distance:
			camera.transform.origin.z = max_camera_distance
			
		if camera.transform.origin.x < -max_camera_x:
			camera.transform.origin.x = -max_camera_x
		elif camera.transform.origin.x > max_camera_x:
			camera.transform.origin.x = max_camera_x
			
		if camera.transform.origin.y < -max_camera_y:
			camera.transform.origin.y = -max_camera_y
		elif camera.transform.origin.y > max_camera_y:
			camera.transform.origin.y = max_camera_y
		
		
