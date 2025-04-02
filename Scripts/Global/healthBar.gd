extends TextureProgressBar

func _ready() -> void:
	Global.healthChanged.connect(update)
	update()

func update():
	value = Global.currentHealth * 100 / Global.maxHealth
