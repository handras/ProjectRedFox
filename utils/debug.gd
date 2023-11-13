extends Control

@onready var title = %title
@onready var msgs = %msgs

var is_ready = false


func _ready():
	is_ready = true
	msgs.text = ""
	hide()


func set_title(msg):
	title.text = msg


func log_message(msg: Variant):
	RuakeLayer.log_message("DEBUG| " + str(msg) + "\n")
	msgs.text += (str(msg) + "\n")
