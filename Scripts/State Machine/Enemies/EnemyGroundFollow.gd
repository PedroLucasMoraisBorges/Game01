extends State
class_name EnemyGroundFollow

@export var enemy: CharacterBody2D
@export var move_speed := 100.0
@export var min_distance = 50
var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.is_attacking = false
	
func Physics_Update(delta):
	var direction = player.global_position - enemy.global_position
	
	
	# Mantém apenas o movimento no eixo X
	direction.y = 0 
	
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
		
	if direction.length() > 200:
		Transititioned.emit(self, "Idle")
	if direction.length() <= min_distance:
		Transititioned.emit(self, "Attack")
