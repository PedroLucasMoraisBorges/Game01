extends Enemy

func _ready():
	max_health = 100
	super()

func persuit():
	print("Lancer avança rapidamente.")

func attack():
	print("Lancer perfura com a lança!")

func take_damage(damage:float):
	super(damage)
