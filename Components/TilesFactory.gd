extends Node3D

const MaxTiles = 4

var _tile_hold_pos: Array
var _tile_select_pos: Array

var _tile_to_idx: Dictionary
var _idx_to_tile := [null, null, null, null]

var _mat_overlay

signal tile_was_clicked(tile, factory)
signal tile_pointed(fac, tiles)
signal tile_pointed_ended(fac, tiles)

@onready var _tile_dragger = get_node("/root/Azuljo/TileDragger")
@onready var _collider = get_node("StaticBody3D")
@onready var _mesh: MeshInstance3D = get_node("StaticBody3D/factory")


func _ready():
	_get_tile_positions()
	_mat_overlay = ShaderMaterial.new()
	_mat_overlay.shader = load("res://Shaders/factory.gdshader")


func _get_tile_positions():
	var _placeholder = get_node("positions" + str(randi_range(1, 3)))
	for i in range(MaxTiles):
		var _pos = _placeholder.get_node("tile" + str(i + 1)).position
		_tile_hold_pos.append(_pos)
		_tile_select_pos.append(_pos + Vector3(0, 0.068, 0))


func dragger_enter():
	if len(_tile_to_idx) < MaxTiles:
		_mat_overlay.set_shader_parameter("can_accept", true)
		_mesh.material_overlay = _mat_overlay
	else:
		_mat_overlay.set_shader_parameter("can_accept", false)
		_mesh.material_overlay = _mat_overlay
	pass


func dragger_exit():
	_mesh.material_overlay = null
	pass


func can_accept_tiles():
	return len(_tile_to_idx) < MaxTiles


func PutTilesOnto(new_tiles: Array):
	Log.debug("PutTilesOnto is called with: " + str(new_tiles))
	for tile in new_tiles:
		if len(_tile_to_idx) < MaxTiles:
			for i in range(_idx_to_tile.size()):
				if _idx_to_tile[i]:
					continue
				var _curr_idx = i
				tile.position = _tile_hold_pos[_curr_idx]
				tile.rotation = rotation + Vector3(0, randfn(0, rad_to_deg(1.3)), 0)
				if tile.get_parent():
					tile.reparent(self)
				else:
					add_child(tile)
				_tile_to_idx[tile] = _curr_idx
				_idx_to_tile[_curr_idx] = tile
				break  # break out of for
	# TODO: handle if more than MaxTiles is put on?


func remove_tiles(tile_idxs: Array):
	var removed = []
	for idx in tile_idxs:
		var t = _idx_to_tile[idx]
		removed.append(t)
		_tile_to_idx.erase(t)
		_idx_to_tile[idx] = null
	return removed


func tile_pointed_at(tile):
	var similars = get_similar_idxs(tile)
	tile_pointed.emit(self, similars)


func tile_pointed_at_ended(tile):
	var similars = get_similar_idxs(tile)
	tile_pointed_ended.emit(self, similars)


func select_tiles(tile_idxs):
	for idx in tile_idxs:
		_idx_to_tile[idx].target_position = to_global(_tile_select_pos[idx])


func unselect_tiles(tile_idxs):
	for idx in tile_idxs:
		_idx_to_tile[idx].target_position = to_global(_tile_hold_pos[idx])


func tile_clicked_at(tile):
#	print(tile, 'TilesFactory::tile_clicked_at')
	tile_was_clicked.emit(tile, self)


func get_similar_idxs(tile):
	var similars = []
	for i in range(_idx_to_tile.size()):
		var t = _idx_to_tile[i]
		if t.colorClass == tile.colorClass:
			similars.append(i)
	return similars
