extends Node

var _player_name: Label


func _ready():
	# setup UI
	var ui = preload("res://Components/UIs/PlayUI.tscn").instantiate()
	_player_name = ui.get_node("PanelContainer/PlayerName")
	_player_name.text = "PlayerName"
	add_child(ui)

	var game_node = get_node("/root/Game")
	game_node.network_ready.connect(set_player_name)


func set_player_name(player_name):
	_player_name.text = player_name
