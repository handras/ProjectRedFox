extends Node3D

@export var TileColors: Array[Color]

var tiles_factory = preload("res://Components/TilesFactory.tscn")
var tile_ = preload("res://Components/Tile.tscn")
var tile_collector = preload("res://Scripts/TileCollector.gd").new()
var playerboard = preload("res://Components/Playerboard.tscn")

var TileCount := 0
var matList= [];
var factories = [];

@onready var tile_dragger = get_node("../TileDragger")

func _ready():

	print(OS.get_cmdline_user_args())

	for col in TileColors:
		var _mat = StandardMaterial3D.new()
		_mat.albedo_color = col
		_mat.roughness = 0.351
		matList.append(_mat)
	var no_factories = 5
	_put_down_factories(no_factories)

	var no_playerboards = 4
	_put_down_playerboards(no_playerboards)

func _process(_delta):
	pass

func tile_was_clicked(tile, source):
	var similars = source.get_similar(tile)
	source.RemoveTilesFrom(similars)
	tile_dragger.PutTilesOnto(similars)
	await tile_dragger.drag_ended


func _put_down_factories(no_factories):
	const RADIUS = 1
	for i in range(no_factories):
		var _fac = tiles_factory.instantiate()
		factories.append(_fac)
		get_parent().add_child.call_deferred(_fac)
		var alpha = 2*PI*i/no_factories + randf_range(deg_to_rad(-2), deg_to_rad(3));
		_fac.position = Vector3(RADIUS*sin(alpha), 0, RADIUS*cos(alpha))
		var rot = [0, 90, 180, 270][randi()%4]+randfn(0, 2.82)
		_fac.rotation = Vector3(0, deg_to_rad(rot), 0)
		_fac.tile_was_clicked.connect(tile_was_clicked)
	_fill_factories()

func _put_down_playerboards(no_playerboards):
	const RADIUS = 2.6
	for i in range(no_playerboards):
		var _board = playerboard.instantiate()
		get_parent().add_child.call_deferred(_board)
		var _rand_angle = randf_range(deg_to_rad(-2), deg_to_rad(3));
		var alpha = 2*PI*i/no_playerboards + _rand_angle
		_board.position = Vector3(RADIUS*sin(alpha), 0, RADIUS*cos(alpha))
		_board.rotation = Vector3(0, alpha, 0)


func _fill_factories():
	for fac in self.factories:
		_fill_factory(fac)

func _fill_factory(factory):
	# print('filling factory')
	var _tiles = tile_collector.get_tiles(factory.MaxTiles)
	factory.PutTilesOnto.call_deferred(_tiles)
