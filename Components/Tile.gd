extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var _tile
var tile:
	get:
		if not _tile:
			_tile = get_node('tile')
		return _tile
