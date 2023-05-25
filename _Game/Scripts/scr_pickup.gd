extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var holdposition
var collision_pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var collision_amount

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/FabLab/FPSController")
	holdposition = get_node("/root/FabLab/FPSController/Head/Camera/HoldPosition")
	
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


func pickup_body_entered(body):
	if player.dragging:
		if body.get_name() != "FPSController":
			pass
			#print_debug("pickup collided with")
			#print_debug(body.get_name())
			#print_debug(body.transform.origin)
