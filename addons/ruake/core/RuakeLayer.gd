extends CanvasLayer

var ruake_menu
const RuakeScene = preload("./Ruake.tscn")
var action_name

func _ready():
	var configured_action_name := Ruake.toggle_action_name()
	if InputMap.has_action(configured_action_name):
		action_name = configured_action_name
	_create_ruake()
	# TODO: save history
	ruake_menu.history = []

func log_message(message):
	ruake_menu.log_message(message)

func _physics_process(_delta):
	if action_name and Input.is_action_just_pressed(action_name):
		toggle_ruake()

func _create_ruake():
	ruake_menu = RuakeScene.instantiate()
	ruake_menu.connect("history_changed",Callable(self,"ruake_history_changed"))
	add_child(ruake_menu)

func toggle_ruake():
	if ruake_menu.visible:
		ruake_menu.hide()
		get_tree().paused = false
	else:
		ruake_menu.show()
		get_tree().paused = true
		ruake_menu.grab_focus()
