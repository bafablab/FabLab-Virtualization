extends Resource

class_name ItemInfo

export(String) var name
export(String) var info_text
export(Image) var item_image
enum item_type_enum {PRINT, LASERCUT, VINYLCUT, MILLED, EMBROIDERY, ANOTHER_THING = -1}
export(item_type_enum) var item_type
