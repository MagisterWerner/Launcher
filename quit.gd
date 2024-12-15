@tool
extends Control

var tween: Tween
var label_text: String

@onready var button: Button = %Button
@onready var button_side: Panel = %ButtonSide
@onready var shine: TextureRect = %Shine
@onready var label = %Label

func _ready() -> void:
	label.text = name
	shine.position.x = button.size.x + shine.size.x

func show_colors() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(shine, "position:x", -shine.size.x, 0.5)
	await tween.finished
	tween.kill()

func hide_colors() -> void:
	tween.kill()
	shine.position.x = button.size.x + shine.size.x

func _on_button_mouse_entered() -> void:
	show_colors()

func _on_button_mouse_exited() -> void:
	hide_colors()

func _on_button_button_down():
	button.position.y += 4
	# Wait one second to properly display button pressed
	await get_tree().create_timer(1).timeout

func _on_button_button_up():
	button.position.y -= 4
	# Quit the game
	get_tree().quit()
