class_name BoardObject 
extends BaseCard

@onready var portrait = $Portrait

func _ready():
	_configure()
	_setup_card()
	_connect_signals()
	
func _configure():
	pivot_offset = size / 2
	scale = Const.CARD_SCALE_DEFAULT

func _setup_card():
	if _data:
		portrait.set_texture(_data.img)
