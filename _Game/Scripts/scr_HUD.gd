extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all()
	show_controlshelp()
	#show_hud(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# warning-ignore:unused_argument
func _input(event):
		# Toggles debug text visibility
	if Input.is_action_just_pressed("toggle_debug"):
		toggle_debug()
		
	# Toggle whole HUD visibility
	if Input.is_action_just_pressed("toggle_hud"):
		toggle_hud()
		
	# Toggle controls help visibility
	if Input.is_action_just_pressed("toggle_controlshelp"):
		toggle_controlshelp()
	
	if Input.is_action_just_pressed("toggle_fps"):
		toggle_fps()

func _process(_delta: float) -> void:
	$FPS.set_text("FPS " + String(Engine.get_frames_per_second()))

# Toggle HUD visibility
func toggle_hud():
	if $TaskText.visible && $HelpText.visible:
		hide_all()
	else:
		show_hud(true)
		
# Toggle FPS visibility
func toggle_fps():
	if $FPS.visible:
		$FPS.hide()
	else:
		$FPS.show()

# Show HUD elements, and DebugText too if parameter is true
func show_hud(debug):
	show_tasktext()
	$HelpText.show()
	show_controlshelp()
	if debug:
		$DebugText.show()

# Hide all HUD elements
func hide_all():
	hide_tasktext()
	$HelpText.hide()
	hide_controlshelp()
	$DebugText.hide()
	$FPS.hide()
	
# Clear all HUD texts
func clear_all():
	clear_tasktext()
	clear_helptext()
	clear_debugtext()

# Show tasktext and its background
func show_tasktext():
	$TaskText.show()
	$TaskTextBackground.show()

# Hide tasktext and its background
func hide_tasktext():
	$TaskText.hide()
	$TaskTextBackground.hide()

# Set and clear methods for tasktext
func set_tasktext(text):
	$TaskText.bbcode_text = text
	
func clear_tasktext():
	$TaskText.bbcode_text = ""
	
# Set and clear methods for helptext
func set_helptext(text):
	$HelpText.bbcode_text = text

func clear_helptext():
	$HelpText.bbcode_text = ""
	
func toggle_controlshelp():
	if $ControlsHelp.visible:
		hide_controlshelp()
	else:
		show_controlshelp()
	
func show_controlshelp():
	$ControlsHelp.show()

func hide_controlshelp():
	$ControlsHelp.hide()

func toggle_debug():
	if $DebugText.visible:
		$DebugText.hide()
	else:
		$DebugText.show()

# Set and clear methods for debugtext
func set_debugtext(text):
	$DebugText.bbcode_text = text

func clear_debugtext():
	$DebugText.bbcode_text = ""
	
# Appends the debug text window and autoscrolls it to bottom
func append_debugtext(text):
	$DebugText.append_bbcode("\n" + text)
	$DebugText.scroll_to_line($DebugText.get_line_count() - 1)
