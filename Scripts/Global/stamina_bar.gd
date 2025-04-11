extends TextureProgressBar

func _ready() -> void:
	Global.staminaChanged.connect(update)
	update()

func update():
	value = Global.currentStamina * 100 / Global.maxStamina
