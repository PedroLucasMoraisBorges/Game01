extends Control

@onready var inventory: Inventory = preload("res://Scripts/Inventory/playerInventory.tres")
@onready var slots: Array = $GridContainer.get_children()

func _ready() -> void:
	inventory.updated.connect(update)
	update()

func update():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])
