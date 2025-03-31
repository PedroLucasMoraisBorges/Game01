extends TextureProgressBar

@export var player: Player

func _ready() -> void:
	player = $"../../Player"
	player.healthChanged.connect(update)
	update()

func update():
	value = player.currentHealth * 100 / player.maxHealth
