extends Resource

class_name ItemInfo

export(String) var name
export(String, MULTILINE) var info_text
export(int) var manu_time
export(Resource) var device_used
export(Image) var item_image
export(Mesh) var mesh
#enum item_type_enum {PRINT, LASERCUT, VINYLCUT, MILLED, EMBROIDERY, ANOTHER_THING = -1}
#export(item_type_enum) var item_type
