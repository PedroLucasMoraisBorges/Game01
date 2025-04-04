extends CharacterBody2D
class_name Player
signal healthChanged

var is_attacking: bool = false
const jump_velocity = -400.0
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

@export var animation_tree : AnimationTree

var state_machine: AnimationNodeStateMachinePlayback
var move_state_machine : AnimationNodeStateMachinePlayback
var jump_state_machine : AnimationNodeStateMachinePlayback
var attack_state_machine : AnimationNodeStateMachinePlayback

var gravity = 980

var speed: float = 175
var direction : float
var counter : int = 0
var delay : float
var on_floor : bool:
	set(value):
		if value == on_floor:
			if value == true:
				flip_sprite()
			return
		on_floor = value
		if value == true:
			state_machine.travel("Movement")
		else:
			state_machine.travel("Jump")

func _ready() -> void:
	state_machine = animation_tree.get("parameters/playback")
	move_state_machine = animation_tree.get("parameters/Movement/playback")
	jump_state_machine = animation_tree.get("parameters/Jump/playback")
	attack_state_machine = animation_tree.get("parameters/Attack/playback")

func set_motion(value : bool):
	animation_tree.set("parameters/Movement/conditions/is_moving", value)
	animation_tree.set("parameters/Movement/conditions/is_stopped", not value)
	
func set_speed(value: float):
	speed = value
	
func flip_sprite():
	if direction < 0:
		$Sprite2D.flip_h = true
	elif direction > 0:
		$Sprite2D.flip_h = false
		
func play_attack(type: String):
	attack_state_machine.travel("Attack_"+ type)
	state_machine.travel("Attack")
	set_speed(0)
	
func controls():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state_machine.travel("Jump")
		velocity.y = -450
	
	if Input.is_action_just_pressed("roll") and is_on_floor():
		move_state_machine.travel("Roll")
		set_speed(50.0)
	
	if Input.is_action_just_pressed("attack_right"):
		play_attack("03")
	
	if Input.is_action_just_pressed("attack_left") and delay <= 0:
		delay = 0.75
		$RESET.start()
		
		if is_on_floor():
			counter += 1
			attack((counter % 3 == 0))
		if not is_on_floor():
			jump_state_machine.travel("JumpAtdawatack")
	
	if Input.is_action_just_pressed("ultimate") and is_on_floor():
		# state_machine.travel("GroupAttack/Attack01")
		play_attack("special")

func attack(is_third):
	if is_third:
		play_attack("02")
		counter = 0
		return
	play_attack("01")
	
func _physics_process(delta: float) -> void:
	if delta > 0:
		delay -= delta
		
	direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	velocity.y += gravity * delta
	move_and_slide()
	
	on_floor = is_on_floor()
	
	if velocity == Vector2.ZERO:
		set_motion(false)
	else:
		set_motion(true)
		
	controls()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	isHurt = true
	Global.currentHealth -= 1
	
	if Global.currentHealth < 0:
		Global.currentHealth = Global.maxHealth
		
	Global.healthChanged.emit()

	isHurt = false

func _on_reset_timeout() -> void:
	counter = 0
