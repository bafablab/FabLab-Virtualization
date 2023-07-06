extends Spatial


export (PackedScene) var hover_text_scene = preload("res://_Game/Scenes/UI/UI_hover_text_label.tscn")
export(Resource) var interactable

onready var HUD = get_node("/root/FabLab/HUD")
onready var crosshair = get_node("/root/FabLab/UI_Crosshair")

onready var collision_shape  = $StaticBody/CollisionShape
var static_body
var hover_text
var in_focus = false
var door_open = false
var door_moving = false
var hover_text_position
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	static_body = get_node("StaticBody")
	
	# connect signals that are emitted when mouse enters and exits static body
	# FPSController emits same signals when objectSelect raycast is colliding with static body
	# Mouse over is currently used only while debugging, but may be useful if
	# different movement controls are added.
	static_body.connect("mouse_entered", self, "enter_focus")
	static_body.connect("mouse_exited", self, "exit_focus")	
	
	set_hover_text()
	
func enter_focus():
	in_focus = true
	crosshair.show_tooltip(tr("TOOLTIP_INTERACT"))
	HUD.append_debugtext("Mouse on " + self.name)
	if $AnimationPlayer.current_animation == "01_open_door":
		hover_text.visible = false
	else:
		hover_text.visible = true
	
func exit_focus():
	in_focus = false
	hover_text.visible = false
	crosshair.clear_tooltip()

func _input(_event):
	if in_focus:
		if Input.is_action_just_pressed("mouse_click") && !door_moving:
			if door_open == false:
				$AnimationPlayer.play("01_open_door")
				door_moving = true
				hover_text.visible = false
				door_open = true;
			else:
				$AnimationPlayer.play_backwards("01_open_door")	
				door_moving = true
				hover_text.visible = false			
				door_open = false;
			#in_focus = false
	
func set_hover_text():
	hover_text_position = get_node_or_null("HoverTextPosition")
	hover_text = hover_text_scene.instance()
	self.add_child(hover_text)
	hover_text.text = interactable.name
	if self.is_in_group("Door"):
		hover_text.text = interactable.name
	if hover_text_position:
		hover_text.transform.origin = hover_text_position.transform.origin
	else:
		hover_text.global_transform.origin.y += collision_shape.shape.extents.y + 0.2
	hover_text.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	door_moving = false
	hover_text.transform.origin = hover_text_position.transform.origin
	if in_focus:
		hover_text.visible = true
