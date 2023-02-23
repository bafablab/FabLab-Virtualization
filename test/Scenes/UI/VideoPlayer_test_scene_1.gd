extends Container
#var videofile=load("res://test/Video/test files/V208 WEBM - VP8 1080p 24fps 8bit - VORBIS2.0.webm")

func _ready():
	var size=get_viewport().size
	print_debug("Viewport size is" + str(size))
	rect_size=size/4
	rect_position=size/4
	print_debug("Container size: " + str(rect_size))
	print_debug("Container position: " + str(rect_position))
	#example=VideoStreamWebm.new()
	#example.s
	#$Video.stream=VideoStreamWebm.new().set_file(videofile)
	#$Video.stream=load("res://test/Video/test files/V208 WEBM - VP8 1080p 24fps 8bit - VORBIS2.0.webm")
	
	$Video.stream=load("res://test/Video/test files/media-source_webm_test-vp9.webm")
	$Video.play()
	print_debug($Video.get_stream_name())


func _on_Video_finished():
	$Video.play()
	$Video.stream_position=0.5
	$Video.paused=true
	
	
