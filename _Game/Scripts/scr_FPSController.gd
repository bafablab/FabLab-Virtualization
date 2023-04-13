extends KinematicBody

var speed = 10
var h_acceleration = 6
var gravity = 20
var jump = 10
var full_contact = false

export var mouse_sensitivity = 0.06
export var object_rotation_scale = 2
export var inverse_mouse = -1
export var moving = true

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

var objects_in_range = []
var selected_object = null
var selected_object_transform
var targeted_object = null

onready var head = $Head
onready var ground_check = $GroundCheck
onready var object_select = $Head/ObjectSelect
onready var camera = $Head/Camera
var device_info_menu
var item_info_menu


func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	device_info_menu = get_node("/root/FabLab/UI_DeviceInfoMenu")
	item_info_menu = get_node("/root/FabLab/UI_ItemInfoMenu")
	
func _input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			if !selected_object:
				rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
				head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity * inverse_mouse))
				head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

	# Change mouse mode for debug
	toggle_mouse()
	
func _process(_delta):
	moving = !(item_info_menu.visible or device_info_menu.visible)
	
func _physics_process(delta):
	# Check if interactable objects in range
	if objects_in_range.size() > 0 and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if !object_select.enabled:
			object_select.enabled = true
		if object_select.is_colliding():
			# Do not emit signal again if targeted object hasn't changed
			if object_select.get_collider() != targeted_object:
				if targeted_object != null:
					targeted_object.emit_signal("mouse_exited")
				object_select.get_collider().emit_signal("mouse_entered")
				targeted_object = object_select.get_collider()
				print_debug(targeted_object, object_select.get_collider())
		else:
			if targeted_object != null:
				targeted_object.emit_signal("mouse_exited")
#				print_debug("no targeted object")
				targeted_object = null
			#print_debug("object_detected")
	# if no interactable objects in range, disable object_select raycast
	else:
		if object_select.enabled:
			object_select.enabled = false
		selected_object = null

	# ------- Object selection code ends -------
	
	direction = Vector3()
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
	else:
		gravity_vec = -get_floor_normal()
	

	if moving:
#		if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
#			gravity_vec = Vector3.UP * jump
		
		if Input.is_action_pressed("move_forward"):
			direction -= transform.basis.z
		elif Input.is_action_pressed("move_backward"):
			direction += transform.basis.z
		if Input.is_action_pressed("move_left"):
			direction -= transform.basis.x
		elif Input.is_action_pressed("move_right"):
			direction += transform.basis.x
			
		direction = direction.normalized()
		h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
		movement.z = h_velocity.z + gravity_vec.z
		movement.x = h_velocity.x + gravity_vec.x
		movement.y = gravity_vec.y
		
		move_and_slide(movement, Vector3.UP)
	else:
		h_velocity = Vector3.ZERO


func _on_Area_body_entered(body):
	objects_in_range.append(body)
#	print(objects_in_range)

func _on_Area_body_exited(body):
	objects_in_range.erase(body)
#	print(objects_in_range)
	
func _on_Area_area_entered(area):
	objects_in_range.append(area)
#	print(objects_in_range)

func _on_Area_area_exited(area):
	objects_in_range.erase(area)
#	print(objects_in_range)

func toggle_mouse():
	if Input.is_action_just_pressed("mouse_toggle"):
		TranslationServer.set_locale("fi")
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
