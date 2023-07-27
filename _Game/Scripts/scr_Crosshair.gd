extends Control

onready var tooltip = $TooltipBackground/Tooltip
onready var tooltipbg = $TooltipBackground
onready var tooltipicon = $TooltipBackground/MouseClick
onready var tooltips_enabled = true

func _input(_event):
	# Enable/disable tooltips
	if Input.is_action_just_pressed("toggle_tooltips"):
		if tooltips_enabled:
			tooltips_enabled = false
		else:
			tooltips_enabled = true

func _physics_process(_delta):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		self.visible = true
	else:
		self.visible = false
	
	if tooltip.text && tooltips_enabled:
		tooltipbg.show()
		tooltipicon.show()
	else:
		tooltipbg.hide()
		tooltipicon.hide()
		
func show_tooltip(text):
	tooltip.set_text(text)
	
func clear_tooltip():
	if tooltip.text:
		tooltip.set_text("")
