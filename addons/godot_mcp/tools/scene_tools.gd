@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Scene management tools for Godot MCP
## Provides scene operations: get, open, save, create, close, hierarchy


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "management",
			"description": """SCENE MANAGEMENT: Control the currently edited scene in Godot Editor.

ACTIONS:
- get_current: Get info about the currently open scene
- open: Open a scene file by path
- save: Save the current scene
- save_as: Save current scene to a new path
- create: Create a new scene with a root node
- close: Close the current scene
- reload: Reload the current scene from disk

WORKFLOW:
1. Use 'get_current' to understand what scene is open
2. Use 'open' to switch to a different scene
3. Make modifications using node_* tools
4. Use 'save' to persist changes

EXAMPLES:
- Get current scene: {"action": "get_current"}
- Open scene: {"action": "open", "path": "res://scenes/main.tscn"}
- Save scene: {"action": "save"}
- Create new 2D scene: {"action": "create", "root_type": "Node2D", "name": "Level1"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_current", "open", "save", "save_as", "create", "close", "reload"],
						"description": "The scene operation to perform"
					},
					"path": {
						"type": "string",
						"description": "Scene file path (for open, save_as)"
					},
					"root_type": {
						"type": "string",
						"enum": ["Node", "Node2D", "Node3D", "Control", "CanvasLayer"],
						"description": "Root node type for new scene (for create)"
					},
					"name": {
						"type": "string",
						"description": "Scene name (for create)"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "hierarchy",
			"description": """SCENE HIERARCHY: Get the complete node tree structure of the current scene.

ACTIONS:
- get_tree: Get full scene tree with all nodes
- get_selected: Get currently selected nodes in editor
- select: Select nodes by path

OPTIONS:
- depth: Maximum depth to traverse (default: unlimited)
- include_internal: Include internal nodes (default: false)

EXAMPLES:
- Get full tree: {"action": "get_tree"}
- Get tree with depth limit: {"action": "get_tree", "depth": 3}
- Get selected nodes: {"action": "get_selected"}
- Select node: {"action": "select", "paths": ["/root/Player"]}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_tree", "get_selected", "select"],
						"description": "Hierarchy operation"
					},
					"depth": {
						"type": "integer",
						"description": "Maximum depth for tree traversal"
					},
					"include_internal": {
						"type": "boolean",
						"description": "Include internal nodes"
					},
					"paths": {
						"type": "array",
						"items": {"type": "string"},
						"description": "Node paths to select"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "run",
			"description": """SCENE EXECUTION: Run scenes for testing.

ACTIONS:
- play_main: Run the main scene (F5)
- play_current: Run the current scene (F6)
- play_custom: Run a specific scene
- stop: Stop the running scene

EXAMPLES:
- Play main scene: {"action": "play_main"}
- Play current scene: {"action": "play_current"}
- Play specific scene: {"action": "play_custom", "path": "res://scenes/test.tscn"}
- Stop: {"action": "stop"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["play_main", "play_current", "play_custom", "stop"],
						"description": "Run action"
					},
					"path": {
						"type": "string",
						"description": "Scene path for play_custom"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"management":
			return _execute_management(args)
		"hierarchy":
			return _execute_hierarchy(args)
		"run":
			return _execute_run(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


func _execute_management(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get_current":
			return _get_current_scene()
		"open":
			return _open_scene(args.get("path", ""))
		"save":
			return _save_scene()
		"save_as":
			return _save_scene_as(args.get("path", ""))
		"create":
			return _create_scene(args.get("root_type", "Node"), args.get("name", "NewScene"))
		"close":
			return _close_scene()
		"reload":
			return _reload_scene()
		_:
			return _error("Unknown action: %s" % action)


func _execute_hierarchy(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get_tree":
			return _get_scene_tree(args.get("depth", -1), args.get("include_internal", false))
		"get_selected":
			return _get_selected_nodes()
		"select":
			return _select_nodes(args.get("paths", []))
		_:
			return _error("Unknown action: %s" % action)


func _execute_run(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	match action:
		"play_main":
			ei.play_main_scene()
			return _success(null, "Playing main scene")
		"play_current":
			ei.play_current_scene()
			return _success(null, "Playing current scene")
		"play_custom":
			var path = args.get("path", "")
			if path.is_empty():
				return _error("Path required for play_custom")
			ei.play_custom_scene(path)
			return _success(null, "Playing scene: %s" % path)
		"stop":
			ei.stop_playing_scene()
			return _success(null, "Stopped playing scene")
		_:
			return _error("Unknown action: %s" % action)


func _get_current_scene() -> Dictionary:
	var root = _get_edited_scene_root()
	if not root:
		return _success({
			"open": false,
			"message": "No scene currently open"
		})

	var ei = _get_editor_interface()
	var scene_path = str(root.scene_file_path)

	return _success({
		"open": true,
		"path": scene_path,
		"name": str(root.name),
		"root_type": str(root.get_class()),
		"node_count": _count_nodes(root)
	})


func _count_nodes(node: Node) -> int:
	var count = 1
	for child in node.get_children():
		count += _count_nodes(child)
	return count


func _open_scene(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	if not FileAccess.file_exists(path):
		return _error("Scene file not found: %s" % path)

	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	ei.open_scene_from_path(path)
	return _success({"path": path}, "Scene opened: %s" % path)


func _save_scene() -> Dictionary:
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene to save")

	var error = ei.save_scene()
	if error != OK:
		return _error("Failed to save scene: %s" % error_string(error))

	return _success({"path": root.scene_file_path}, "Scene saved")


func _save_scene_as(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	if not path.ends_with(".tscn"):
		path += ".tscn"

	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene to save")

	var packed_scene = PackedScene.new()
	packed_scene.pack(root)

	var error = ResourceSaver.save(packed_scene, path)
	if error != OK:
		return _error("Failed to save scene: %s" % error_string(error))

	return _success({"path": path}, "Scene saved as: %s" % path)


func _create_scene(root_type: String, scene_name: String) -> Dictionary:
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	# Create root node based on type
	var root: Node
	match root_type:
		"Node":
			root = Node.new()
		"Node2D":
			root = Node2D.new()
		"Node3D":
			root = Node3D.new()
		"Control":
			root = Control.new()
		"CanvasLayer":
			root = CanvasLayer.new()
		_:
			return _error("Unknown root type: %s" % root_type)

	root.name = scene_name

	# Create a packed scene and open it
	var packed_scene = PackedScene.new()
	packed_scene.pack(root)

	var temp_path = "res://%s.tscn" % scene_name.to_lower().replace(" ", "_")

	var error = ResourceSaver.save(packed_scene, temp_path)
	if error != OK:
		root.queue_free()
		return _error("Failed to create scene: %s" % error_string(error))

	root.queue_free()

	ei.open_scene_from_path(temp_path)

	return _success({
		"path": temp_path,
		"root_type": root_type,
		"name": scene_name
	}, "Scene created: %s" % temp_path)


func _close_scene() -> Dictionary:
	# Godot doesn't have a direct close scene API
	# We can create a new empty scene effectively "closing" the current one
	return _error("Close scene not directly supported. Use File > Close Scene in the editor.")


func _reload_scene() -> Dictionary:
	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene to reload")

	var path = root.scene_file_path
	if path.is_empty():
		return _error("Scene has not been saved yet")

	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	ei.reload_scene_from_path(path)
	return _success({"path": path}, "Scene reloaded: %s" % path)


func _get_scene_tree(max_depth: int, include_internal: bool) -> Dictionary:
	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = _build_tree_recursive(root, 0, max_depth, include_internal)
	return _success({
		"root": tree,
		"scene_path": root.scene_file_path
	})


func _build_tree_recursive(node: Node, current_depth: int, max_depth: int, include_internal: bool) -> Dictionary:
	var result = _node_to_dict(node, false)

	# Check depth limit
	if max_depth >= 0 and current_depth >= max_depth:
		result["children_truncated"] = node.get_child_count() > 0
		return result

	var children: Array[Dictionary] = []
	for i in node.get_child_count(include_internal):
		var child = node.get_child(i, include_internal)
		children.append(_build_tree_recursive(child, current_depth + 1, max_depth, include_internal))

	if not children.is_empty():
		result["children"] = children

	return result


func _get_selected_nodes() -> Dictionary:
	var selection = _get_selection()
	if not selection:
		return _error("Selection not available")

	var selected = selection.get_selected_nodes()
	var nodes: Array[Dictionary] = []

	for node in selected:
		nodes.append(_node_to_dict(node, false))

	return _success({
		"count": nodes.size(),
		"nodes": nodes
	})


func _select_nodes(paths: Array) -> Dictionary:
	var selection = _get_selection()
	if not selection:
		return _error("Selection not available")

	selection.clear()

	var selected_count = 0
	var errors: Array[String] = []

	for path in paths:
		var node = _find_node_by_path(path)
		if node:
			selection.add_node(node)
			selected_count += 1
		else:
			errors.append("Node not found: %s" % path)

	var result = {
		"selected": selected_count,
		"requested": paths.size()
	}

	if not errors.is_empty():
		result["errors"] = errors

	return _success(result, "Selected %d nodes" % selected_count)
