extends CharacterBody2D

class_name Enemy
signal healthChanged

@export var maxHealth = 3
@export var currentHealth = maxHealth

func _physics_process(delta):
	move_and_slide()
