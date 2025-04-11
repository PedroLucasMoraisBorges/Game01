extends Node
signal healthChanged
signal staminaChanged

# LIFE
@export var maxHealth: float = 100.0
@export var currentHealth: float = maxHealth

# STAMINA
@export var maxStamina: float = 100.0
@export var currentStamina: float = maxStamina


func take_damage(amount: float):
	currentHealth -= amount
	if currentHealth < 0:
		currentHealth = maxHealth
	healthChanged.emit()

func spend_stamina(amount: float):
	currentStamina -= amount
	staminaChanged.emit()
