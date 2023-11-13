extends Node3D

var colorClass: TileColorsDef.colors:
	set(value):
		colorClass = value

var moving_tween: Tween
var target_position: Vector3:
	set(value):
		target_position = value
		if moving_tween and moving_tween.is_running():
			moving_tween.kill()
		moving_tween = create_tween()
		moving_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		moving_tween.tween_property(self, "global_position", target_position, 0.252)

var size: Vector3

@onready var _manager = get_node("/root/Azuljo/Manager")
@onready var _tile_dragger = get_node("/root/Azuljo/TileDragger")
@onready var tile = get_node("Tile")
@onready var collider = get_node("collider")


func on_drag_start():
	if collider.mouse_entered.is_connected(pointed_at):
		collider.mouse_entered.disconnect(pointed_at)
		collider.mouse_exited.disconnect(not_pointing)
		collider.input_event.disconnect(input_to_click)


func on_drag_end(_target):
	if not collider.mouse_entered.is_connected(pointed_at):
		collider.mouse_entered.connect(pointed_at)
		collider.mouse_exited.connect(not_pointing)
		collider.input_event.connect(input_to_click)


func _ready():
	var _mat = _manager.matList[colorClass]
	tile.set_surface_override_material(0, _mat)
	collider.mouse_entered.connect(pointed_at)
	collider.mouse_exited.connect(not_pointing)
	collider.input_event.connect(input_to_click)

	_tile_dragger.drag_started.connect(on_drag_start)
	_tile_dragger.drag_ended.connect(on_drag_end)

	size = tile.mesh.get_aabb().size


func pointed_at():
	if get_parent().has_method("tile_pointed_at"):
		get_parent().tile_pointed_at(self)


func not_pointing():
	if get_parent().has_method("tile_pointed_at_ended"):
		get_parent().tile_pointed_at_ended(self)


func clicked_at():
	if get_parent().has_method("tile_clicked_at"):
		get_parent().tile_clicked_at(self)


@warning_ignore("unused_parameter")
func input_to_click(camera: Node, event: InputEvent, pos, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked_at()
