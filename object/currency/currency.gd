class_name Currency 
extends MarginContainer

@onready var label = $Label
var currency: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_currency(new_value: int):
	print_debug('Setting currency to ' + str(new_value))
	currency = new_value
	label.text = Const.CURRENCY + str(currency)

func add(amount: int):
	var new_currency = currency + amount
	set_currency(new_currency)
	
func purchase(offer: Offer):
	if currency < offer.price:
		return false
	else:
		set_currency(currency - offer.price)
		return true
