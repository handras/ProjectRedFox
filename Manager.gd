extends Node3D

@export var TileColors: Array[Color]

var tiles_factory = preload("res://Components/TilesFactory.tscn")
var tile_ = preload("res://Components/Tile.tscn")
var tile_collector = preload("res://Scripts/TileCollector.gd").new()
var playerboard = preload("res://Components/Playerboard.tscn")

var TileCount := 0
var matList= [];
var factories = [];
var game_state

@onready var tile_dragger = get_node("../TileDragger")

func _ready():
	for col in TileColors:
		var _mat = StandardMaterial3D.new()
		_mat.albedo_color = col
		_mat.roughness = 0.351
		matList.append(_mat)


	game_state = preload("res://Scripts/GameState.gd").new()
	Debug.log_message(game_state)
	var no_factories = 5
	_put_down_factories(no_factories)

	var no_playerboards = 4
	_put_down_playerboards(no_playerboards)

	Game.peer_joined.connect(on_peer_joined)

	await Game.network_ready
	Debug.log_message("peer ID in manager: " + str(multiplayer.get_unique_id()))

	if multiplayer.get_unique_id() == 1:
		Debug.log_message("Server is filling factories")
		fill_factories()

func _process(_delta):
	pass

func tiles_selected(fac, tile_idxs):
	var fac_idx = factories.find(fac)
	on_tiles_selected.rpc(fac_idx, tile_idxs)

func tiles_unselected(fac, tile_idxs):
	var fac_idx = factories.find(fac)
	on_tiles_unselected.rpc(fac_idx, tile_idxs)

@rpc("call_local", "any_peer", "reliable")
func on_tiles_selected(fac_idx, tile_idxs):
	var fac = factories[fac_idx]
	fac.select_tiles(tile_idxs)

@rpc("call_local", "any_peer", "reliable")
func on_tiles_unselected(fac_idx, tile_idxs):
	var fac = factories[fac_idx]
	fac.unselect_tiles(tile_idxs)

func tile_was_clicked(tile, source):
	var fac_id = factories.find(source)
	var similars = source.get_similar_idxs(tile)
	move_tiles_to_dragger.rpc(fac_id, similars)


@rpc("call_local", "any_peer", "reliable")
func move_tiles_to_dragger(from_fac, tile_idxs):
	var fac = factories[from_fac]
	var tiles = fac.remove_tiles(tile_idxs)
	tile_dragger.PutTilesOnto(tiles)
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
		_fac.tile_pointed.connect(tiles_selected)
		_fac.tile_pointed_ended.connect(tiles_unselected)

func _put_down_playerboards(no_playerboards):
	const RADIUS = 2.6
	for i in range(no_playerboards):
		var _board = playerboard.instantiate()
		get_parent().add_child.call_deferred(_board)
		var _rand_angle = randf_range(deg_to_rad(-2), deg_to_rad(3));
		var alpha = 2*PI*i/no_playerboards + _rand_angle
		_board.position = Vector3(RADIUS*sin(alpha), 0, RADIUS*cos(alpha))
		_board.rotation = Vector3(0, alpha, 0)

func fill_factories():
	for fac in factories:
		var colors = tile_collector.draw_random_colors(fac.MaxTiles)
		game_state.factories[len(game_state.factories)] = colors
	await get_tree().create_timer(0.5).timeout # wait for clients
	rpc("put_tiles_on_all_clients", game_state.to_dict())

@rpc("call_local", "reliable")
func put_tiles_on_all_clients(state):
	var locstate = GameState.from_dict(state)
	var idx = 0
	for fac in factories:
		instantiate_tiles(fac, locstate.factories[idx])
		idx += 1
	pass

func instantiate_tiles(fac, colors):
		var tiles = []
		for col in colors:
			var t = tile_.instantiate()
			t.colorClass = col
			tiles.append(t)
		fac.PutTilesOnto(tiles)

func on_peer_joined(id):
	pass
