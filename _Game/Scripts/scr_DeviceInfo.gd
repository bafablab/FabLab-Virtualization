extends Resource

class_name DeviceInfo

export(String) var name
export(Array, VideoStream) var videos
export(Array, String, MULTILINE) var info_text
export(Image) var device_image
enum device_type_enum {PRINTER, LASERCUTTER, VINYLCUTTER, MILL, EMBROIDERY, ANOTHER_THING = -1}
export(device_type_enum) var device_type
