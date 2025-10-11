class_name Offer
extends VBoxContainer

@onready var price_panel = $Price
@onready var price_label = $Price/PriceLabel
@onready var content = $Content

@export var price: int

var rng: RandomNumberGenerator
var card_generator: CardGenerator
var card: BaseCard
var pricetag_style: StyleBoxFlat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_pricetag()
	rng = RandomNumberGenerator.new()
	card_generator = CardGenerator.new(rng)
	card = card_generator.generate()
	content.add_child(card)
	set_price(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _setup_pricetag():
	pricetag_style = StyleBoxFlat.new()
	pricetag_style.bg_color = Color.WHITE
	pricetag_style.border_color = Color.BLACK
	pricetag_style.border_width_top = 3
	pricetag_style.border_width_bottom = 3
	pricetag_style.border_width_left = 3
	pricetag_style.border_width_right = 3
	pricetag_style.corner_radius_top_left = 12
	pricetag_style.corner_radius_top_right = 12
	pricetag_style.corner_radius_bottom_left = 12
	pricetag_style.corner_radius_bottom_right = 12
	price_panel.add_theme_stylebox_override("panel", pricetag_style)

func set_price(amount: int):
	price = amount
	price_label.text = Const.CURRENCY + str(price)
