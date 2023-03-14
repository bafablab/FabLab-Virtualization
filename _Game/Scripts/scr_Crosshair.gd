extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		self.visible = true
	else:
		self.visible = false
