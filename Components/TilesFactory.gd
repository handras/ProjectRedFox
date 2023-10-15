extends Node3D

@export var MaxTiles = 4:
	get:
		return MaxTiles

var tiles: Array
var _tile_hold_pos: Array
var _tile_select_pos: Array
var _tile_ind: Dictionary

func _ready():
	for i in range(MaxTiles):
		var _pos = get_node("Tile"+str(i+1)).position
		_tile_hold_pos.append(_pos)
		_tile_select_pos.append(_pos + Vector3(0, 0.068, 0))

func PutTilesOnto(new_tiles: Array):
	for tile in new_tiles:
		if len(tiles) < MaxTiles:
			var _curr_idx = len(tiles)
			tile.position = _tile_hold_pos[_curr_idx]
			tile.rotation = rotation + Vector3(0, randfn(0, rad_to_deg(1.3)),0)

			#tile.reparent(self) # if it already has a parent
			add_child(tile)
			_tile_ind[tile] = _curr_idx
			tiles.append(tile)
	# TODO: handle if more than MaxTiles is put on?

func tile_pointed_at(tile):
	print(tile, 'TilesFactory::tile_pointed_at')
	var similars = get_similar(tile)
	for t in similars:
		t.target_position = to_global(_tile_select_pos[_tile_ind[t]])
	pass

func tile_pointed_at_ended(tile):
	print(tile, 'TilesFactory::tile_pointed_at_ended')
	var similars = get_similar(tile)
	for t in similars:
		t.target_position = to_global(_tile_hold_pos[_tile_ind[t]])
	pass

func tile_clicked_at(tile):
	print(tile, 'TilesFactory::tile_clicked_at')
	var dragger = $'../TileDragger'
	dragger.PutTilesOnto(get_similar(tile))
	pass

func get_similar(tile):
	var similars = []
	for t in tiles:
		if t.colorClass == tile.colorClass:
			similars.append(t)
	return similars
