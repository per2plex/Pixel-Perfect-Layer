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

	add_autoload_singleton("SPLayerHelper", (preload("./utility/sp_layer_helper.gd") as Resource).resource_path)

func _exit_tree() -> void:
	ProjectSettings.set_setting(Settings.VIEWPORT_CANVAS_CULL_MASK, null)

	remove_custom_type("SPLayer")
	remove_custom_type("SPLayerGroup")

	remove_autoload_singleton("SPLayerHelper")
