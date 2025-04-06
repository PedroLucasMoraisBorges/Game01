extends Node
signal healthChanged
signal staminaChanged

# LIFE
@export var maxHealth = 100
@export var currentHealth: int = maxHealth

# STAMINA
@export var maxStamina = 100
@export var currentStamina: int = maxStamina
