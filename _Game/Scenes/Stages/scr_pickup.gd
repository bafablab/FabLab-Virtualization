extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_node("/root/FabLab/FPSController")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func pickup_body_entered(body):
	if player.dra
	if body.get_name() != "FPSController":
		print_debug("pickup collided with")
		print_debug(body.get_name())
		print_debug(body.transform.origin)
