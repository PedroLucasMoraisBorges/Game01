extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item

func update(item: InventoryItem):
	if !item:
		itemSprite.visible = false
	else:
		itemSprite.visible = true
		itemSprite.texture = item.texture
