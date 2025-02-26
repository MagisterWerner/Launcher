@tool
extends Control

var tween: Tween
var label_text: String

@onready var button: Button = %Button
@onready var button_side: Panel = %ButtonSide
@onready var label = %Label

func _ready() -> void:
	label.text = name

func _on_button_mouse_entered() -> void:
	button.modulate += Color(0.25,0.25,0.25,0.0)

func _on_button_mouse_exited() -> void:
	button.modulate -= Color(0.25,0.25,0.25,0.0)

func _on_button_button_down():
	button.position.y += 4
	# Wait one second to properly display button pressed
	await get_tree().create_timer(1).timeout

func _on_button_button_up():
	button.position.y -= 4
	# Quit the game
	get_tree().quit()
