# This script keeps track of the number of different tiles in game.

var available_tiles : Dictionary

# to instantiate new tiles
var _tile_scene = preload("res://Components/Tile.tscn")

# the names of "colors" can be found by indexing this
var _color_idx:
	get:
		if not _color_idx:
			_color_idx = TileColorsDef.colors.keys()
		return _color_idx

func _init():
	set_up_new_round()

func set_up_new_round():
	for col in len(TileColorsDef.colors):
		available_tiles[col] = 20

func draw_random_colors(count):
	# TODO: this is not a fair draw
	var _sum_available = 0
	for _num in available_tiles.values():
		_sum_available += _num

	var num = min(count, _sum_available)
	var choosen=[]
	for i in range(num):
		while true:
			var new = randi_range(0, len(TileColorsDef.colors)-1)
			if available_tiles[new] > 0:
				available_tiles[new] -= 1
				choosen.append(new)
				break
	Log.debug("Remaining tiles: "+ str(available_tiles))
	return choosen

func get_tiles(colors: Array):
	var tiles = []
	for col in colors:
		var tnew = _tile_scene.instantiate()
		tnew.colorClass = col
		tiles.append(tnew)
	return tiles
