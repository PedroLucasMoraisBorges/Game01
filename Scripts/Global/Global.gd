extends Node
signal healthChanged
signal staminaChanged
signal gameOver

# LIFE
@export var maxHealth: float = 100.0
@export var currentHealth: float = maxHealth

# STAMINA
@export var maxStamina: float = 100.0
@export var currentStamina: float = maxStamina


func take_damage(amount: float):
	currentHealth -= amount
	healthChanged.emit()
	return currentHealth
	

func spend_stamina(amount: float):
	currentStamina -= amount
	staminaChanged.emit()
