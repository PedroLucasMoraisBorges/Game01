extends TextureProgressBar

var enemy : Enemy

func _ready() -> void:
	await get_tree().process_frame
	
	enemy = get_parent() as Enemy
	
	if enemy:
		enemy.healthChanged.connect(update)
		update()

func update():
	value = enemy.current_health * 100 / enemy.max_health
