extends Control

const hoverSound = preload("res://Assets/Sound/GUI/menuHover.ogg")
const confirmSound = preload("res://Assets/Sound/GUI/menuSelect.ogg")
const music = preload("res://Assets/Sound/Music/Dark Ambient 1.wav")
@onready var butons = $GridContainer


func _ready():
	$Music.stream = music
	$Music.play()
	for child in butons.get_children():
		if child is Button:
			child.connect("mouse_entered",  Callable(self, "_on_button_hovered"))

func _on_resume_button_pressed() -> void:
	await _on_button_clicked()
	get_tree().change_scene_to_file("res://Scenes/Teste-Pedro.tscn")
	visible = false

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://GUI/Menus/MainMenu.tscn")

func _on_button_hovered():
	$ActionSound.stream = hoverSound
	$ActionSound.volume_db = -20
	$ActionSound.play()
	
func _on_button_clicked():
	$ActionSound.stream = confirmSound
	$ActionSound.volume_db = -20
	$ActionSound.play()
