extends State
class_name EnemyGroundIdle

@export var enemy: CharacterBody2D
@export var move_speed := 100

var player: CharacterBody2D

var move_direction : Vector2
var wander_time : float

func randomize_wander():
	move_direction.x = randf_range(-1, 1)
	wander_time = randf_range(1, 3)
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()

func Update(delta):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		
func Physics_Update(delta: float):
	if enemy:
		enemy.velocity.x = move_direction.x * move_speed
	
	var direction = player.global_position - enemy.global_position
	if direction.length() < 500:
		Transititioned.emit(self, "Follow")
