extends Control

export (String) var label_str
export (PackedScene) var videoplayer = preload("res://test/Scenes/UI/VideoPlayer_test_scene_1.tscn")
var videoplayer_scene
onready var panel = $Panel
onready var label = $Panel/Button2/Label
onready var pos_x_orig=label.rect_position.x
onready var scale_orig=label.rect_scale
var device
var inFocus

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = device.model
	
func init(dev):
	device = dev

func _on_Button2_focus_entered():
	play_video()
	label.rect_position.x +=10
	label.rect_pivot_offset=rect_scale/2
	label.rect_scale+=Vector2(0.05,0.05)
	
func _on_Button2_focus_exited():
	label.rect_position.x = pos_x_orig
	label.rect_scale = scale_orig
	label.rect_pivot_offset=Vector2(0,0)
	if videoplayer_scene!=null:
		videoplayer_scene.queue_free()

func play_video():
	create_video_panel()
	
func create_video_panel():
	videoplayer_scene=videoplayer.instance()
	videoplayer_scene.init(device)
	panel.add_child(videoplayer_scene)

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
		if !Rect2(panel.rect_position,panel.rect_size).has_point(evLocal.position):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			queue_free()
		
