extends Control

var item
onready var itemName = $Panel/ItemName
onready var infoText = $Panel/InfoText

# Called when the node enters the scene tree for the first time.
func _ready():
	itemName.text = item.name
	infoText.text = item.infoText

func init(itm):
	item = itm

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
