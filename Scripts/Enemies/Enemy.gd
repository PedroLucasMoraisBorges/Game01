extends CharacterBody2D
class_name Enemy
signal healthChanged

@export var max_health: int = 100
var current_health: int


func _ready():
	current_health = max_health

func persuit():
	pass

func attack():
	pass

func take_damage(damage:float):
	current_health -= damage

	if current_health <= 0:
		queue_free()
