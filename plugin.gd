@tool
extends EditorPlugin

const Settings = preload("./utility/settings.gd")
const Defaults = preload("./utility/defaults.gd")

func _enter_tree() -> void:
	ProjectSettings.set_setting(
		Settings.VIEWPORT_CANVAS_CULL_MASK,
		Defaults.DEFAULT_VIEWPORT_CANVAS_CULL_MASK
	)

	ProjectSettings.set_initial_value(
		Settings.VIEWPORT_CANVAS_CULL_MASK,
		Defaults.DEFAULT_VIEWPORT_CANVAS_CULL_MASK
	)

	ProjectSettings.add_property_info({
		"name": Settings.VIEWPORT_CANVAS_CULL_MASK,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_LAYERS_2D_PHYSICS,
	})

	add_custom_type(
		"SPLayer",
		"Sprite2D",
		preload("./nodes/sp_layer.gd"),
		preload("./icons/sp_layer.svg")
	)

	add_custom_type(
		"SPLayerGroup",
		"Node2D",
		preload("./nodes/sp_layer_group.gd"),
		preload("./icons/sp_layer_group.svg")
	)

	ProjectSettings.set_setting(
		"shader_globals/sp_camera_offset",
		{
			"type": "vec2",
			"value": Vector2(0, 0)
		}
	)

	ProjectSettings.set_setting(
		"shader_globals/sp_camera_zoom",
		{
			"type": "float",
			"value": 0
		}
	)

	ProjectSettings.set_setting(
		"shader_globals/sp_pixel_camera_offset",
		{
			"type": "vec2",
			"value": Vector2(0, 0)
		}
	)

	ProjectSettings.set_setting(
		"shader_globals/sp_dither_pattern",
		{
			"type": "sampler2D",
			"value": "res://addons/smooth-pixels/shaders/dither_4x4.png"
		}
	)

	add_autoload_singleton("SPLayerHelper", (preload("./utility/sp_layer_helper.gd") as Resource).resource_path)
	add_autoload_singleton("SPCameraHelper", (preload("./utility/sp_camera_helper.gd") as Resource).resource_path)

func _exit_tree() -> void:
	ProjectSettings.set_setting(Settings.VIEWPORT_CANVAS_CULL_MASK, null)

	remove_custom_type("SPLayer")
	remove_custom_type("SPLayerGroup")

	remove_autoload_singleton("SPLayerHelper")
	remove_autoload_singleton("SPCameraHelper")
