extends Container

#onready var video_list = $HBoxContainer
onready var video_player = $Panel/Video
export var default_video_width = 800
var device
var video_number
var device_info_menu


func _ready():
	#var size=get_viewport().size
	play_video()
	

func init(dev, vid_num, dev_menu):
	device = dev
	video_number = vid_num
	device_info_menu = dev_menu
	var video_list = get_child(0)
	for i in range(len(device.videos)):
		var button = Button.new()
		button.text = "Video " + str(i+1)
		button.connect("pressed", self, "_button_pressed", [i])
		video_list.add_child(button)
	var button = Button.new()
	button.text = "X"
	button.connect("pressed", self, "_button_pressed_x")
	video_list.add_child(button)

func _button_pressed(video):
	video_number = video
	play_video()

func _button_pressed_x():
	get_parent().remove_child(self)
	self.queue_free()
	device_info_menu.videoplayer_scene = null
	
func play_video():
	video_player.stream=device.videos[video_number]
	var texture = video_player.get_video_texture()
	var video_dimensions = texture.get_size()
	var video_scale = default_video_width / video_dimensions[0]
	video_player.rect_scale.x = video_scale
	video_player.rect_scale.y = video_scale
	video_player.play()
