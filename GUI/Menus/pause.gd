extends Control

const hoverSound = preload("res://Assets/Sound/GUI/menuHover.ogg")
const confirmSound = preload("res://Assets/Sound/GUI/menuSelect.ogg")
@onready var butons = $GridContainer

var _is_paused: bool = false:
	set = set_paused

func _ready():
	for child in butons.get_children():
		if child is Button:
			child.connect("mouse_entered",  Callable(self, "_on_button_hovered"))
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused
	
func set_paused(value:bool):
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_resume_button_pressed() -> void:
	await _on_button_clicked()
	get_tree().paused = false
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
