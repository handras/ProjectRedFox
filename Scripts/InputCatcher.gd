extends Node

# Catch every input when the game loses focus or mouse is out of viewport

var game_in_focus: bool

func _notification(what):
	if what in [NOTIFICATION_WM_WINDOW_FOCUS_IN, NOTIFICATION_WM_MOUSE_ENTER]:
		# print('in focus')
		game_in_focus = true
		get_viewport().get_window().gui_disable_input = false
	elif what in [NOTIFICATION_WM_MOUSE_EXIT, NOTIFICATION_WM_WINDOW_FOCUS_OUT]:
		# print('out focus')
		game_in_focus = false
		get_viewport().get_window().gui_disable_input = true

func _input(_event):
	if not game_in_focus:
		get_viewport().set_input_as_handled()
