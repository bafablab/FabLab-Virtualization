extends Resource

class_name ItemInfo

export(String) var name
export(String) var infoText
export(Image) var itemImage
enum itemTypeEnum {PRINT, LASERCUT, VINYLCUT, MILLED, EMBROIDERY, ANOTHER_THING = -1}
export(itemTypeEnum) var itemType
