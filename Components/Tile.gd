extends Node3D

var colorClass: TileColorsDef.colors:
	set(value):
		colorClass = value

var target_position: Vector3:
	set(value):
		target_position = value
		_move_towards_target()


@onready var _manager = get_node('/root/Azuljo/Manager')
@onready var tile = get_node('tile')
@onready var collider = get_node('tile/StaticBody3D')


func _ready():
	var _mat = _manager.matList[colorClass]
	tile.set_surface_override_material(0, _mat)
	collider.mouse_entered.connect(pointed_at)
	collider.mouse_exited.connect(not_pointing)
	collider.input_event.connect(clicked_at)
	pass


func pointed_at():
	get_parent().tile_pointed_at(self)

func not_pointing():
	get_parent().tile_pointed_at_ended(self)

func clicked_at():
	get_parent().tile_clicked_at(self)

func _move_towards_target():
	var start = self.global_position
	var target = self.target_position
	var time = 0
	while Vector3(self.global_position - target).length() > 0.05:
		self.global_position = lerp(start, target, ease(time, -1.9))
		time += 1.3/60
		await get_tree().process_frame

