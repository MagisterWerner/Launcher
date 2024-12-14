extends Label

func _ready():
	GlobalSignalHandler.appClosed.connect(_on_app_closed)
	GlobalSignalHandler.focusIn.connect(_on_app_closed)

func _on_app_closed(message):
	self.text = message
