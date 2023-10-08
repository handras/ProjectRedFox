extends Node3D

@export var TileColors: Array[Color]

var tiles_factory = preload("res://Components/TilesFactory.tscn")
var tile_ = preload("res://Components/Tile.tscn")

var TileCount := 0
var matList= [];
var factories = [];

func fillFactory(factory):
	var _tiles = []
	for i in range(factory.MaxTiles):
		_tiles.append(createTile())
	factory.PutTilesOnto(_tiles)


func createTile(pos := Vector3(0,0,0)):
	var the_tile = tile_.instantiate()
	the_tile.position = pos
	the_tile.tile.set_surface_override_material(0, matList[TileCount % len(matList)])
	TileCount += 1
	add_child(the_tile)
	return the_tile
	
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
		
		pass
