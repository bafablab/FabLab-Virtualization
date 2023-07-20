extends RigidBody

# For accessing the HUD and tooltips
onready var HUD = get_node("/root/FabLab/HUD")
onready var crosshair = get_node("/root/FabLab/UI_Crosshair")

# Modify the grab force for a more fluid or more rigid hold force, default is 20
const GRAB_FORCE = 20
var linear_vel = null

var in_focus = false

func _ready():
	# For when mouse is hovering over this object
# warning-ignore:return_value_discarded
	self.connect("mouse_entered", self, "enter_focus")
# warning-ignore:return_value_discarded
	self.connect("mouse_exited", self, "exit_focus")	
	
	# For collisions with other objects
# warning-ignore:return_value_discarded
	self.connect("body_entered", self, "pickup_body_entered")
# warning-ignore:return_value_discarded
	self.connect("body_exited", self, "pickup_body_exited")
	
	# For sleep state changes
# warning-ignore:return_value_discarded
	self.connect("sleeping_state_changed", self, "pickup_sleeping_state_changed")	

func enter_focus():
	in_focus = true
	HUD.append_debugtext("Mouse on pickup object " + self.name)
	
func exit_focus():
	in_focus = false
	crosshair.clear_tooltip()
	
func _input(_event):
	if in_focus:
		# Only show tooltip when NOT dragging the object
		if !Input.is_action_pressed("mouse_click"):
			crosshair.show_tooltip(tr("TOOLTIP_GRAB"))
		else:
			crosshair.clear_tooltip()

# Functions for handling the movement of this object.

# Custom force integrator
func _integrate_forces(state):
	if linear_vel != null:
		state.linear_velocity = linear_vel * GRAB_FORCE

func update_velocity(lv):
	linear_vel = lv

# Report sleep mode changes to debug
func pickup_sleeping_state_changed():
	if self.sleeping:
		HUD.append_debugtext("Pickup object " + self.name + " sleeping")
	else:
		HUD.append_debugtext("Pickup object " + self.name + " awake")

# Prevent sleep if in collision with a possible moving object (is in group Mover) such as a door or a moving table
# Deal also with collisions with interactable devices and items
func pickup_body_entered(body):
	
	# Most devices and static items are structured with a Spatial as a root node and that has the script and group information
	var parent = body.find_parent("*")
	
	# But doors and the moving table have the group set to their StaticBody
	if body.is_in_group("Mover"):
		HUD.append_debugtext(self.name + " collided with a Mover, can_sleep = false")
		self.can_sleep = false
	# For dealing with collisions with devices in the future
	elif parent.is_in_group("Device"):
		HUD.append_debugtext(self.name + " collided with " + tr(parent.interactable.name))
	# For dealing with collisions with static interactable items
	elif parent.is_in_group("Item"):
		HUD.append_debugtext(self.name + " collided with " + tr(parent.interactable.name))

# When exiting a Mover, turn ability to sleep back on
func pickup_body_exited(body):
	if body.is_in_group("Mover"):
		HUD.append_debugtext(self.name + " exited a Mover, can_sleep = true")
		self.can_sleep = true
