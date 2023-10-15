extends Node3D

var colorClass: TileColorsDef.colors:
	set(value):
		colorClass = value

var target_position: Vector3:
	set(value):
		target_position = value
		_move_towards_target()

var size: Vector3

@onready var _manager = get_node('/root/Azuljo/Manager')
@onready var tile = get_node('StaticBody3D/tile')
@onready var collider = get_node('StaticBody3D')

func _ready():
	var _mat = _manager.matList[colorClass]
	tile.set_surface_override_material(0, _mat)
	collider.mouse_entered.connect(pointed_at)
	collider.mouse_exited.connect(not_pointing)
	collider.input_event.connect(input_to_click)

	size = tile.mesh.get_aabb().size

func pointed_at():
	if get_parent().has_method("tile_pointed_at"):
		get_parent().tile_pointed_at(self)

func not_pointing():
	if get_parent().has_method("tile_pointed_at_ended"):
		get_parent().tile_pointed_at_ended(self)

func input_to_click(camera: Node, event:InputEvent, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked_at()

func clicked_at():
	get_parent().tile_clicked_at(self)

func _move_towards_target():
	var start = self.global_position
	var target = self.target_position
	var time = 0
	while Vector3(self.global_position - target).length() > 0.006:
		self.global_position = lerp(start, target, ease(time, -1.721))
		time += 1/Engine.get_frames_per_second()/0.452
		await get_tree().process_frame
	self.global_position = target
