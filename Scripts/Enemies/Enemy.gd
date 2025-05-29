extends CharacterBody2D
class_name Enemy
signal healthChanged

@export var max_health: float
@export var current_health: float

@export var speed: float
@export var direction : float = 1
@export var delay : float
@export var playerAvisted: bool = false
@export var attack_damage: int

var target_player
var is_turning := false
var random = RandomNumberGenerator.new()

@export var distance_to_attack: int
@export var distance_to_give_up: int

var state_machine: AnimationNodeStateMachinePlayback
@onready var animation_tree = $AnimationTree
@onready var vision_box = $VisionBox
@onready var sprite = $Sprite2D
@onready var hitbox = $HitBox

var can_attack: bool = true


func _ready():
	current_health = max_health
	state_machine = animation_tree.get("parameters/playback")

func set_speed(value: float):
	speed = value
	
func _physics_process(_delta: float):
	set_motion(velocity != Vector2.ZERO)

	if playerAvisted and target_player:
		var distance = global_position.distance_to(target_player.global_position)

		if distance <= distance_to_attack and can_attack:
			can_attack = false
			$AttackCooldown.start()
			attack()
		
		elif distance > distance_to_give_up:
			playerAvisted = false
			target_player = null
			$TurnTime.start()
		
		elif not can_attack:
			set_motion(false)
			set_speed(0)
			
		else:
			update_direction_to_player()

	Movement()
	flip_sprite()
	move_and_slide()

func attack():
	pass


func take_damage(damage:int):
	var critical = random.randi_range(1, 20)
	if critical == 20:
		damage *= 2
	
	current_health -= damage
	
	healthChanged.emit()
	if current_health <= 0:
		queue_free()


func update_direction_to_player():
	if not target_player:
		return

	direction = sign(target_player.global_position.x - global_position.x)


func set_motion(value : bool):
	if animation_tree:
		animation_tree.set("parameters/Movement/conditions/is_moving", value)
		animation_tree.set("parameters/Movement/conditions/is_stopped", not value)


func persuit(player):
	playerAvisted = true
	target_player = player
	update_direction_to_player()

	if has_node("TurnTime"):
		$TurnTime.stop()


func Movement():
	if is_turning:
		velocity.x = 0
		return

	velocity.x = 0.8 * speed * direction
	if vision_box:
		vision_box.scale.x = direction


func flip_sprite():
	if direction < 0:
		if hitbox:
			hitbox.scale.x = -1
		sprite.flip_h = true
	elif direction > 0:
		if hitbox:
			hitbox.scale.x = 1
		sprite.flip_h = false


func _on_vision_box_area_exited(area: Area2D) -> void:
	var player = area.get_parent()
	if player == target_player:
		playerAvisted = false
		target_player = null
