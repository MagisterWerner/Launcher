@tool
extends Control

@export var path: String

var output: Array
var pid: int = -1
var message: String
var steam = false
var label_text: String
var button_width: int = 200

@onready var button: Button = %Button
@onready var button_side: Panel = %ButtonSide
@onready var label = %Label


func _ready() -> void:
	set_deferred("button.size.x", button_width)
	set_deferred("button_side.size.x", button_width)
	label.text = name

func _on_button_mouse_entered() -> void:
	button.modulate += Color(0.25,0.25,0.25,0.0)

func _on_button_mouse_exited() -> void:
	button.modulate -= Color(0.25,0.25,0.25,0.0)

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
		await get_tree().create_timer(0.5).timeout  # Give it a moment to launch
		OS.execute("powershell", ["-command", "(New-Object -ComObject WScript.Shell).AppActivate(" + str(pid) + ")"])
	else:
		#Execute the external executable file
		steam = false
		pid = OS.execute('cmd', ['/C', path_cmd], output, true)
		if path_file.ends_with(".mp4"):
			print("The filename ends with .mp4")
			await get_tree().create_timer(1.0).timeout
			# F11 press for Fullscreen
			OS.execute("powershell", ["-command", "$wsh = New-Object -ComObject WScript.Shell; $wsh.SendKeys('{F11}')"])
			# Small delay to ensure F11 is processed
			await get_tree().create_timer(1.0).timeout
			OS.execute("powershell", ["-command", "$wsh = New-Object -ComObject WScript.Shell; $wsh.SendKeys('h')"])
			# Small delay to ensure F11 is processed
			await get_tree().create_timer(0.1).timeout
	if pid != -1:
		OS.kill(pid)

func _on_button_button_up():
	button.position.y -= 4
