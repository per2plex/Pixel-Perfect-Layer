@icon("../icons/pixel_perfect_layer.svg")
class_name PixelPerfectLayer extends Sprite2D

@export_flags_2d_render var canvas_cull_mask

@export var target: Node2D = null
@export var use_viewport_camera: bool = false
@export var size = Vector2.ZERO

var camera: Camera2D
var sub_viewport: SubViewport

func _ready() -> void:
	sub_viewport = SubViewport.new()

	sub_viewport.world_2d = get_viewport().world_2d
	sub_viewport.transparent_bg = true
	sub_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sub_viewport.snap_2d_transforms_to_pixel = true
	sub_viewport.snap_2d_vertices_to_pixel = true

	sub_viewport.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	sub_viewport.canvas_cull_mask = canvas_cull_mask

	camera = Camera2D.new()

	sub_viewport.add_child(camera)
	add_child(sub_viewport, false, Node.INTERNAL_MODE_BACK)

	camera.make_current()

	texture = sub_viewport.get_texture()

func _process(delta: float) -> void:
	var root_camera = get_viewport().get_camera_2d()
	var real_target = get_parent() as Node2D

	if target:
		real_target = target

	if use_viewport_camera:
		top_level = true
		real_target = root_camera

	if not root_camera or not real_target:
		return

	var real_position = real_target.get_screen_center_position() \
		if real_target is Camera2D \
		else real_target.global_position

	var real_viewport_size = get_viewport_rect().size / root_camera.zoom

	sub_viewport.canvas_cull_mask = canvas_cull_mask

	if size != Vector2.ZERO:
		sub_viewport.size = size
	else:
		sub_viewport.size = real_viewport_size

	camera.global_position = real_position.floor()
	var diff = camera.global_position - real_position

	if use_viewport_camera:
		global_position = real_position
		global_position += diff

		camera.global_position = real_position + diff
	else:
		camera.global_position = real_position + diff

	camera.force_update_scroll()

