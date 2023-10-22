extends Control

@onready var title = $VBoxContainer/Label
@onready var msgs = $VBoxContainer/Label2

var is_ready = false

func _ready():
	is_ready = true

func set_title(str):
	title.text = str

func log_mesage(str:String):
	msgs.text += (str+'\n')
