extends Resource

class_name DeviceInfo

export(String) var name
export(String) var generic_name
export(String, MULTILINE) var info_text
export(String, MULTILINE) var details_text
export(Array, VideoStream) var videos
export(Array, String, MULTILINE) var video_titles
export(Array, String, MULTILINE) var video_descriptions
export(Image) var device_image
export(Array, Resource) var example_items
export(Array, String) var animationNames
#enum device_type_enum {PRINTER, LASERCUTTER, VINYLCUTTER, MILL, EMBROIDERY, ANOTHER_THING = -1}
#export(device_type_enum) var device_type
