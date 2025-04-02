#extends CharacterBody2D
#class_name Enemy
#signal healthChanged
#
#@export var speed = 200
#@export var limit = 30
#var gravity = 980
#var startPosition
#var endPosition
#var movingToEnd = true  # Começa indo para endPosition
#@onready var sprites: AnimatedSprite2D = $Sprites
#@export var maxHealth = 3
#@export var currentHealth: int = maxHealth
#@export var knockBackPower: int = 500
#var nome : String
#var isHurt: bool = false
#@onready var hitbox = $HitBox/CollisionShape2D
#@onready var hitbox_initial_position = hitbox.position
#@export var playerAvisted: bool = false
#@export var is_attacking: bool = false
#@export var attack_interval: float = 2.0
#@export var player = null
#@export var stop_distance: float = 65
#var checking_distance: bool = false
#
#
#func _init(p_nome: String = "") -> void:
	#nome = p_nome
	#
#func _ready() -> void:
	#startPosition = position
	#endPosition = startPosition - Vector2(20 * 20, 0)
	#hitbox.disabled = true
	#
#
#func perseguir(player_instance):
	## Salvar a referência do player para uso futuro
	#player = player_instance
	#var direction_x = sign(player.global_position.x - global_position.x) # Apenas a direção horizontal
	#velocity.x = direction_x * speed  # Define apenas a velocidade no eixo X
	#sprites.play("run")
	#is_attacking = false
	#flip()
	#
#func _ajustar_distancia():
	#await get_tree().create_timer(0.1).timeout  # Aguardar um intervalo de 0.1s para medir novamente
	#
	## Verificar se o player existe antes de calcular a distância
	#if player:
		#var distance_to_player = global_position.distance_to(player.global_position)
		## print_debug("Distância até o player: ", distance_to_player)
		#
		#if distance_to_player <= stop_distance:
			## Iniciar o ataque se não estiver atacando
			#if not is_attacking:
				#attack()  
		#elif distance_to_player > stop_distance:
			## Se o player sair da área de ataque, volte a perseguir
			#perseguir(player)
#
	## Continuar verificando a distância periodicamente
	#_ajustar_distancia()  # Chama a função novamente para continuar o loop assíncrono
#
#func attack():
	#if not is_attacking:
		#is_attacking = true
		#velocity = Vector2.ZERO
		## Começa a animação de ataque
		#sprites.play("attack")
		#hitbox.disabled = false
		#
		#await sprites.animation_finished
		#adjust_hitbox_position()
#
		#is_attacking = false
		#hitbox.disabled = true
		#
#func changeDirection():
	#var temp = startPosition
	#startPosition = endPosition
	#endPosition = temp
	#
#func updateVelocity():
	#var target = endPosition
	#var moveDirection = target - position
#
	#if moveDirection.length() < limit:
		#movingToEnd = not movingToEnd  
		#changeDirection()
#
	#flip()  
	#sprites.play("run") 
	#velocity.x = moveDirection.normalized().x * speed if moveDirection.length() > 0 else 0
	#adjust_hitbox_position()
#
#func flip():
	#if velocity.x > 0:
		#sprites.flip_h = false
	#elif velocity.x < 0:
		#sprites.flip_h = true
#
#func _physics_process(delta):
	#
	## Aplica gravidade
	## if not is_on_floor():
		##velocity.y += gravity * delta
	##elif is_on_floor() and not playerAvisted:
		##updateVelocity()
	##if not checking_distance:
		##checking_distance = true
		##_ajustar_distancia()
		#
	#if velocity.length()> 0:
		#sprites.play("run")
		#
	#if velocity.x > 0:
		#sprites.flip_h = false
	#else:
		#sprites.flip_h = true
	#move_and_slide()
#
#func knockBack(enemyVelocity: Vector2):
	#var knockbackDirection = (enemyVelocity - velocity).normalized() * knockBackPower
	#velocity = knockbackDirection
	#move_and_slide()
	#
#func adjust_hitbox_position():
	#if sprites.flip_h:
		#hitbox.position.x = -abs(hitbox_initial_position.x)
	#else:
		#hitbox.position.x = abs(hitbox_initial_position.x) 
	#
#func _on_hurt_box_area_entered(area: Area2D) -> void:
	#if isHurt: return
	#
	#currentHealth -= 1
	#
	#if currentHealth < 0:
		#queue_free()
		#
	#healthChanged.emit()
	#isHurt = true
	#knockBack(area.get_parent().velocity)
	#isHurt = false
#
##func _on_vision_box_area_entered(area: Area2D) -> void:
	##playerAvisted = true
	##perseguir(area)
