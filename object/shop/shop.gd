class_name Shop
extends Control

signal offer_purchased(offer: Offer)
signal shop_exited()

@onready var shelf1 = $Shelves/Shelf1
@onready var shelf2 = $Shelves/Shelf2
@onready var shelves: Array[Shelf] = [shelf1, shelf2]

var deck: Deck
var currency: Currency
var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for shelf in shelves:
		shelf.offer_clicked.connect(_on_offer_clicked)

func setup(rng: RandomNumberGenerator):
	self.rng = rng
	for shelf in shelves:
		shelf.setup(rng)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_offer_clicked(offer: Offer):
	var is_purchased = currency.purchase(offer)
	if is_purchased:
		var shelf = offer.get_parent()
		shelf.remove_offer(offer)
		deck.add_card(offer.card)


func _on_exit_pressed() -> void:
	shop_exited.emit()
