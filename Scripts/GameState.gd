class_name GameState extends Serializable

var factories = {}
var player_boards = {}

func _to_string():
    return "GameState (factories: " + str(factories)