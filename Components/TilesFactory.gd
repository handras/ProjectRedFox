extends Node3D

@export var MaxTiles = 4:
	get:
		return MaxTiles

var tiles: Array;

func PutTilesOnto(new_tiles: Array):
	for tile in new_tiles:
		if len(tiles) < MaxTiles:
			tiles.append(tile)

			#tile.reparent(self) # if it already has a parent
			add_child(tile)
			tile.position = get_node("Tile"+str(len(tiles))).position # could be cached at _ready
			tile.rotation = rotation + Vector3(0, randfn(0, rad_to_deg(1.0)),0)
	# TODO: handle if more than MaxTiles is put on?
