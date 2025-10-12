class_name Shelf
extends HBoxContainer

signal offer_clicked(offer: Offer)

@onready var offer1 = $Offer1
@onready var offer2 = $Offer2
@onready var offer3 = $Offer3
@onready var offers: Array[Offer] = [offer1, offer2, offer3]

var rng: RandomNumberGenerator

func _ready() -> void:
	for offer in offers:
		offer.offer_clicked.connect(_on_offer_clicked)

func _on_offer_clicked(offer: Offer) -> void:
	offer_clicked.emit(offer)

func setup(rng: RandomNumberGenerator):
	for offer in offers:
		offer.setup(rng)

func remove_offer(removed_offer: Offer):
	for offer in offers:
		if offer == removed_offer:
			offers.erase(offer)
			offer.queue_free()
			if offer1 == removed_offer:
				offer1 = null
			if offer2 == removed_offer:
				offer2 = null
			if offer2 == removed_offer:
				offer2 = null
