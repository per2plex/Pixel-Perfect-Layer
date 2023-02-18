@tool
extends EditorPlugin

const Settings = preload("./utility/settings.gd")
const Defaults = preload("./utility/defaults.gd")

const HELPER_SINGLETON_NAME := "PixelPerfectLayerHelper"
const NODE_NAME := "PixelPerfectLayer"

func _enter_tree() -> void:
	ProjectSettings.set_setting(
		Settings.DEFAULT_VIEWPORT_CANVAS_CULL_MASK,
		Defaults.DEFAULT_VIEWPORT_CANVAS_CULL_MASK
	)

	ProjectSettings.set_initial_value(
		Settings.DEFAULT_VIEWPORT_CANVAS_CULL_MASK,
		Defaults.DEFAULT_VIEWPORT_CANVAS_CULL_MASK
	)

	ProjectSettings.add_property_info({
		"name": Settings.DEFAULT_VIEWPORT_CANVAS_CULL_MASK,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_LAYERS_2D_PHYSICS,
	})

	add_custom_type(
		NODE_NAME,
		"CanvasLayer",
		preload("res://addons/pixel_perfect_layer/nodes/pixel_perfect_layer.gd"),
		preload("res://addons/pixel_perfect_layer/icons/pixel_perfect_layer.svg")
	)

	add_autoload_singleton(HELPER_SINGLETON_NAME, "res://addons/pixel_perfect_layer/utility/pixel_perfect_layer_helper.gd")

func _exit_tree() -> void:
	ProjectSettings.set_setting(Settings.DEFAULT_VIEWPORT_CANVAS_CULL_MASK, null)

	remove_custom_type(NODE_NAME)
	remove_autoload_singleton(HELPER_SINGLETON_NAME)
