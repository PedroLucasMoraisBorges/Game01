extends Enemy

func _ready():
	max_health = 200
	speed = 150
	distance_to_attack = 30
	distance_to_give_up = 200
	super()
	$TurnTime.start()

func attack():
	attack_damage = 20
	state_machine.travel("Attack")
	set_speed(0)

func _on_vision_box_area_entered(area: Area2D):
	var player = area.get_parent()
	if player.is_in_group("Player"):
		persuit(player)

func _on_hit_box_area_entered(area: Area2D):
	var player = area.get_parent()
	if player.is_in_group("Player"):
		player.take_damage(attack_damage)

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _on_turn_time_timeout() -> void:
	if not playerAvisted:
		is_turning = true
		velocity.x = 0
		set_motion(false)

		await get_tree().create_timer(1.0).timeout

		direction *= -1
		is_turning = false
