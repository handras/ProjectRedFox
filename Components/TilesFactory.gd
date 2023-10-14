extends Node3D

@export var MaxTiles = 4:
	get:
		return MaxTiles

var tiles: Array
var _tile_pos: Array

func _ready():
	for i in range(MaxTiles):
		_tile_pos.append(get_node("Tile"+str(i+1)).position)

func PutTilesOnto(new_tiles: Array):
	for tile in new_tiles:
		if len(tiles) < MaxTiles:
			tile.position = _tile_pos[len(tiles)]
			tile.rotation = rotation + Vector3(0, randfn(0, rad_to_deg(1.0)),0)
			
			#tile.reparent(self) # if it already has a parent
			add_child(tile)
			tiles.append(tile)
	# TODO: handle if more than MaxTiles is put on?

func tile_pointed_at(tile):
	print(tile, 'tile_pointed_at')
	pass

func tile_clicked_at(tile):
	print(tile, 'tile_clicked_at')
	pass
