extends Node3D

var collector_tiles: Array;
var tile_size: Vector3

func _ready():
	var t = load('res://Components/Tile.tscn').instantiate()
	add_child(t)
	tile_size = t.size
	remove_child(t)
	t.queue_free()

func PutTilesOnto(new_tiles: Array):
	global_position = new_tiles[0].global_position + Vector3(0, 1.5, 0)
	var _no_tiles = len(new_tiles)
	for tile in new_tiles:
		var _curr_idx = len(collector_tiles)
		tile.reparent(self)
		tile.position += _arrange_tile(_no_tiles, _curr_idx)

func _arrange_tile(total, idx):
	var _offset = tile_size.x*1.15
	match total:
		1:
			return Vector3()
		2:
			if idx == 1:
				return Vector3(-_offset, 0, 0)
			else:
				return Vector3(_offset, 0, 0)
		3:
			if idx == 1:
				return Vector3(-_offset, 0, -_offset)
			elif idx == 2:
				return Vector3(_offset, 0, 0)
			else:
				return Vector3(_offset, 0, -_offset)

func _physics_process(_delta):
	var space_state = get_world_3d().direct_space_state
	var cam = $'../Camera3D'
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * 500
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)

	if result:
		# print(result['collider'])
		# print(result['collider_id'])
		pass
	position = _intersect_with_plane(origin, end)

func _intersect_with_plane(origin, end):
	const plane_norm = Vector3(0,1,0)
	const plane_orig = Vector3(0, 0.1,0)
	var ray_dir = (end-origin).normalized()
	var denom = plane_norm.dot(ray_dir)
	if (abs(denom) > 1e-6) :
		var p0l0 = plane_orig - origin;
		var t = p0l0.dot(plane_norm) / denom
		return origin + ray_dir*t;
	return Vector3()




func tile_pointed_at(tile):
	print('TileCollectorABC::tile_pointed_at')
	pass

func tile_pointed_at_ended(tile):
	print('TileCollectorABC::tile_pointed_at_ended')
	pass

func tile_clicked_at(tile):
	print('TileCollectorABC::tile_clicked_at')
	pass
