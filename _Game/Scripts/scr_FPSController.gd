extends KinematicBody

# Variables for moving the player
export var speed = 2 # maximum walking speed of the player
export var runspeed = 5 # maximum running speed
export var h_acceleration = 6 # rate of acceleration
export var gravity = 20
var jump = 5 # Jumping force, not currently used
var full_contact = false
var currentspeed
var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

# Set mouse behavior here
export var mouse_sensitivity = 0.06
export var inverse_mouse = -1

onready var head = $Head
onready var ground_check = $GroundCheck
onready var object_select = $Head/ObjectSelect 		# raycast for detecting interactables
onready var grabber = $Head/Grabber # raycast for picking up objects, think of it as an invisible hand
onready var camera = $Head/Camera
onready var holdposition = $Head/Camera/HoldPosition # position where a picked up object is held

export var moving = true # for enabling/disabling movement

# Variables for interacting with objects
var selected_object_transform
var targeted_object = null

# Variables for picking up items
var grabbed_item = null
var grabbed_item_rel_pos

# UI windows, HUD and crosshair
onready var device_info_menu = get_node("/root/FabLab/UI_DeviceInfoMenu")
onready var item_info_menu = get_node("/root/FabLab/UI_ItemInfoMenu")
onready var generic_info_menu = get_node("/root/FabLab/UI_generic_info_menu")
onready var main_menu = get_node("/root/FabLab/UI_MainMenu")
onready var welcome_window = get_node("/root/FabLab/UI_WelcomeWindow")
onready var HUD = get_node("/root/FabLab/HUD")
onready var crosshair = get_node("/root/FabLab/UI_Crosshair")

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


# Normal process, runs every frame
func _process(_delta):
	# disable player movement if any menu is visible and show mouse cursor
	if (main_menu.visible or item_info_menu.visible or device_info_menu.visible or generic_info_menu.visible or welcome_window.visible):
		moving = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		moving = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

# Physics process, runs all the time unless game is paused, not connected to FPS
func _physics_process(delta):
	
	# ------- Object selection code begins -------
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if object_select.is_colliding():
			# Do not emit signal again if targeted object hasn't changed
			if object_select.get_collider() != targeted_object:
				if targeted_object != null:
					# unselect previous interactable
					targeted_object.emit_signal("mouse_exited")		# same signal than godot's own mouse cursor
				
				# select currently targeted object
				object_select.get_collider().emit_signal("mouse_entered")
				targeted_object = object_select.get_collider()
					
		else:
			# clear targeted object if raycast isn't colliding and unselect it
			if targeted_object != null:
				targeted_object.emit_signal("mouse_exited")
				targeted_object = null
				crosshair.clear_tooltip()
	# ------ Object selection code ends ------- 

	
	# ------- Handle item grabbing --------
	handle_grabber()
	
	# ----- Movement code begins ------
	# Movement code from tutorial
	direction = Vector3()
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	# Keeps the player on the ground
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
	else:
		gravity_vec = -get_floor_normal()
	
	if moving:
		if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
			gravity_vec = Vector3.UP * jump
		if Input.is_action_pressed("move_forward"):
			direction -= transform.basis.z
		elif Input.is_action_pressed("move_backward"):
			direction += transform.basis.z
		if Input.is_action_pressed("move_left"):
			direction -= transform.basis.x
		elif Input.is_action_pressed("move_right"):
			direction += transform.basis.x
		direction = direction.normalized()
		
		# Change speed if running or not
		if Input.is_action_pressed("run"):
			currentspeed = runspeed
		else:
			currentspeed = speed
		
		h_velocity = h_velocity.linear_interpolate(direction * currentspeed, h_acceleration * delta)
		
		movement.z = h_velocity.z + gravity_vec.z
		movement.x = h_velocity.x + gravity_vec.x
		movement.y = gravity_vec.y
		
# warning-ignore:return_value_discarded
		move_and_slide(movement, Vector3.UP)
	else:
		h_velocity = Vector3.ZERO # stop player if any menu is open
	# ------ Movement code ends ------

# ------ Object picking/throwing functions begin ------
# Called all the time from the physics process
func handle_grabber():
	if grabbed_item == null:
		on_empty_grabber()
	else:
		on_full_grabber()

# If the grabber raycast collides with a object that can be picked up, do so
func on_empty_grabber():
	var collision_object = grabber.get_collider()
	if collision_object != null:
		on_grabber_collision(collision_object)

# Holds the picked up object in the specified hold position
func on_full_grabber():
	var expected_translation = $Head.to_global(holdposition.translation) # Was: $Head.to_global(grabbed_item_rel_pos), This would make the holding distance what it was when the object was clicked, the object doesn't move toward the player
	var linear_vel = expected_translation - grabbed_item.translation
	grabbed_item.update_velocity(linear_vel)
	if !Input.is_action_pressed("mouse_click"):
		let_go();
# TODO: Throwing
#	if Input.is_action_just_pressed("right_mouse_click"):
#		HUD.append_debugtext("Throwing!")
#		throw()

# Drop the picked up object
func let_go():
	grabbed_item.update_velocity(null)
	grabbed_item = null

# TODO: Throwing
#func throw():
#	if grabbed_item != null:
#		var knockback = grabbed_item.translation - translation
#		grabbed_item.apply_central_impulse(knockback * 10)
#		grabbed_item = null

# Picks up the object in the grabber raycast
func on_grabber_collision(collision_object):
	if can_be_picked(collision_object):
		if Input.is_action_pressed("mouse_click"):
			#grabbed_item_rel_pos = $Head.to_local(collision_object.translation) # Use if a preset hold position is not used, check on_full_grabber()
			grabbed_item = collision_object
			grabbed_item.set_sleeping(false)

# Checker if targeted object is a pickable object (has scr_pickup.gd attached)
func can_be_picked(object):
	return object.has_method("update_velocity")
	
	
# ------ Object picking/throwing functions end ------

# toggle mouse mode for debug purposes
func toggle_mouse():	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
