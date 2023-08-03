extends ViewportContainer

onready var item = $Viewport/Spatial/Item
onready var mesh_instance = $Viewport/Spatial/Item/MeshInstance
onready var camera = $Viewport/Spatial/Camera
export var mouse_sensitivity = 1
var min_camera_distance = 0.09 # Minimum camera distance from object
var max_camera_distance = 0.5 # and maximum
var max_camera_x = 0.25 # Limits to camera movement
var max_camera_y = 0.25
var default_basis = Basis()
var input_allowed = false # Connected to a 0.5 sec timer to prevent accidental item rotation on opening 3d view

func _ready():
	pass

func init(mesh):
	mesh_instance.mesh = mesh.mesh
	default_basis.x = Vector3(1, 0, 0) # Vector pointing along the X axis
	default_basis.y = Vector3(0, 1, 0) # Vector pointing along the Y axis
	default_basis.z = Vector3(0, 0, 1) # Vector pointing along the Z axis
	item.transform.basis = default_basis
	camera.translation = Vector3(0,0,0.3)

func _input(event):
	if(is_visible_in_tree() and input_allowed):
		if event is InputEventMouseMotion:
			if Input.is_action_pressed("mouse_click"):
				item.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
				item.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
			elif Input.is_action_pressed("right_mouse_click"):
				camera.transform.origin.z += event.relative.y * mouse_sensitivity * 0.005
			elif Input.is_action_pressed("middle_mouse_click"):
				camera.transform.origin.y += event.relative.y * mouse_sensitivity * 0.003
				camera.transform.origin.x += -event.relative.x * mouse_sensitivity * 0.003
		
		if event is InputEventMouseButton:
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
		

func _process(_delta):
	if(is_visible_in_tree() and input_allowed):
		# Rotate the object with a gamepad
		if Input.get_joy_axis(0, 2) < -0.3 or Input.get_joy_axis(0, 2) > 0.3:
			item.rotate_y(deg2rad( Input.get_joy_axis(0, 2) * 3))
		if Input.get_joy_axis(0, 3) < -0.3 or Input.get_joy_axis(0, 3) > 0.3:
			item.rotate_x(deg2rad( Input.get_joy_axis(0, 3) * 3))
			
		# Zooming with a gamepad
		if Input.get_joy_axis(0, 1) < -0.3:
			camera.transform.origin.z -= 0.01
		if Input.get_joy_axis(0, 1) > 0.3:
			camera.transform.origin.z += 0.01

# These functions and the timer prevent accidental rotation of the item on the moment of opening the 3d view

func _on_NoInputTimer_timeout():
	input_allowed = true

func _on_Item3DView_visibility_changed():
	if self.visible:
		input_allowed = false
		$NoInputTimer.start()
