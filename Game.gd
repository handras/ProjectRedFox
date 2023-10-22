extends Node3D

const port = 8952

var peer = ENetMultiplayerPeer.new()

func _parse_args(args):
	var arguments = {}
	for argument in args:
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
		else:
			arguments[argument.lstrip("--")] = ""
	return arguments

func _ready():
	var args = _parse_args(OS.get_cmdline_user_args())
	if "server" in args:
		peer.create_server(port)
	elif "client" in args:
		peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer

	Debug.set_title(str(args))
	Debug.log_mesage("peer ID: " + str(peer.get_unique_id()))
