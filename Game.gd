extends Node

const port = 8952

var peer = ENetMultiplayerPeer.new()

var num_players: int

# the references of romte peers, set when they join
var remote_peers = []

# name of this instance used for debugging
var me := "whoami"

# Emitted once the multiplayer api is set up
signal network_ready

signal peer_joined(id: int)


func _parse_args(args):
	var arguments = {}
	for argument in args:
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
		else:
			arguments[argument.lstrip("--")] = ""
	return arguments


func _setup_cursor():
	# Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	pass


func _ready():
	_setup_cursor()
	# some bug with Networking, has to give it time to be ready
	await get_tree().create_timer(0.03).timeout
	var args = _parse_args(OS.get_cmdline_user_args())
	if "server" in args:
		peer.create_server(port)
		me = "Server"
		multiplayer.peer_connected.connect(on_peer_connected_to_server)

	elif "client" in args:
		peer.create_client("localhost", port)
		me = "Client " + str(args["client"])
		multiplayer.peer_connected.connect(on_peer_connected_to_client)

	else:
		# handle case when this is set from menu
		pass

	multiplayer.multiplayer_peer = peer
	Debug.set_title(me)
	network_ready.emit()


func on_peer_connected_to_server(peer_id):
	Debug.log_message(str(peer_id) + " connected to " + me)
	remote_peers.append(peer_id)
	peer_joined.emit(peer_id)


func on_peer_connected_to_client(peer_id):
	remote_peers.append(peer_id)
	Debug.log_message(str(peer_id) + " connected to " + me)
