extends Node3D

@export var TileColors: Array[Color]

var tiles_factory = preload("res://Components/TilesFactory.tscn")
var tile_ = preload("res://Components/Tile.tscn")

var TileCount := 0
var matList= [];
var factories = [];

var tile_collector_script = preload("res://Scripts/TileCollector.gd")

var tile_collector = tile_collector_script.new()

func fillFactory(factory):
	print('filling factory')
	var _tiles = tile_collector.get_tiles(factory.MaxTiles)
	factory.PutTilesOnto(_tiles)


func _ready():
	for col in TileColors:
		var _mat = StandardMaterial3D.new()
		_mat.albedo_color = col
		_mat.roughness = 0.351
		matList.append(_mat)
	for i in range(3):
		var _fac = tiles_factory.instantiate()
		factories.append(_fac)
		add_child(_fac)
		var alpha = 2*PI*i/3.0 + randf_range(deg_to_rad(-2), deg_to_rad(3));
		_fac.position = Vector3(1*sin(alpha), 0, -1*cos(alpha))
		var rot = [0, 90, 180, 270][randi()%4]+randfn(0, 3.2)
		_fac.rotation = Vector3(0, rad_to_deg(rot), 0)


@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("LeftClick"):
		fillFactory(factories[0])
		fillFactory(factories[1])
		fillFactory(factories[2])

