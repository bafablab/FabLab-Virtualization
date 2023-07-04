extends Control

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		self.visible = true
	else:
		self.visible = false
		
func show_tooltip(text):
	$Tooltip.set_text(text)
	
func clear_tooltip():
	$Tooltip.set_text("")
