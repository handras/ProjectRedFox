extends Node3D

var tile_collector = preload("res://Components/TileCollectorABC.gd").new()

var tiles = tile_collector.collector_tiles
var tile_size

func _ready():
	var t = load('res://Components/Tile.tscn').instantiate()
	add_child(t)
	tile_size = t.size
	remove_child(t)
	t.queue_free()

func _process(_delta):
	pass
