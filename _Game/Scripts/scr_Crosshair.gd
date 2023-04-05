extends Label

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		self.visible = true
	else:
		self.visible = false
