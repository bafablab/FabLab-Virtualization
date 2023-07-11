extends KinematicBody

# These variables are from the FPSController tutorial
export var speed = 10
export var h_acceleration = 6
export var gravity = 20
var jump = 10
var full_contact = false
var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()
export var mouse_sensitivity = 0.06
export var inverse_mouse = -1
onready var head = $Head
onready var ground_check = $GroundCheck
onready var object_select = $Head/ObjectSelect 		# raycast for detecting interactables
onready var camera = $Head/Camera
onready var holdposition = $Head/Camera/HoldPosition
var held_object : Object

# These variables are specific for the project
export var moving = true
var objects_in_range = []
var selected_object_transform
var targeted_object = null
var draggable_object = null
var dragging = false
onready var device_info_menu = get_node("/root/FabLab/UI_DeviceInfoMenu")
onready var item_info_menu = get_node("/root/FabLab/UI_ItemInfoMenu")
onready var main_menu = get_node("/root/FabLab/UI_MainMenu")
onready var welcome_window = get_node("/root/FabLab/UI_WelcomeWindow")
onready var HUD = get_node("/root/FabLab/HUD")
onready var crosshair = get_node("/root/FabLab/UI_Crosshair")
var draggable = false
var collision_pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var collisions

# Called when the node enters the scene tree for the first time.
#func _ready():
		

# Called when any input is detected
func _input(event):
	# Do not rotate the player when mouse is visible ie. some menu is open
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity * inverse_mouse))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))

	# Change mouse mode for debug. MOUSE_MODE_CAPTURED and MOUSE_MODE_VISIBLE - mouse_toggle currently "-"
	if Input.is_action_just_pressed("mouse_toggle"):
		toggle_mouse()


func _process(_delta):
	# disable player movement if any menu is visible and show mouse cursor
	if (main_menu.visible or item_info_menu.visible or device_info_menu.visible or welcome_window.visible):
		moving = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		moving = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#print_debug(moving)
	

func _physics_process(delta):
	# Check if interactable objects in range
	if objects_in_range.size() > 0 and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# enable object_select raycast if objects near
		if !object_select.enabled:
			object_select.enabled = true
		if object_select.is_colliding():
			# Do not emit signal again if targeted object hasn't changed
			if object_select.get_collider() != targeted_object:
				if targeted_object != null:
					# unselect previous interactable
					targeted_object.emit_signal("mouse_exited")		# same signal than godot's own mouse cursor
				
				# select currently targeted object
				object_select.get_collider().emit_signal("mouse_entered")
				targeted_object = object_select.get_collider()
					
				#print_debug(targeted_object, object_select.get_collider())
				if targeted_object.is_in_group(("Draggable")):							
					draggable_object = targeted_object
					draggable = true
					HUD.append_debugtext("Mouse on draggable")
				else:
					if !dragging:
						draggable = false
		else:
			# clear targeted object if raycast isn't colliding and unselect it
			if targeted_object != null:
				targeted_object.emit_signal("mouse_exited")
				targeted_object = null
				crosshair.clear_tooltip()
			#print_debug("object_detected")
	# if no interactable objects in range, disable object_select raycast. 
	else:
		if object_select.enabled:
			object_select.enabled = false
	# ------- Object selection code ends -------
	
	if draggable_object && draggable == true:
		# Drag object when mouse button is down
		if Input.is_action_pressed("mouse_click"):
			dragging = true
			draggable_object.mode = RigidBody.MODE_RIGID
			draggable_object.sleeping = false
			#draggable_object.connect("body_entered", self, "pickup_collision")
			#HUD.append_debugtext("Holding object")
			crosshair.clear_tooltip()
		else:
			dragging = false
		
		# Throwing object
		if Input.is_action_just_pressed("right_mouse_click"):
			if draggable_object != null and dragging == true:
				#draggable_object.mode = RigidBody.MODE_RIGID
				#draggable_object.collision_mask = 1
				#draggable_object.set_collision_layer_bit(0, true)
				HUD.append_debugtext("Throwing object")
				var throwdirection = self.get_transform().basis.z
				draggable_object.add_central_force(throwdirection * -500)
				dragging = false
				draggable = false
			
		if dragging == true:
			draggable_object.contact_monitor = true
			draggable_object.global_transform.origin = holdposition.global_transform.origin
	
	# Movement code from tutorial
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
		h_velocity = Vector3.ZERO # stop player if any menu is open

func pickup_collision(body):
	pass

# Add nearby intaractables to a list
func _on_Area_body_entered(body):
	objects_in_range.append(body)
#	print(objects_in_range)

func _on_Area_body_exited(body):
	objects_in_range.erase(body)
#	print(objects_in_range)

# toggle mouse mode for debug purposes
func toggle_mouse():	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
