extends Control

@onready var title = %title
@onready var msgs = %msgs

var is_ready = false

func _ready():
	is_ready = true
	msgs.text = ''

func set_title(msg):
	title.text = msg

func log_message(msg:String):
	msgs.text += (msg+'\n')
