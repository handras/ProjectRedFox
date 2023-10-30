class_name GameState extends Serializable

# This class encapsulates the state of the current game
# The authority is the server and sends messages to clients

var factories = {}
var player_boards = {}

func _to_string():
    return "GameState (factories: " + str(factories)