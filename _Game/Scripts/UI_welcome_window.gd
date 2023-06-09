extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Add texts to header and textbox since Godot doesn't automatically translate text in the bbcode-field
	$VBoxContainer/Panel/WelcomeHeader.bbcode_text = "[center][b]" + tr("WELCOME_HEADER") + "[/b][/center]"
	$VBoxContainer/Panel/WelcomeText.bbcode_text = tr("WELCOME_TEXT")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
