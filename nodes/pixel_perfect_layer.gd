@icon("../icons/pixel_perfect_layer.svg")
class_name PixelPerfectLayer extends Sprite2D

@export_flags_2d_render var canvas_cull_mask

var camera: Camera2D
var sub_viewport_container: SubViewportContainer
var sub_viewport: SubViewport

func _ready() -> void:
	process_priority = 1000

func _enter_tree() -> void:
	sub_viewport_container = SubViewportContainer.new()

	sub_viewport_container.anchor_left = 0
	sub_viewport_container.anchor_top = 0
	sub_viewport_container.anchor_right = 1
	sub_viewport_container.anchor_bottom = 1
	sub_viewport_container.grow_horizontal = Control.GROW_DIRECTION_BOTH
	sub_viewport_container.grow_vertical = Control.GROW_DIRECTION_BOTH

	sub_viewport_container.stretch = true

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

	if not root_camera:
		return

	var real_position = root_camera.get_screen_center_position()
	var zoom = root_camera.zoom.x

	var real_viewport_size = get_viewport_rect().size / zoom

	sub_viewport.canvas_cull_mask = canvas_cull_mask
	sub_viewport.size = real_viewport_size

	offset = real_viewport_size - Vector2(sub_viewport.size)
	global_position = real_position

	camera.global_position = real_position.floor()
	camera.force_update_scroll()

	var diff = camera.global_position - real_position

	global_position += diff
