extends Control

const hoverSound = preload("res://Assets/Sound/GUI/menuHover.ogg")
const confirmSound = preload("res://Assets/Sound/GUI/menuSelect.ogg")
const music = preload("res://Assets/Sound/Music/Dark Ambient 1.wav")
@onready var butons = $VBoxContainer

func _ready() -> void:
	$Music.stream = music
	$Music.play()
	
	for child in butons.get_children():
		if child is Button:
			child.connect("mouse_entered",  Callable(self, "_on_button_hovered"))
	
func _process(delta):
	pass
	
func _on_start_pressed() -> void:
	await _on_button_clicked()
	get_tree().change_scene_to_file("res://Scenes/Teste-Pedro.tscn")

func _on_exit_pressed() -> void:
	await _on_button_clicked()
	get_tree().quit()

func _on_button_hovered():
	$HoverSound.stream = hoverSound
	$HoverSound.volume_db = -20
	$HoverSound.play()
	
func _on_button_clicked():
	$HoverSound.stream = confirmSound
	$HoverSound.volume_db = -20
	$HoverSound.play()
