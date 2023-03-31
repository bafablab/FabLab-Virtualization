extends Control

export (String) var label_str
export (PackedScene) var videoplayer = preload("res://test/Scenes/UI/VideoPlayer_test_scene_1.tscn")
var videoplayer_scene
onready var menu_window = $VBoxContainer
onready var tab_container = $VBoxContainer/Panel/TabContainer
onready var device_name_label = $VBoxContainer/Panel/NameLabel
onready var info_text = $VBoxContainer/Panel/TabContainer/Panel/InfoText
var device
var inFocus

# Called when the node enters the scene tree for the first time.
#func _ready():
	
	
func init(dev):
	device = dev
	device_name_label.text = device.name
	tab_container.set_tab_title(0, "Tietoja")
	print_debug(("Device menu visible"))
	info_text.text = device.info_text[0]
	self.visible = true
	# Consumes the event so it is not triggered in other
	# scripts. For example close the window immidiately.
	get_tree().get_root().set_input_as_handled()
	
	
#func _on_Button2_focus_entered():
#	play_video()
#	label.rect_position.x +=10
#	label.rect_pivot_offset=rect_scale/2
#	label.rect_scale+=Vector2(0.05,0.05)
#
#func _on_Button2_focus_exited():
#	label.rect_position.x = pos_x_orig
#	label.rect_scale = scale_orig
#	label.rect_pivot_offset=Vector2(0,0)
#	if videoplayer_scene!=null:
#		videoplayer_scene.queue_free()

func play_video():
	create_video_panel()
	
func create_video_panel():
	videoplayer_scene=videoplayer.instance()
	videoplayer_scene.init(device)
	tab_container.add_child(videoplayer_scene)

func _on_english_pressed():
	TranslationServer.set_locale("en")	

func _on_finnish_pressed():
	TranslationServer.set_locale("fi")

func _on_mouse_entered():
	inFocus = true

func _on_mouse_exited():
	inFocus = false

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		var evLocal = make_input_local(event)
		if !Rect2(menu_window.rect_position, menu_window.rect_size).has_point(evLocal.position):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			self.visible = false
		
