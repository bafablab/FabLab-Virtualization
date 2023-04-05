extends Container

onready var video_list = $HBoxContainer
var device
var video_number

func _ready():
	var size=get_viewport().size
	$Video.stream=device.videos[video_number]
	$Video.play()
	print_debug($Video.get_stream_name())

func init(dev, vid_num):
	device = dev
	video_number = vid_num
	var video_list = get_child(0)
	for i in range(len(device.videos)):
		var button = Button.new()
		# info_text[n] (n>0) is formatted as "Button text|Description text
		var video_texts = device.info_text[i+1].split("|")
		button.text = "Video " + str(i+1)
		video_list.add_child(button)

func _on_Video_finished():
	$Video.paused=true
	
	
