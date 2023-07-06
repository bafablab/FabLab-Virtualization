extends Control

onready var tooltip = $TooltipBackground/Tooltip
onready var tooltipbg = $TooltipBackground

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		self.visible = true
	else:
		self.visible = false
	
	if tooltip.text:
		tooltipbg.show()
	else:
		tooltipbg.hide()
		
func show_tooltip(text):
	tooltip.set_text(text)
	
func clear_tooltip():
	if tooltip.text:
		tooltip.set_text("")
