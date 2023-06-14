extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	#hide_all()
	show_hud(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Toggle HUD visibility
func toggle_hud():
	if $TaskText.visible && $HelpText.visible:
		hide_all()
	else:
		show_hud(true)

# Show HUD elements, and DebugText too if parameter is true
func show_hud(debug):
	show_tasktext()
	$HelpText.show()
	if debug:
		$DebugText.show()

# Hide all HUD elements
func hide_all():
	hide_tasktext()
	$HelpText.hide()
	$DebugText.hide()
	
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
	$HelpText.bbcode_text =""

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
