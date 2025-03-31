extends TextureProgressBar

@export var enemy: Enemy

func _ready() -> void:
	enemy = $".."
	enemy.healthChanged.connect(update)
	update()

func update():
	value = enemy.currentHealth * 100 / enemy.maxHealth
