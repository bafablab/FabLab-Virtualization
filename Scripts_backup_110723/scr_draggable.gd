extends RigidBody

onready var HUD = get_node("/root/FabLab/HUD")
const GRAB_FORCE = 20
var linear_vel = null

func _ready():
	self.connect("body_entered", self, "pickup_body_entered")
	self.connect("body_exited", self, "pickup_body_exited")
	self.connect("sleeping_state_changed", self, "pickup_sleeping_state_changed")	

func _integrate_forces(state):
	if linear_vel != null:
		state.linear_velocity = linear_vel * GRAB_FORCE

func update_velocity(lv):
	linear_vel = lv
	
func pickup_sleeping_state_changed():
	if self.sleeping:
		HUD.append_debugtext("Pickup object " + self.name + " sleeping")
	else:
		HUD.append_debugtext("Pickup object " + self.name + " awake")

func pickup_body_entered(body):
	
	# Prevent sleep if in collision with a possible moving object (is in group Mover) such as a door or a moving table
	if body.is_in_group("Mover"):
		HUD.append_debugtext("Pickup object collided with a Mover")
		self.can_sleep = false
		
	if player.dragging:
		if body.get_name() != "FPSController":
			pass

func pickup_body_exited(body):
	# When exiting a Mover, turn ability to sleep back on
	if body.is_in_group("Mover"):
		HUD.append_debugtext("Pickup object exited a Mover")
		self.can_sleep = true
