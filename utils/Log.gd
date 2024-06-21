extends Control


func _ready():
	hide()


func set_title(msg):
	pass


func debug(msg: Variant):
	RuakeLayer.log_message("DEBUG| " + str(msg) + "\n")
