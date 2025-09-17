class_name Round
extends Control

@onready var deck = $Deck

var hand_scene = preload("res://object/hand/hand.tscn")
var hand: Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand = hand_scene.instantiate()
	add_child(hand)
	deck.card_drawn.connect(hand.on_card_drawn)
	deck.shuffle()
	for i in 7:
		deck.draw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
