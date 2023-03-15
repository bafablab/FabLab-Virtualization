extends Resource

class_name DeviceInfo

export(String) var model
export(Array, VideoStream) var videos
export(Array, String) var infoText
export(Image) var deviceImage
enum deviceTypeEnum {PRINTER, LASERCUTTER, VINYLCUTTER, MILL, EMBROIDERY, ANOTHER_THING = -1}
export(deviceTypeEnum) var deviceType
