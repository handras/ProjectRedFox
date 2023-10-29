extends Control

@onready var title = %title
@onready var msgs = %msgs

var is_ready = false

func _ready():
	is_ready = true
	msgs.text = ''

func set_title(msg):
	title.text = msg

func log_message(msg:Variant):
	msgs.text += (str(msg)+'\n')

func _unhandled_key_input(event):
	if event.is_action_released("toggle_console"):
		if visible:
			hide()
		else:
			show()
