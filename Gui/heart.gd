extends Panel

@onready var sprites = $Sprite2D


func update(whole: bool):
	if whole:
		sprites.frame = 4
	else:
		sprites.frame = 0
