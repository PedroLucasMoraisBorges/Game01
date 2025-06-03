extends CharacterBody2D
class_name Player

var foot_step_frames = [1,5]

var is_jumping: bool = false
var is_invulnerable: bool = false
@export var animation_tree : AnimationTree

@export var inventory : Inventory

# STATE MACHINE
var state_machine: AnimationNodeStateMachinePlayback
var move_state_machine : AnimationNodeStateMachinePlayback
var jump_state_machine : AnimationNodeStateMachinePlayback
var attack_state_machine : AnimationNodeStateMachinePlayback
var death_state_machine : AnimationNodeStateMachinePlayback

@export var was_on_floor = false

# GERAL VARIABLES
@export var attack_damage: int = 10
var gravity = 980
var speed: float = 250
var direction : float
var counter : int = 0
var delay : float
var on_floor : bool:
	set(value):
		if value == on_floor:
			flip_sprite()
			return
		on_floor = value
		if value == true:
			state_machine.travel("Movement")
		elif is_jumping:
			state_machine.travel("Jump")
		else:
			state_machine.travel("Fall")
		
const soundAttack01 = preload("res://Assets/Sound/Sword Attack 1.ogg")
const soundAttack02 = preload("res://Assets/Sound/Sword Attack 2.ogg")
const soundHurt = preload("res://Assets/Sound/Player/Sword Impact Hit 1.ogg")

const soundShortGrass = preload("res://Assets/Sound/FootSteps/GRASS - Walk short 1.wav")
const soundPostJump = preload("res://Assets/Sound/Player/GRASS - Post Jump 1.wav")


func _ready() -> void:
	state_machine = animation_tree.get("parameters/playback")
	move_state_machine = animation_tree.get("parameters/Movement/playback")
	jump_state_machine = animation_tree.get("parameters/Jump/playback")
	attack_state_machine = animation_tree.get("parameters/Attack/playback")
	death_state_machine = animation_tree.get("parameters/Death/playback")
	
	$FootStepsSounds.volume_db = -6
	$FootStepsSounds.stream = soundShortGrass
	

func set_motion(value : bool):
	animation_tree.set("parameters/Movement/conditions/is_moving", value)
	animation_tree.set("parameters/Movement/conditions/is_stopped", not value)
	
func set_speed(value: float):
	speed = value
	
func flip_sprite():
	if direction < 0:
		$HitBox.scale.x = 1
		$Sprite2D.flip_h = true
	elif direction > 0:
		$HitBox.scale.x = -1
		$Sprite2D.flip_h = false
		
func play_attack(type: String):
	is_invulnerable = true
	start_invulnerability(0.5)
	match type:
		"01":
			$AudioStreamPlayer.stream = soundAttack01
			attack_damage = 10
		"02":
			$AudioStreamPlayer.stream = soundAttack02
			attack_damage = 20
		"03":
			attack_damage = 30
		"special":
			attack_damage = 50
			
	attack_state_machine.travel("Attack_"+ type)
	state_machine.travel("Attack")
	set_speed(10)
	
func controls():
	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_jumping:
		state_machine.travel("Jump")
		is_jumping = true
		velocity.y = -450
	
	if Input.is_action_just_pressed("roll") and is_on_floor():
		move_state_machine.travel("Roll")
		set_speed(200.0)
	
	if Input.is_action_just_pressed("attack_right") and is_on_floor() and Global.currentStamina >= 30:
		Global.spend_stamina(30)
		play_attack("03")
	
	if Input.is_action_just_pressed("attack_left") and delay <= 0:
		delay = 0.75
		$RESET.start()
		
		if is_on_floor():
			counter += 1
			attack((counter % 3 == 0))
		if not is_on_floor():
			jump_state_machine.travel("JumpAttack")
	
	if Input.is_action_just_pressed("ultimate") and is_on_floor() and Global.currentStamina >= 50:
		Global.spend_stamina(50)
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

	var now_on_floor = is_on_floor()

	# Detectar transição de pulo para chão
	if now_on_floor and not was_on_floor:
		is_jumping = false
		$AudioStreamPlayer.stream = soundPostJump
		$AudioStreamPlayer.play()

	on_floor = now_on_floor      # Atualiza seu sistema de estados
	was_on_floor = now_on_floor  # Atualiza o estado anterior corretamente

	if velocity == Vector2.ZERO:
		set_motion(false)
	else:
		set_motion(true)

	controls()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.has_method("collect"):
		area.collect(inventory)

func take_damage(damage: int):
	if is_invulnerable:
		return
	
	is_invulnerable = true
	start_invulnerability(0.3) # 300ms de invulnerabilidade

	var life = Global.take_damage(damage)
	state_machine.travel("Hurt")

	if Global.currentHealth <= 0:
		state_machine.travel("Death")
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://GUI/Menus/GameOver.tscn")

func start_invulnerability(duration: float):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_invulnerability_timeout"))

func _on_invulnerability_timeout():
	is_invulnerable = false

func _on_reset_timeout() -> void:
	counter = 0

func _on_hit_box_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	if enemy.has_method("take_damage"):
		enemy.take_damage(attack_damage)
