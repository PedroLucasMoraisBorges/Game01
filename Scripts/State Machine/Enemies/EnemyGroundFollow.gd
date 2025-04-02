extends State
class_name  EnemyGroundFollow

@export var enemy: CharacterBody2D
@export var move_speed := 100.0
var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	
func Physics_Update(delta):
	var direction = player.global_position - enemy.global_position
	
	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2()
		
	print("teste")
	if direction.length() > 400:
		Transititioned.emit(self, "Idle")
