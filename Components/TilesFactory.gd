extends Node3D

@export var MaxTiles = 4:
	get:
		return MaxTiles

var _tile_hold_pos: Array
var _tile_select_pos: Array
var _tile_ind: Dictionary

signal tile_was_clicked(tile, factory)

@onready var _tile_dragger = get_node('/root/Azuljo/TileDragger')
@onready var _collider = get_node('StaticBody3D')
@onready var _mesh : MeshInstance3D = get_node('StaticBody3D/factory')

func _ready():
	for i in range(MaxTiles):
		var _pos = get_node("Tile"+str(i+1)).position
		_tile_hold_pos.append(_pos)
		_tile_select_pos.append(_pos + Vector3(0, 0.068, 0))

	_tile_dragger.drag_started.connect(on_drag_start)
	_tile_dragger.drag_ended.connect(on_drag_end)

func on_drag_start():
	_collider.mouse_entered.connect(_can_accept_from_dragger)
	_collider.mouse_exited.connect(return_to_default)

func on_drag_end():
	_collider.mouse_entered.disconnect(_can_accept_from_dragger)
	_collider.mouse_exited.disconnect(return_to_default)

func _can_accept_from_dragger():
	var _mat = StandardMaterial3D.new()
	if len(_tile_ind) < MaxTiles:
		print('can accept')
		_mat.albedo_color = Color.LIGHT_GREEN
	else:
		print('can NOT accept')
		_mat.albedo_color = Color.HOT_PINK
	_mesh.set_surface_override_material(0, _mat)

func return_to_default():
	_mesh.set_surface_override_material(0, StandardMaterial3D.new())


func PutTilesOnto(new_tiles: Array):
	for tile in new_tiles:
		if len(_tile_ind) < MaxTiles:
			var _curr_idx = len(_tile_ind)
			tile.position = _tile_hold_pos[_curr_idx]
			tile.rotation = rotation + Vector3(0, randfn(0, rad_to_deg(1.3)),0)

			#tile.reparent(self) # if it already has a parent
			add_child(tile)
			_tile_ind[tile] = _curr_idx
	# TODO: handle if more than MaxTiles is put on?

func RemoveTilesFrom(tile_to_remove: Array):
	for t in tile_to_remove:
		_tile_ind.erase(t)


func tile_pointed_at(tile):
#	print(tile, 'TilesFactory::tile_pointed_at')
	var similars = get_similar(tile)
	for t in similars:
		t.target_position = to_global(_tile_select_pos[_tile_ind[t]])
	pass

func tile_pointed_at_ended(tile):
#	print(tile, 'TilesFactory::tile_pointed_at_ended')
	var similars = get_similar(tile)
	for t in similars:
		t.target_position = to_global(_tile_hold_pos[_tile_ind[t]])
	pass

func tile_clicked_at(tile):
#	print(tile, 'TilesFactory::tile_clicked_at')
	tile_was_clicked.emit(tile, self)

func get_similar(tile):
	var similars = []
	for t in _tile_ind.keys():
		if t.colorClass == tile.colorClass:
			similars.append(t)
	return similars
