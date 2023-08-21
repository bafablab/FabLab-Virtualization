extends Spatial

export var language = "fi"

func _ready():
	var vaultdoor = get_node_or_null("/root/FabLab/stg_fablab/mdl_stg_fl_door_vault_ani")
	if vaultdoor:
		vaultdoor.open_close_door()
