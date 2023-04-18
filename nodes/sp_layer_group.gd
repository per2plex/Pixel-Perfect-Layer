@icon("../icons/sp_layer_group.svg")
class_name SPLayerGroup extends Node2D

func _ready() -> void:
	_connect_children()

func _exit_tree() -> void:
	request_ready()

func _connect_children(root: Node2D = self):
	if not root.child_entered_tree.is_connected(_connect_children):
		root.child_entered_tree.connect(_connect_children)

	if not root.tree_exited.is_connected(_disconnect_children):
		root.tree_exited.connect(_disconnect_children)

	root.visibility_layer = visibility_layer

	for child in root.get_children(true):
		if child is Node2D:
			child.visibility_layer = visibility_layer

		_connect_children(child)

func _disconnect_children(root: Node2D = self):
	if root.child_entered_tree.is_connected(_connect_children):
		root.child_entered_tree.disconnect(_connect_children)

	if root.tree_exited.is_connected(_disconnect_children):
		root.tree_exited.disconnect(_disconnect_children)

	for child in root.get_children(true):
		_disconnect_children(child)
