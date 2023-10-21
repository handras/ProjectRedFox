extends Node3D

@export var MaxTiles = 4:
	get:
		return MaxTiles

var _tile_hold_pos: Array
var _tile_select_pos: Array

var _tile_to_idx: Dictionary
var _idx_to_tile:= [null, null, null, null]

var _mat_can_accept
var _mat_can_not_accept

signal tile_was_clicked(tile, factory)

@onready var _tile_dragger = get_node('/root/Azuljo/TileDragger')
@onready var _collider = get_node('StaticBody3D')
@onready var _mesh : MeshInstance3D = get_node('StaticBody3D/factory')

func _ready():

	_get_tile_positions()

	_mat_can_accept = StandardMaterial3D.new()
	_mat_can_accept.albedo_color = Color.LIGHT_GREEN

	_mat_can_not_accept = StandardMaterial3D.new()
	_mat_can_not_accept.albedo_color = Color.RED

func _get_tile_positions():
	var _placeholder = get_node("positions"+str(randi_range(1,3)))
	for i in range(MaxTiles):
		var _pos = _placeholder.get_node("tile"+str(i+1)).position
		_tile_hold_pos.append(_pos)
		_tile_select_pos.append(_pos + Vector3(0, 0.068, 0))

func dragger_enter():
	if len(_tile_to_idx) < MaxTiles:
		_mesh.set_surface_override_material(0, _mat_can_accept)
	else:
		_mesh.set_surface_override_material(0, _mat_can_not_accept)
	pass

func dragger_exit():
	_mesh.set_surface_override_material(0, null)
	pass

func can_accept_tiles():
	return len(_tile_to_idx) < MaxTiles

func PutTilesOnto(new_tiles: Array):
	for tile in new_tiles:
		if len(_tile_to_idx) < MaxTiles:
			for i in range(_idx_to_tile.size()):
				if _idx_to_tile[i]:
					continue
				var _curr_idx = i
				tile.position = _tile_hold_pos[_curr_idx]
				tile.rotation = rotation + Vector3(0, randfn(0, rad_to_deg(1.3)),0)
				if tile.get_parent():
					tile.reparent(self)
				else:
					add_child(tile)
				_tile_to_idx[tile] = _curr_idx
				_idx_to_tile[_curr_idx] = tile
				break  # break out of for
	# TODO: handle if more than MaxTiles is put on?

func RemoveTilesFrom(tile_to_remove: Array):
	for t in tile_to_remove:
		_idx_to_tile[_tile_to_idx[t]] = null
		_tile_to_idx.erase(t)


func tile_pointed_at(tile):
#	print(tile, 'TilesFactory::tile_pointed_at')
	var similars = get_similar(tile)
	for t in similars:
		t.target_position = to_global(_tile_select_pos[_tile_to_idx[t]])
	pass

func tile_pointed_at_ended(tile):
#	print(tile, 'TilesFactory::tile_pointed_at_ended')
	var similars = get_similar(tile)
	for t in similars:
		t.target_position = to_global(_tile_hold_pos[_tile_to_idx[t]])
	pass

func tile_clicked_at(tile):
#	print(tile, 'TilesFactory::tile_clicked_at')
	tile_was_clicked.emit(tile, self)

func get_similar(tile):
	var similars = []
	for t in _tile_to_idx.keys():
		if t.colorClass == tile.colorClass:
			similars.append(t)
	return similars
