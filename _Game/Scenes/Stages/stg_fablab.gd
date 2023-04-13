extends Spatial

export var language = "fi"

func _ready():
	TranslationServer.set_locale(language)	

