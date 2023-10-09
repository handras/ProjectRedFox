extends Node3D

var colorClass: TileColorsDef.colors:
	set(value):
		colorClass = value


var tile:
	get:
		if not tile:
			tile = get_node('tile')
		return tile

var _manager:
	get:
		if not _manager:
			_manager = get_node('/root/Azuljo/Manager')
		return _manager


func _ready():
	var _mat = _manager.matList[colorClass]
	tile.set_surface_override_material(0, _mat)
	pass
