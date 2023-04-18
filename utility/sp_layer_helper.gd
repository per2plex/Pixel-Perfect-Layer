extends Node

const Settings = preload("./settings.gd")
const Defaults = preload("./defaults.gd")

func _ready() -> void:
	set_default_viewport_canvas_cull_mask(ProjectSettings.get_setting(
		Settings.VIEWPORT_CANVAS_CULL_MASK,
		Defaults.DEFAULT_VIEWPORT_CANVAS_CULL_MASK
	))

func set_default_viewport_canvas_cull_mask(mask: int) -> void:
	get_viewport().canvas_cull_mask = mask

func get_default_viewport_canvas_cull_mask() -> int:
	return get_viewport().canvas_cull_mask
