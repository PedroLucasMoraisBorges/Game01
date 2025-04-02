extends CharacterBody2D
class_name Player
signal healthChanged

@export var speed: int = 300
var is_attacking: bool = false
var gravity = 980
const jump_velocity = -400.0
@onready var sprites: AnimatedSprite2D = $Sprites
@onready var hurtTimer = $HurtTimer
@export var knockBackPower: int = 500
@onready var hurtbox = $HurtBox/CollisionShape2D
@onready var hurtbox_initial_position = hurtbox.position
@onready var hitbox = $HitBox/CollisionShape2D
@onready var hitbox_initial_position = hitbox.position
@onready var collision = $Collision
@onready var collision_initial_position = collision.position

var isHurt: bool = false

var foot_step_frames = [1,5]

@export var sfx_run:  AudioStream
@export var sfx_jump: AudioStream
@export var sfx_attack: AudioStream
@export var sfx_hurt: AudioStream

@onready var sfx_player = %sfx_player

func _ready() -> void:
	hitbox.disabled = true
	
func load_sfx(sfx_to_load):
	if sfx_player.stream != sfx_to_load:
		sfx_player.stop()
		sfx_player.stream = sfx_to_load

func HandleInput(delta):
	velocity.x = 0
	if not is_on_floor():
		velocity.y += gravity * delta
		sprites.play("fall")
		
	# Entrada para pular
	if is_on_floor() and Input.is_action_just_pressed("ui_up") and not is_attacking:
		velocity.y = jump_velocity
		sprites.play("jump")
		await  sprites.animation_finished

	# Entrada para correr
	var moving = false
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		sprites.flip_h = true
		moving = true
		adjust_hitbox_position()
		
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
		sprites.flip_h = false
		moving = true
		adjust_hitbox_position()
	
	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_attacking:
		attack()
	# Definir animação se estiver no chão
	if is_on_floor() and not is_attacking:  # Apenas muda animações se não estiver atacando
		if moving:
			sprites.play("run")
		else:
			sprites.play("idle")

func _physics_process(delta: float) -> void:
	HandleInput(delta)
	move_and_slide()

func attack():
	is_attacking = true
	velocity.x = 0
	sprites.play("attack")
	hitbox.disabled = false
	await sprites.animation_finished
	hitbox.disabled = true
	is_attacking = false
	load_sfx(sfx_attack)
	sfx_player.play()
	
func adjust_hitbox_position():
	if sprites.flip_h:
		hitbox.position.x = -abs(hitbox_initial_position.x) + 24
		hurtbox.position.x = -abs(hurtbox_initial_position.x) + 24
		collision.position.x = -abs(collision_initial_position.x) + 24
	else:
		hitbox.position.x = abs(hitbox_initial_position.x) 
		hurtbox.position.x = abs(hurtbox_initial_position.x)
		collision.position.x = abs(collision_initial_position.x)

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if isHurt: return
	Global.currentHealth -= 1
	
	if Global.currentHealth < 0:
		print("morreu")
		
	Global.healthChanged.emit()
	isHurt = true
	knockBack(area.get_parent().velocity)
	
	hurtTimer.start()
	await hurtTimer.timeout
	isHurt = false

func knockBack(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockBackPower
	velocity = knockbackDirection
	move_and_slide()


func _on_sprites_frame_changed() -> void:
	if sprites.animation == "idle": return
	if sprites.animation == "jump": return
	if sprites.animation == "fall": return
	if sprites.animation == "attack": return
	load_sfx(sfx_run)
	
	if sprites.frame in foot_step_frames: sfx_player.play()
