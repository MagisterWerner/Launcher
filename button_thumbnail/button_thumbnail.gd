@tool
extends Control

@export var path: String
@export var texture_path: String

var tween: Tween
var output: Array
var pid: int = -1
var message: String
#var path_root: String
var steam = false
var label_text: String
var button_width: int = 200

@onready var button: Button = %Button
@onready var button_side: Panel = %ButtonSide
@onready var texture: TextureRect = %Texture
@onready var shine: TextureRect = %Shine
@onready var label = %Label


func _ready() -> void:
	set_deferred("button.size.x", button_width)
	set_deferred("button_side.size.x", button_width)
	texture.texture = load(texture_path)
	label.text = name
	shine.position.x = button.size.x + shine.size.x + 40

func show_colors() -> void:
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(shine, "position:x", -shine.size.x, 0.5)
	await tween.finished
	tween.kill()

func hide_colors() -> void:
	tween.kill()
	shine.position.x = button.size.x + shine.size.x + 40

func _on_button_mouse_entered() -> void:
	show_colors()

func _on_button_mouse_exited() -> void:
	hide_colors()

func _on_button_button_down():
	button.position.y += 4
	
	# Wait one second to properly display button pressed
	await get_tree().create_timer(1).timeout
	
	var path_root = path.get_slice(":", 0) + ":"
	var path_dir = path.get_base_dir()
	var path_file = path.get_file()
	var path_cmd = path_root + ' && cd "' + path_dir + '" && "' + path_file + '"'

	if path_root == "steam:":
		#Apps for steam etc. can use this, but timers won't work as good:
		steam = true
		pid = OS.execute('C:\\Program Files (x86)\\Steam\\Steam.exe', [path], output, true)
	else:
		#Execute the external executable file
		steam = false
		pid = OS.execute('cmd', ['/C', path_cmd], output, true)
	
	if pid != -1:
		OS.kill(pid)

func _on_button_button_up():
	button.position.y -= 4
