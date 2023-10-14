extends Node3D

var colorClass: TileColorsDef.colors:
	set(value):
		colorClass = value


@onready var _manager = get_node('/root/Azuljo/Manager')
@onready var tile = get_node('tile')
@onready var collider = get_node('tile/StaticBody3D')


func _ready():
	var _mat = _manager.matList[colorClass]
	tile.set_surface_override_material(0, _mat)
	collider.mouse_entered.connect(pointed_at)
	collider.input_event.connect(clicked_at)
	pass


func pointed_at():
	get_parent().tile_pointed_at(self)

func clicked_at():
	get_parent().tile_clicked_at(self)
