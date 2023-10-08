extends Node3D

@export var MaxTiles = 4:
	get:
		return MaxTiles

var tiles: Array;

var number =2

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func PutTilesOnto(new_tiles: Array):
	for tile in new_tiles:
		if len(tiles) < MaxTiles:
			tiles.append(tile)
			tile.reparent(self)
			tile.position = get_node("Tile"+str(len(tiles))).position
