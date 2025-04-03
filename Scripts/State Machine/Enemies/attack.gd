extends State
class_name EnemyGroundAttack

@export var enemy: Enemy
@export var min_distance = 50
var player: CharacterBody2D

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	enemy.attack()

func Physics_Update(delta):
	var direction = player.global_position - enemy.global_position
	direction.y = 0 
	
	if direction.length() > min_distance:
		print(direction.length())
		Transititioned.emit(self, "Follow")
	else:
		enemy.attack()
