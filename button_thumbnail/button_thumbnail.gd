@tool
extends Control

@export var button_width: int = 200
@export var label_text: String
@export var path: String
@export var texture_path: String


var tween: Tween
var start_time: float
var elapsed_seconds: float
var elapsed_minutes: float
var elapsed_hours: float
var output: Array
var pid: int = -1
var message: String
#var path_root: String
var steam = false

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
	
	# Start the timer
	start_time = Time.get_unix_time_from_system()
	
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
	
	# Calculate the elapsed time in milliseconds
	elapsed_seconds = Time.get_unix_time_from_system() - start_time
	elapsed_minutes = elapsed_seconds / 60
	elapsed_hours = elapsed_minutes / 60
	if elapsed_seconds > 1:
		message = "Du använde " + str(label_text) + " i " + str(round(elapsed_hours)) + " timmar, " + str(round(elapsed_minutes)) + " minuter och " + str(round(elapsed_seconds)) + " sekunder!"
		GlobalSignalHandler.appClosed.emit(message)
	
	if pid != -1:
		OS.kill(pid)

func _on_button_button_up():
	button.position.y -= 4

func _notification(what):
	if steam:
		match what:
			MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
				elapsed_seconds = Time.get_unix_time_from_system() - start_time
				elapsed_minutes = elapsed_seconds / 60
				elapsed_hours = elapsed_minutes / 60
				message = "Du använde " + str(label_text) + " i " + str(round(elapsed_hours)) + " timmar, " + str(round(elapsed_minutes)) + " minuter och " + str(round(elapsed_seconds)) + " sekunder!"
				GlobalSignalHandler.focusIn.emit(message)
