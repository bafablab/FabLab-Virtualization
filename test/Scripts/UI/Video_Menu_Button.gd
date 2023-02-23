extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (String) var label_str
export (PackedScene) var videoplayer = preload("res://test/Scenes/UI/VideoPlayer_test_scene_1.tscn")
var videoplayer_scene
onready var label = $Label
onready var pos_x_orig=label.rect_position.x
onready var scale_orig=label.rect_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
	add_child(videoplayer_scene)
	#$self/Panel.rect_size_x=4
	#print_debug($self.get_children())
	#print_debug(get_children())
	#print_debug($Panel.get_children())
	#$Container.rect_size_x=1
	
	pass
