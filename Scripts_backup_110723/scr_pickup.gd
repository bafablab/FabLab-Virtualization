extends RigidBody

var collision_pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var collision_amount
onready var rigid_body = self
onready var HUD = get_node("/root/FabLab/HUD")
onready var player = get_node("/root/FabLab/FPSController")
onready var holdposition = get_node("/root/FabLab/FPSController/Head/Camera/HoldPosition")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered", self, "pickup_body_entered")
	self.connect("body_exited", self, "pickup_body_exited")
	self.connect("sleeping_state_changed", self, "pickup_sleeping_state_changed")	

	
func _integrate_forces(state):
	collision_amount = state.get_contact_count()
	if collision_amount > 0:
		for index in collision_amount:
			if state.get_contact_collider_object(index) != player:
				if holdposition.translation.z <= -0.1:
					holdposition.translation.z = holdposition.translation.z + 0.1
					#print_debug("local collision:")
					#print_debug(holdposition.transform.origin)
			else:
				if holdposition.translation.z > -1:
					holdposition.translation.z = holdposition.translation.z - 0.1
	else:
		if holdposition.translation.z > -1:
			holdposition.translation.z = holdposition.translation.z - 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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