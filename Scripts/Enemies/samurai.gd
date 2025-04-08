extends CharacterBody2D

class_name Samurai
signal healthChanged

@export var maxHealth = 3
@export var currentHealth = maxHealth
@export var attack_interval = 1

@export var state_machine: Node
@onready var sprites: AnimatedSprite2D = $Sprites

@onready var attack_timer: Timer = $AttackTimer


# BOXES
@onready var hitbox = $HitBox/CollisionShape2D
@onready var hitbox_initial_position = hitbox.position

# BOOLEANS
@export var is_attacking: bool
@export var is_moving: bool = false

func _ready():
	hitbox.disabled = true
	is_attacking = false

func _physics_process(delta):
	if velocity.x > 0 or velocity.x < 0:
		sprites.play("run")
	
	if velocity.x > 0:
		sprites.flip_h = false
		adjust_hitbox_position()
	elif velocity.x < 0:
		sprites.flip_h = true
		adjust_hitbox_position()
		
	move_and_slide()

func attack():
	if not is_attacking:
		print(is_attacking)
		is_attacking = true
		velocity = Vector2.ZERO
		
		sprites.play("attack")
		hitbox.disabled = true
		
		# Mantém o hitbox ativo por 0.3s (ajuste esse valor se necessário)
		await get_tree().create_timer(0.3).timeout 
		
		hitbox.disabled = false
		
		# Aguarda o fim da animação antes de permitir outro ataque
		await sprites.animation_finished
		
		is_attacking = false


func _on_hurt_box_area_entered(area: Area2D) -> void:
	currentHealth -= 1
	
	if currentHealth <= 0:
		queue_free()
		
	healthChanged.emit()
	
func adjust_hitbox_position():
	if sprites.flip_h:
		hitbox.position.x = -abs(hitbox_initial_position.x)
	else:
		hitbox.position.x = abs(hitbox_initial_position.x) 
	
