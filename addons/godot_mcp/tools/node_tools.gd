@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Node operation tools for Godot MCP
## Comprehensive node management including signals, groups, transforms, properties, and more


func get_tools() -> Array[Dictionary]:
	return [
		# ==================== QUERY ====================
		{
			"name": "query",
			"description": """NODE QUERY: Find and inspect nodes in the scene.

ACTIONS:
- find_by_name: Find nodes by name pattern (wildcards: *, ?)
- find_by_type: Find nodes by class type
- find_children: Find children matching pattern and/or type
- find_parent: Find parent node matching pattern
- get_info: Get detailed node information
- get_children: Get direct children
- get_path_to: Get relative path to another node
- tree_string: Get scene tree as formatted string

EXAMPLES:
- Find by name: {"action": "find_by_name", "pattern": "Player*"}
- Find by type: {"action": "find_by_type", "type": "Sprite2D"}
- Find children: {"action": "find_children", "path": "/root", "pattern": "*Enemy*", "type": "CharacterBody2D", "recursive": true}
- Get path to: {"action": "get_path_to", "from_path": "/root/Player", "to_path": "/root/Enemy"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["find_by_name", "find_by_type", "find_children", "find_parent", "get_info", "get_children", "get_path_to", "tree_string"]},
					"pattern": {"type": "string", "description": "Name pattern (supports * and ? wildcards)"},
					"type": {"type": "string", "description": "Node class type"},
					"path": {"type": "string", "description": "Node path"},
					"from_path": {"type": "string", "description": "Source node path"},
					"to_path": {"type": "string", "description": "Target node path"},
					"recursive": {"type": "boolean", "description": "Search recursively (default: true)"},
					"owned": {"type": "boolean", "description": "Only owned nodes (default: true)"}
				},
				"required": ["action"]
			}
		},
		# ==================== LIFECYCLE ====================
		{
			"name": "lifecycle",
			"description": """NODE LIFECYCLE: Create, delete, duplicate, and manage node instances.

ACTIONS:
- create: Create new node by type
- delete: Delete node (queue_free)
- duplicate: Duplicate node with options
- instantiate: Instantiate a PackedScene
- replace: Replace node with another
- request_ready: Request _ready callback

DUPLICATE FLAGS:
- signals: Copy signal connections
- groups: Copy group memberships
- scripts: Copy attached scripts

EXAMPLES:
- Create: {"action": "create", "type": "Sprite2D", "name": "Player", "parent_path": "/root"}
- Delete: {"action": "delete", "path": "/root/OldNode"}
- Duplicate: {"action": "duplicate", "path": "/root/Enemy", "new_name": "Enemy2", "flags": ["signals", "groups"]}
- Instantiate: {"action": "instantiate", "scene_path": "res://bullet.tscn", "parent_path": "/root"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["create", "delete", "duplicate", "instantiate", "replace", "request_ready"]},
					"type": {"type": "string"},
					"name": {"type": "string"},
					"path": {"type": "string"},
					"parent_path": {"type": "string"},
					"scene_path": {"type": "string"},
					"new_name": {"type": "string"},
					"new_node_path": {"type": "string", "description": "Replacement node path"},
					"flags": {"type": "array", "items": {"type": "string"}, "description": "Duplicate flags: signals, groups, scripts"}
				},
				"required": ["action"]
			}
		},
		# ==================== TRANSFORM ====================
		{
			"name": "transform",
			"description": """NODE TRANSFORM: Modify position, rotation, scale.

ACTIONS:
- set_position: Set absolute position
- set_rotation: Set rotation (radians)
- set_rotation_degrees: Set rotation (degrees)
- set_scale: Set scale
- get_transform: Get current transform values
- move: Move by offset (relative)
- rotate: Rotate by angle (relative)
- look_at: Make node look at position (2D/3D)
- reset: Reset to identity transform

COORDINATE SYSTEMS:
- 2D: position (x, y), rotation (radians), scale (x, y)
- 3D: position (x, y, z), rotation (x, y, z) euler, scale (x, y, z)
- Control: position, rotation, scale, size, pivot_offset

EXAMPLES:
- Set position: {"action": "set_position", "path": "/root/Player", "x": 100, "y": 200}
- Move by offset: {"action": "move", "path": "/root/Player", "x": 10, "y": 0}
- Look at: {"action": "look_at", "path": "/root/Player", "x": 500, "y": 300}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["set_position", "set_rotation", "set_rotation_degrees", "set_scale", "get_transform", "move", "rotate", "look_at", "reset"]},
					"path": {"type": "string"},
					"x": {"type": "number"},
					"y": {"type": "number"},
					"z": {"type": "number"},
					"radians": {"type": "number"},
					"degrees": {"type": "number"},
					"global": {"type": "boolean", "description": "Use global coordinates"}
				},
				"required": ["action", "path"]
			}
		},
		# ==================== PROPERTY ====================
		{
			"name": "property",
			"description": """NODE PROPERTY: Get and set any node property.

ACTIONS:
- get: Get property value
- set: Set property value
- list: List all editable properties
- reset: Reset to default
- revert: Check if can revert and get revert value

TYPE CONVERSION:
- Vector2/3: {"x": 1, "y": 2} or {"x": 1, "y": 2, "z": 3}
- Color: {"r": 1, "g": 0.5, "b": 0, "a": 1} or "#FF8800"
- Resource: "res://path/to/resource.tres"

EXAMPLES:
- Get: {"action": "get", "path": "/root/Player", "property": "position"}
- Set: {"action": "set", "path": "/root/Player", "property": "visible", "value": false}
- List: {"action": "list", "path": "/root/Player", "filter": "collision"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["get", "set", "list", "reset", "revert"]},
					"path": {"type": "string"},
					"property": {"type": "string"},
					"value": {},
					"filter": {"type": "string", "description": "Filter properties by name"}
				},
				"required": ["action", "path"]
			}
		},
		# ==================== HIERARCHY ====================
		{
			"name": "hierarchy",
			"description": """NODE HIERARCHY: Manage parent-child relationships.

ACTIONS:
- reparent: Move to new parent (keeps global transform by default)
- reorder: Set position among siblings
- move_up/move_down: Move in sibling order
- move_to_front/move_to_back: Move to first/last
- set_owner: Set scene owner
- get_owner: Get current owner

EXAMPLES:
- Reparent: {"action": "reparent", "path": "/root/Child", "new_parent": "/root/NewParent"}
- Reparent (local): {"action": "reparent", "path": "/root/Child", "new_parent": "/root/NewParent", "keep_global": false}
- Reorder: {"action": "reorder", "path": "/root/Parent/Child", "index": 0}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["reparent", "reorder", "move_up", "move_down", "move_to_front", "move_to_back", "set_owner", "get_owner"]},
					"path": {"type": "string"},
					"new_parent": {"type": "string"},
					"index": {"type": "integer"},
					"keep_global": {"type": "boolean", "description": "Keep global transform when reparenting (default: true)"},
					"owner_path": {"type": "string"}
				},
				"required": ["action", "path"]
			}
		},
		# ==================== SIGNAL ====================
		{
			"name": "signal",
			"description": """SIGNAL OPERATIONS: Comprehensive signal management.

ACTIONS:
- list: List all signals on a node
- has: Check if node has a signal
- get_connections: Get outgoing connections for a signal
- get_incoming: Get signals connected TO this node
- connect: Connect signal to method
- disconnect: Disconnect signal
- disconnect_all: Disconnect all connections of a signal
- is_connected: Check if signal is connected
- emit: Emit signal with arguments
- add_user_signal: Add custom signal
- remove_user_signal: Remove custom signal

CONNECTION FLAGS:
- deferred: Call deferred (next frame)
- persist: Persist in saved scene
- one_shot: Disconnect after first emit

EXAMPLES:
- List: {"action": "list", "path": "/root/Button"}
- Connect: {"action": "connect", "source_path": "/root/Button", "signal_name": "pressed", "target_path": "/root/Player", "method": "_on_pressed"}
- Connect one-shot: {"action": "connect", "source_path": "/root/Timer", "signal_name": "timeout", "target_path": "/root/Game", "method": "_on_timeout", "flags": ["one_shot"]}
- Emit: {"action": "emit", "path": "/root/Player", "signal_name": "health_changed", "args": [100]}
- Add user signal: {"action": "add_user_signal", "path": "/root/Player", "signal_name": "custom_event", "args": [{"name": "value", "type": "int"}]}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["list", "has", "get_connections", "get_incoming", "connect", "disconnect", "disconnect_all", "is_connected", "emit", "add_user_signal", "remove_user_signal"]},
					"path": {"type": "string"},
					"source_path": {"type": "string"},
					"target_path": {"type": "string"},
					"signal_name": {"type": "string"},
					"method": {"type": "string"},
					"args": {"type": "array"},
					"flags": {"type": "array", "items": {"type": "string"}, "description": "Connection flags: deferred, persist, one_shot"}
				},
				"required": ["action"]
			}
		},
		# ==================== GROUP ====================
		{
			"name": "group",
			"description": """GROUP OPERATIONS: Manage node groups.

ACTIONS:
- list: List all groups a node belongs to
- add: Add node to group
- remove: Remove from group
- is_in: Check if node is in group
- get_nodes: Get all nodes in a group
- get_first: Get first node in group
- count: Count nodes in group
- call_group: Call method on all nodes in group
- notify_group: Send notification to group
- set_group: Set property on all nodes in group

EXAMPLES:
- List groups: {"action": "list", "path": "/root/Player"}
- Add to group: {"action": "add", "path": "/root/Player", "group": "players", "persistent": true}
- Get nodes: {"action": "get_nodes", "group": "enemies"}
- Call method: {"action": "call_group", "group": "enemies", "method": "take_damage", "args": [10]}
- Set property: {"action": "set_group", "group": "ui_elements", "property": "visible", "value": false}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["list", "add", "remove", "is_in", "get_nodes", "get_first", "count", "call_group", "notify_group", "set_group"]},
					"path": {"type": "string"},
					"group": {"type": "string"},
					"method": {"type": "string"},
					"property": {"type": "string"},
					"value": {},
					"args": {"type": "array"},
					"notification": {"type": "integer"},
					"persistent": {"type": "boolean", "description": "Save group with scene (default: true)"}
				},
				"required": ["action"]
			}
		},
		# ==================== PROCESS ====================
		{
			"name": "process",
			"description": """PROCESS CONTROL: Manage node processing and input.

ACTIONS:
- get_status: Get all process flags status
- set_process: Enable/disable _process()
- set_physics_process: Enable/disable _physics_process()
- set_input: Enable/disable _input()
- set_unhandled_input: Enable/disable _unhandled_input()
- set_unhandled_key_input: Enable/disable _unhandled_key_input()
- set_shortcut_input: Enable/disable _shortcut_input()
- set_process_mode: Set process mode (inherit, pausable, when_paused, always, disabled)
- set_process_priority: Set process priority
- set_physics_priority: Set physics process priority

PROCESS MODES:
0=INHERIT, 1=PAUSABLE, 2=WHEN_PAUSED, 3=ALWAYS, 4=DISABLED

EXAMPLES:
- Get status: {"action": "get_status", "path": "/root/Player"}
- Enable process: {"action": "set_process", "path": "/root/Player", "enabled": true}
- Set mode: {"action": "set_process_mode", "path": "/root/UI", "mode": "always"}
- Set priority: {"action": "set_process_priority", "path": "/root/Player", "priority": 100}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["get_status", "set_process", "set_physics_process", "set_input", "set_unhandled_input", "set_unhandled_key_input", "set_shortcut_input", "set_process_mode", "set_process_priority", "set_physics_priority"]},
					"path": {"type": "string"},
					"enabled": {"type": "boolean"},
					"mode": {"type": "string", "enum": ["inherit", "pausable", "when_paused", "always", "disabled"]},
					"priority": {"type": "integer"}
				},
				"required": ["action", "path"]
			}
		},
		# ==================== METADATA ====================
		{
			"name": "metadata",
			"description": """METADATA OPERATIONS: Manage custom node metadata.

ACTIONS:
- get: Get metadata value
- set: Set metadata value
- has: Check if metadata exists
- remove: Remove metadata
- list: List all metadata keys

USES: Store custom data without modifying node class.

EXAMPLES:
- Set: {"action": "set", "path": "/root/Enemy", "key": "spawn_point", "value": {"x": 100, "y": 200}}
- Get: {"action": "get", "path": "/root/Enemy", "key": "spawn_point"}
- List: {"action": "list", "path": "/root/Enemy"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["get", "set", "has", "remove", "list"]},
					"path": {"type": "string"},
					"key": {"type": "string"},
					"value": {}
				},
				"required": ["action", "path"]
			}
		},
		# ==================== CALL ====================
		{
			"name": "call",
			"description": """METHOD CALLING: Call methods on nodes.

ACTIONS:
- call: Call method immediately
- call_deferred: Call method next frame
- propagate_call: Call method on node and all descendants
- has_method: Check if method exists
- get_method_list: List all methods

EXAMPLES:
- Call method: {"action": "call", "path": "/root/Player", "method": "take_damage", "args": [10]}
- Deferred call: {"action": "call_deferred", "path": "/root/UI", "method": "update_score"}
- Propagate: {"action": "propagate_call", "path": "/root/Enemies", "method": "reset", "parent_first": true}
- Check method: {"action": "has_method", "path": "/root/Player", "method": "jump"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["call", "call_deferred", "propagate_call", "has_method", "get_method_list"]},
					"path": {"type": "string"},
					"method": {"type": "string"},
					"args": {"type": "array"},
					"parent_first": {"type": "boolean", "description": "Call parent before children (default: false)"},
					"filter": {"type": "string", "description": "Filter methods by name"}
				},
				"required": ["action", "path"]
			}
		},
		# ==================== VISIBILITY ====================
		{
			"name": "visibility",
			"description": """VISIBILITY CONTROL: Manage node rendering.

ACTIONS:
- show: Make visible
- hide: Make invisible
- toggle: Toggle visibility
- is_visible: Check visibility
- set_z_index: Set 2D draw order
- set_z_relative: Set Z relative to parent
- set_y_sort: Enable Y-sorting
- set_modulate: Set color modulation
- set_self_modulate: Set self modulation only
- set_visibility_layer: Set visibility layer bits

EXAMPLES:
- Hide: {"action": "hide", "path": "/root/Enemy"}
- Z-index: {"action": "set_z_index", "path": "/root/Player", "value": 10}
- Modulate: {"action": "set_modulate", "path": "/root/Sprite", "color": {"r": 1, "g": 0, "b": 0, "a": 0.5}}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["show", "hide", "toggle", "is_visible", "set_z_index", "set_z_relative", "set_y_sort", "set_modulate", "set_self_modulate", "set_visibility_layer"]},
					"path": {"type": "string"},
					"value": {},
					"color": {"type": "object"},
					"enabled": {"type": "boolean"}
				},
				"required": ["action", "path"]
			}
		},
		# ==================== PHYSICS ====================
		{
			"name": "physics",
			"description": """PHYSICS CONTROL: Configure collision and physics.

ACTIONS:
- get_collision_info: Get collision layer/mask info
- set_collision_layer: Set collision layer (bitmask or layer number)
- set_collision_mask: Set collision mask
- set_collision_layer_value: Set specific layer bit
- set_collision_mask_value: Set specific mask bit
- apply_impulse: Apply impulse to RigidBody
- apply_force: Apply force to RigidBody
- apply_torque: Apply rotational force
- set_linear_velocity: Set linear velocity
- set_angular_velocity: Set angular velocity

LAYER HELPERS: Use layer numbers 1-32 or bitmask.

EXAMPLES:
- Get info: {"action": "get_collision_info", "path": "/root/Player"}
- Set layer: {"action": "set_collision_layer_value", "path": "/root/Player", "layer": 1, "value": true}
- Apply impulse: {"action": "apply_impulse", "path": "/root/Ball", "x": 100, "y": -200}
- Set velocity: {"action": "set_linear_velocity", "path": "/root/Projectile", "x": 500, "y": 0}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {"type": "string", "enum": ["get_collision_info", "set_collision_layer", "set_collision_mask", "set_collision_layer_value", "set_collision_mask_value", "apply_impulse", "apply_force", "apply_torque", "set_linear_velocity", "set_angular_velocity"]},
					"path": {"type": "string"},
					"layer": {"type": "integer"},
					"value": {},
					"x": {"type": "number"},
					"y": {"type": "number"},
					"z": {"type": "number"}
				},
				"required": ["action", "path"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"query": return _execute_query(args)
		"lifecycle": return _execute_lifecycle(args)
		"transform": return _execute_transform(args)
		"property": return _execute_property(args)
		"hierarchy": return _execute_hierarchy(args)
		"signal": return _execute_signal(args)
		"group": return _execute_group(args)
		"process": return _execute_process(args)
		"metadata": return _execute_metadata(args)
		"call": return _execute_call(args)
		"visibility": return _execute_visibility(args)
		"physics": return _execute_physics(args)
		_: return _error("Unknown tool: %s" % tool_name)


# ==================== QUERY ====================

func _execute_query(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"find_by_name":
			return _find_by_name(args.get("pattern", ""))
		"find_by_type":
			return _find_by_type(args.get("type", ""))
		"find_children":
			return _find_children(args)
		"find_parent":
			return _find_parent(args.get("path", ""), args.get("pattern", ""))
		"get_info":
			return _get_node_info(args.get("path", ""))
		"get_children":
			return _get_node_children(args.get("path", ""))
		"get_path_to":
			return _get_path_to(args.get("from_path", ""), args.get("to_path", ""))
		"tree_string":
			return _get_tree_string(args.get("path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _find_by_name(pattern: String) -> Dictionary:
	if pattern.is_empty():
		return _error("Pattern is required")

	var nodes = _find_nodes_by_name(pattern)
	var results: Array[Dictionary] = []
	for node in nodes:
		results.append(_node_to_dict(node, false))

	return _success({"count": results.size(), "nodes": results})


func _find_by_type(type_name: String) -> Dictionary:
	if type_name.is_empty():
		return _error("Type is required")

	var nodes = _find_nodes_by_type(type_name)
	var results: Array[Dictionary] = []
	for node in nodes:
		results.append(_node_to_dict(node, false))

	return _success({"count": results.size(), "nodes": results})


func _find_children(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var pattern = args.get("pattern", "*")
	var type_filter = args.get("type", "")
	var recursive = args.get("recursive", true)
	var owned = args.get("owned", true)

	var node = _find_node_by_path(path) if not path.is_empty() else _get_edited_scene_root()
	if not node:
		return _error("Node not found: %s" % path)

	var found = node.find_children(pattern, type_filter, recursive, owned)
	var results: Array[Dictionary] = []
	for child in found:
		results.append(_node_to_dict(child, false))

	return _success({"count": results.size(), "nodes": results})


func _find_parent(path: String, pattern: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if pattern.is_empty():
		return _error("Pattern is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var found = node.find_parent(pattern)
	if found:
		return _success(_node_to_dict(found, false))
	else:
		return _success({"found": false, "message": "No parent matching pattern found"})


func _get_node_info(path: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var info = _node_to_dict(node, true, 1)
	info["class_name"] = str(node.get_class())
	info["child_count"] = node.get_child_count()
	info["has_script"] = node.get_script() != null
	info["is_inside_tree"] = node.is_inside_tree()
	info["is_ready"] = node.is_node_ready()

	# Groups
	var groups: Array[String] = []
	for group in node.get_groups():
		groups.append(str(group))
	info["groups"] = groups

	# Process status
	info["processing"] = node.is_processing()
	info["physics_processing"] = node.is_physics_processing()
	info["process_mode"] = node.process_mode

	# Owner
	var owner = node.owner
	info["owner"] = _get_scene_path(owner) if owner else null

	return _success(info)


func _get_node_children(path: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var children: Array[Dictionary] = []
	for child in node.get_children():
		children.append(_node_to_dict(child, false))

	return _success({"path": path, "count": children.size(), "children": children})


func _get_path_to(from_path: String, to_path: String) -> Dictionary:
	var from_node = _find_node_by_path(from_path)
	if not from_node:
		return _error("From node not found: %s" % from_path)

	var to_node = _find_node_by_path(to_path)
	if not to_node:
		return _error("To node not found: %s" % to_path)

	var relative_path = from_node.get_path_to(to_node)
	return _success({
		"from": from_path,
		"to": to_path,
		"relative_path": str(relative_path)
	})


func _get_tree_string(path: String) -> Dictionary:
	var node = _find_node_by_path(path) if not path.is_empty() else _get_edited_scene_root()
	if not node:
		return _error("Node not found")

	var tree_str = _build_tree_string(node, 0)
	return _success({"tree": tree_str})


func _build_tree_string(node: Node, depth: int) -> String:
	var indent = "  ".repeat(depth)
	var result = indent + str(node.name) + " (" + str(node.get_class()) + ")\n"
	for child in node.get_children():
		result += _build_tree_string(child, depth + 1)
	return result


# ==================== LIFECYCLE ====================

func _execute_lifecycle(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_node(args.get("type", "Node"), args.get("name", ""), args.get("parent_path", ""))
		"delete":
			return _delete_node(args.get("path", ""))
		"duplicate":
			return _duplicate_node(args.get("path", ""), args.get("new_name", ""), args.get("flags", []))
		"instantiate":
			return _instantiate_scene(args.get("scene_path", ""), args.get("parent_path", ""), args.get("name", ""))
		"replace":
			return _replace_node(args.get("path", ""), args.get("new_node_path", ""))
		"request_ready":
			return _request_ready(args.get("path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _create_node(type_name: String, node_name: String, parent_path: String) -> Dictionary:
	if type_name.is_empty():
		return _error("Type is required")

	var parent = _find_node_by_path(parent_path) if not parent_path.is_empty() else _get_edited_scene_root()
	if not parent:
		return _error("Parent node not found: %s" % parent_path)

	var node = ClassDB.instantiate(type_name)
	if not node:
		return _error("Failed to create node of type: %s" % type_name)

	if not node_name.is_empty():
		node.name = node_name

	parent.add_child(node)
	node.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(node),
		"type": type_name,
		"name": str(node.name)
	}, "Node created: %s" % str(node.name))


func _delete_node(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node == _get_edited_scene_root():
		return _error("Cannot delete scene root node")

	var name = str(node.name)
	node.queue_free()

	return _success({"deleted": path}, "Node deleted: %s" % name)


func _duplicate_node(path: String, new_name: String, flags: Array) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	# Build flags bitmask
	var flag_value = 0
	if "signals" in flags or flags.is_empty():
		flag_value |= Node.DUPLICATE_SIGNALS
	if "groups" in flags or flags.is_empty():
		flag_value |= Node.DUPLICATE_GROUPS
	if "scripts" in flags or flags.is_empty():
		flag_value |= Node.DUPLICATE_SCRIPTS

	var duplicated = node.duplicate(flag_value)
	if not duplicated:
		return _error("Failed to duplicate node")

	if not new_name.is_empty():
		duplicated.name = new_name

	var parent = node.get_parent()
	parent.add_child(duplicated)
	duplicated.owner = _get_edited_scene_root()

	return _success({
		"original": path,
		"new_path": _get_scene_path(duplicated),
		"name": str(duplicated.name)
	}, "Node duplicated: %s" % str(duplicated.name))


func _instantiate_scene(scene_path: String, parent_path: String, instance_name: String) -> Dictionary:
	if scene_path.is_empty():
		return _error("Scene path is required")

	if not scene_path.begins_with("res://"):
		scene_path = "res://" + scene_path

	if not ResourceLoader.exists(scene_path):
		return _error("Scene not found: %s" % scene_path)

	var packed_scene = load(scene_path) as PackedScene
	if not packed_scene:
		return _error("Failed to load scene: %s" % scene_path)

	var instance = packed_scene.instantiate()
	if not instance:
		return _error("Failed to instantiate scene")

	if not instance_name.is_empty():
		instance.name = instance_name

	var parent = _find_node_by_path(parent_path) if not parent_path.is_empty() else _get_edited_scene_root()
	if not parent:
		instance.queue_free()
		return _error("Parent node not found: %s" % parent_path)

	parent.add_child(instance)
	instance.owner = _get_edited_scene_root()

	return _success({
		"scene": scene_path,
		"path": _get_scene_path(instance),
		"name": str(instance.name)
	}, "Scene instantiated: %s" % str(instance.name))


func _replace_node(path: String, new_node_path: String) -> Dictionary:
	if path.is_empty() or new_node_path.is_empty():
		return _error("Both paths are required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var new_node = _find_node_by_path(new_node_path)
	if not new_node:
		return _error("New node not found: %s" % new_node_path)

	node.replace_by(new_node)

	return _success({
		"replaced": path,
		"replacement": _get_scene_path(new_node)
	}, "Node replaced")


func _request_ready(path: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	node.request_ready()
	return _success({"path": path}, "Ready requested")


# ==================== TRANSFORM ====================

func _execute_transform(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	match action:
		"set_position": return _set_position(node, args)
		"set_rotation": return _set_rotation(node, args.get("radians", 0.0), args)
		"set_rotation_degrees": return _set_rotation(node, deg_to_rad(args.get("degrees", 0.0)), args)
		"set_scale": return _set_scale(node, args)
		"get_transform": return _get_transform(node)
		"move": return _move_node(node, args)
		"rotate": return _rotate_node(node, args)
		"look_at": return _look_at(node, args)
		"reset": return _reset_transform(node)
		_: return _error("Unknown action: %s" % action)


func _set_position(node: Node, args: Dictionary) -> Dictionary:
	var x = args.get("x", 0.0)
	var y = args.get("y", 0.0)
	var z = args.get("z", 0.0)
	var use_global = args.get("global", false)

	if node is Node2D:
		if use_global:
			node.global_position = Vector2(x, y)
		else:
			node.position = Vector2(x, y)
	elif node is Node3D:
		if use_global:
			node.global_position = Vector3(x, y, z)
		else:
			node.position = Vector3(x, y, z)
	elif node is Control:
		if use_global:
			node.global_position = Vector2(x, y)
		else:
			node.position = Vector2(x, y)
	else:
		return _error("Node does not support position")

	return _success({
		"path": _get_scene_path(node),
		"position": _get_position_dict(node),
		"global": use_global
	}, "Position set")


func _set_rotation(node: Node, radians: float, args: Dictionary) -> Dictionary:
	var use_global = args.get("global", false)

	if node is Node2D:
		if use_global:
			node.global_rotation = radians
		else:
			node.rotation = radians
	elif node is Node3D:
		# For 3D, use euler angles
		var rx = args.get("x", 0.0)
		var ry = args.get("y", 0.0)
		var rz = args.get("z", 0.0)
		if args.has("x") or args.has("y") or args.has("z"):
			if use_global:
				node.global_rotation = Vector3(rx, ry, rz)
			else:
				node.rotation = Vector3(rx, ry, rz)
		else:
			node.rotation.y = radians
	elif node is Control:
		node.rotation = radians
	else:
		return _error("Node does not support rotation")

	return _success({
		"path": _get_scene_path(node),
		"rotation": _get_rotation_dict(node)
	}, "Rotation set")


func _set_scale(node: Node, args: Dictionary) -> Dictionary:
	var x = args.get("x", 1.0)
	var y = args.get("y", 1.0)
	var z = args.get("z", 1.0)

	if node is Node2D:
		node.scale = Vector2(x, y)
	elif node is Node3D:
		node.scale = Vector3(x, y, z)
	elif node is Control:
		node.scale = Vector2(x, y)
	else:
		return _error("Node does not support scale")

	return _success({
		"path": _get_scene_path(node),
		"scale": _get_scale_dict(node)
	}, "Scale set")


func _get_transform(node: Node) -> Dictionary:
	var result = {"path": _get_scene_path(node)}

	if node is Node2D:
		result["position"] = {"x": node.position.x, "y": node.position.y}
		result["global_position"] = {"x": node.global_position.x, "y": node.global_position.y}
		result["rotation"] = node.rotation
		result["rotation_degrees"] = node.rotation_degrees
		result["scale"] = {"x": node.scale.x, "y": node.scale.y}
	elif node is Node3D:
		result["position"] = {"x": node.position.x, "y": node.position.y, "z": node.position.z}
		result["global_position"] = {"x": node.global_position.x, "y": node.global_position.y, "z": node.global_position.z}
		result["rotation"] = {"x": node.rotation.x, "y": node.rotation.y, "z": node.rotation.z}
		result["rotation_degrees"] = {"x": node.rotation_degrees.x, "y": node.rotation_degrees.y, "z": node.rotation_degrees.z}
		result["scale"] = {"x": node.scale.x, "y": node.scale.y, "z": node.scale.z}
	elif node is Control:
		result["position"] = {"x": node.position.x, "y": node.position.y}
		result["global_position"] = {"x": node.global_position.x, "y": node.global_position.y}
		result["rotation"] = node.rotation
		result["scale"] = {"x": node.scale.x, "y": node.scale.y}
		result["size"] = {"x": node.size.x, "y": node.size.y}
	else:
		return _error("Node does not support transform")

	return _success(result)


func _move_node(node: Node, args: Dictionary) -> Dictionary:
	var x = args.get("x", 0.0)
	var y = args.get("y", 0.0)
	var z = args.get("z", 0.0)

	if node is Node2D:
		node.position += Vector2(x, y)
	elif node is Node3D:
		node.position += Vector3(x, y, z)
	elif node is Control:
		node.position += Vector2(x, y)
	else:
		return _error("Node does not support position")

	return _success({
		"path": _get_scene_path(node),
		"new_position": _get_position_dict(node)
	}, "Node moved")


func _rotate_node(node: Node, args: Dictionary) -> Dictionary:
	var radians = args.get("radians", 0.0)
	if args.has("degrees"):
		radians = deg_to_rad(args.get("degrees", 0.0))

	if node is Node2D:
		node.rotation += radians
	elif node is Node3D:
		node.rotation.y += radians
	elif node is Control:
		node.rotation += radians
	else:
		return _error("Node does not support rotation")

	return _success({
		"path": _get_scene_path(node),
		"new_rotation": _get_rotation_dict(node)
	}, "Node rotated")


func _look_at(node: Node, args: Dictionary) -> Dictionary:
	var x = args.get("x", 0.0)
	var y = args.get("y", 0.0)
	var z = args.get("z", 0.0)

	if node is Node2D:
		node.look_at(Vector2(x, y))
	elif node is Node3D:
		node.look_at(Vector3(x, y, z))
	else:
		return _error("Node does not support look_at")

	return _success({
		"path": _get_scene_path(node),
		"looking_at": {"x": x, "y": y, "z": z}
	}, "Node looking at target")


func _reset_transform(node: Node) -> Dictionary:
	if node is Node2D:
		node.position = Vector2.ZERO
		node.rotation = 0
		node.scale = Vector2.ONE
	elif node is Node3D:
		node.position = Vector3.ZERO
		node.rotation = Vector3.ZERO
		node.scale = Vector3.ONE
	elif node is Control:
		node.position = Vector2.ZERO
		node.rotation = 0
		node.scale = Vector2.ONE
	else:
		return _error("Node does not support transform")

	return _success({"path": _get_scene_path(node)}, "Transform reset")


func _get_position_dict(node: Node) -> Dictionary:
	if node is Node2D or node is Control:
		return {"x": node.position.x, "y": node.position.y}
	elif node is Node3D:
		return {"x": node.position.x, "y": node.position.y, "z": node.position.z}
	return {}


func _get_rotation_dict(node: Node) -> Variant:
	if node is Node2D or node is Control:
		return node.rotation
	elif node is Node3D:
		return {"x": node.rotation.x, "y": node.rotation.y, "z": node.rotation.z}
	return 0


func _get_scale_dict(node: Node) -> Dictionary:
	if node is Node2D or node is Control:
		return {"x": node.scale.x, "y": node.scale.y}
	elif node is Node3D:
		return {"x": node.scale.x, "y": node.scale.y, "z": node.scale.z}
	return {}


# ==================== PROPERTY ====================

func _execute_property(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	match action:
		"get": return _get_property(node, args.get("property", ""))
		"set": return _set_property(node, args.get("property", ""), args.get("value"))
		"list": return _list_properties(node, args.get("filter", ""))
		"reset": return _reset_property(node, args.get("property", ""))
		"revert": return _check_revert(node, args.get("property", ""))
		_: return _error("Unknown action: %s" % action)


func _get_property(node: Node, property: String) -> Dictionary:
	if property.is_empty():
		return _error("Property name is required")

	if not property in node:
		return _error("Property not found: %s" % property)

	var value = node.get(property)
	return _success({
		"property": property,
		"value": _serialize_value(value),
		"type": typeof(value),
		"type_name": _type_to_string(typeof(value))
	})


func _set_property(node: Node, property: String, value) -> Dictionary:
	if property.is_empty():
		return _error("Property name is required")

	if not property in node:
		var available: Array = []
		for prop in node.get_property_list():
			var prop_name = str(prop.name)
			if prop.usage & PROPERTY_USAGE_EDITOR and not prop_name.begins_with("_"):
				if property.to_lower() in prop_name.to_lower():
					available.append(prop_name)
		var hints = []
		if not available.is_empty():
			hints.append("Similar properties: %s" % ", ".join(available.slice(0, 5)))
		return _error("Property not found: %s" % property, {"node_type": str(node.get_class())}, hints)

	var prop_info = _get_property_info(node, property)
	var current_value = node.get(property)

	# Handle enum string to int conversion
	if prop_info.has("valid_values") and value is String:
		var enum_values = prop_info["valid_values"]
		var found_idx = -1
		for i in range(enum_values.size()):
			var enum_val = enum_values[i].strip_edges()
			var enum_name = enum_val.split(":")[0] if ":" in enum_val else enum_val
			if enum_name.to_lower() == value.to_lower():
				found_idx = i
				break
		if found_idx >= 0:
			value = found_idx
		else:
			return _error("Invalid enum value: '%s'" % value, {}, ["Valid values: %s" % ", ".join(enum_values)])

	# Deserialize value
	var converted_value = _deserialize_value(value, current_value)
	var old_value = _serialize_value(current_value)

	node.set(property, converted_value)

	var new_value = _serialize_value(node.get(property))

	return _success({
		"property": property,
		"old_value": old_value,
		"new_value": new_value,
		"node_path": _get_scene_path(node),
		"node_type": str(node.get_class())
	}, "Property set: %s" % property)


func _list_properties(node: Node, filter: String) -> Dictionary:
	var properties: Array[Dictionary] = []
	var property_list = node.get_property_list()

	for prop in property_list:
		var prop_name = str(prop.name)
		if prop_name.begins_with("_") or prop.usage & PROPERTY_USAGE_INTERNAL:
			continue
		if not (prop.usage & PROPERTY_USAGE_EDITOR):
			continue
		if not filter.is_empty() and not filter.to_lower() in prop_name.to_lower():
			continue

		var prop_data = {
			"name": prop_name,
			"type": prop.type,
			"type_name": _type_to_string(prop.type),
			"hint": prop.hint,
			"hint_string": str(prop.hint_string)
		}

		if prop.type in [TYPE_BOOL, TYPE_INT, TYPE_FLOAT, TYPE_STRING, TYPE_VECTOR2, TYPE_VECTOR3, TYPE_COLOR]:
			prop_data["current_value"] = _serialize_value(node.get(prop_name))
		if prop.hint == PROPERTY_HINT_ENUM and not prop.hint_string.is_empty():
			prop_data["valid_values"] = prop.hint_string.split(",")
		if prop.hint == PROPERTY_HINT_RANGE and not prop.hint_string.is_empty():
			var parts = prop.hint_string.split(",")
			if parts.size() >= 2:
				prop_data["range"] = {"min": float(parts[0]), "max": float(parts[1])}

		properties.append(prop_data)

	return _success({
		"path": _get_scene_path(node),
		"type": str(node.get_class()),
		"count": properties.size(),
		"properties": properties
	})


func _reset_property(node: Node, property: String) -> Dictionary:
	if property.is_empty():
		return _error("Property name is required")

	var default_instance = ClassDB.instantiate(node.get_class())
	if default_instance:
		var default_value = default_instance.get(property)
		node.set(property, default_value)
		default_instance.queue_free()
		return _success({
			"property": property,
			"value": _serialize_value(node.get(property))
		}, "Property reset: %s" % property)

	return _error("Could not determine default value")


func _check_revert(node: Node, property: String) -> Dictionary:
	if property.is_empty():
		return _error("Property name is required")

	var can_revert = node.property_can_revert(property)
	var result = {"property": property, "can_revert": can_revert}

	if can_revert:
		result["revert_value"] = _serialize_value(node.property_get_revert(property))

	return _success(result)


# ==================== HIERARCHY ====================

func _execute_hierarchy(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	match action:
		"reparent": return _reparent_node(node, args.get("new_parent", ""), args.get("keep_global", true))
		"reorder": return _reorder_node(node, args.get("index", 0))
		"move_up": return _move_sibling(node, -1)
		"move_down": return _move_sibling(node, 1)
		"move_to_front": return _move_to_front(node)
		"move_to_back": return _move_to_back(node)
		"set_owner": return _set_owner(node, args.get("owner_path", ""))
		"get_owner": return _get_owner(node)
		_: return _error("Unknown action: %s" % action)


func _reparent_node(node: Node, new_parent_path: String, keep_global: bool) -> Dictionary:
	if new_parent_path.is_empty():
		return _error("New parent path is required")

	var new_parent = _find_node_by_path(new_parent_path)
	if not new_parent:
		return _error("New parent not found: %s" % new_parent_path)

	if node == _get_edited_scene_root():
		return _error("Cannot reparent scene root")

	var old_parent_path = _get_scene_path(node.get_parent())
	node.reparent(new_parent, keep_global)
	node.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(node),
		"old_parent": old_parent_path,
		"new_parent": new_parent_path,
		"keep_global": keep_global
	}, "Node reparented")


func _reorder_node(node: Node, index: int) -> Dictionary:
	var parent = node.get_parent()
	if not parent:
		return _error("Node has no parent")

	parent.move_child(node, index)

	return _success({
		"path": _get_scene_path(node),
		"new_index": node.get_index()
	}, "Node reordered")


func _move_sibling(node: Node, direction: int) -> Dictionary:
	var parent = node.get_parent()
	if not parent:
		return _error("Node has no parent")

	var current_index = node.get_index()
	var new_index = current_index + direction

	if new_index < 0 or new_index >= parent.get_child_count():
		return _error("Cannot move node further in that direction")

	parent.move_child(node, new_index)

	return _success({
		"path": _get_scene_path(node),
		"old_index": current_index,
		"new_index": node.get_index()
	}, "Node moved")


func _move_to_front(node: Node) -> Dictionary:
	var parent = node.get_parent()
	if not parent:
		return _error("Node has no parent")

	parent.move_child(node, parent.get_child_count() - 1)
	return _success({"path": _get_scene_path(node), "new_index": node.get_index()}, "Node moved to front")


func _move_to_back(node: Node) -> Dictionary:
	var parent = node.get_parent()
	if not parent:
		return _error("Node has no parent")

	parent.move_child(node, 0)
	return _success({"path": _get_scene_path(node), "new_index": node.get_index()}, "Node moved to back")


func _set_owner(node: Node, owner_path: String) -> Dictionary:
	var new_owner = _find_node_by_path(owner_path) if not owner_path.is_empty() else _get_edited_scene_root()
	if not new_owner:
		return _error("Owner not found: %s" % owner_path)

	node.owner = new_owner
	return _success({"path": _get_scene_path(node), "owner": _get_scene_path(new_owner)}, "Owner set")


func _get_owner(node: Node) -> Dictionary:
	var owner = node.owner
	return _success({
		"path": _get_scene_path(node),
		"owner": _get_scene_path(owner) if owner else null
	})


# ==================== SIGNAL ====================

func _execute_signal(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"list": return _list_signals(args.get("path", ""))
		"has": return _has_signal(args.get("path", ""), args.get("signal_name", ""))
		"get_connections": return _get_signal_connections(args.get("path", ""), args.get("signal_name", ""))
		"get_incoming": return _get_incoming_connections(args.get("path", ""))
		"connect": return _connect_signal(args)
		"disconnect": return _disconnect_signal(args)
		"disconnect_all": return _disconnect_all(args.get("path", ""), args.get("signal_name", ""))
		"is_connected": return _is_signal_connected(args)
		"emit": return _emit_signal(args.get("path", ""), args.get("signal_name", ""), args.get("args", []))
		"add_user_signal": return _add_user_signal(args)
		"remove_user_signal": return _remove_user_signal(args.get("path", ""), args.get("signal_name", ""))
		_: return _error("Unknown action: %s" % action)


func _list_signals(path: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var signals: Array[Dictionary] = []
	for sig in node.get_signal_list():
		var sig_info = {"name": str(sig.name), "args": []}
		for arg in sig.args:
			sig_info["args"].append({"name": str(arg.name), "type": arg.type, "type_name": _type_to_string(arg.type)})

		# Get connection count
		var connections = node.get_signal_connection_list(sig.name)
		sig_info["connection_count"] = connections.size()
		signals.append(sig_info)

	return _success({"path": path, "count": signals.size(), "signals": signals})


func _has_signal(path: String, signal_name: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	return _success({
		"path": path,
		"signal_name": signal_name,
		"exists": node.has_signal(signal_name)
	})


func _get_signal_connections(path: String, signal_name: String) -> Dictionary:
	if signal_name.is_empty():
		return _error("Signal name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var connections: Array[Dictionary] = []
	for conn in node.get_signal_connection_list(signal_name):
		var target_obj = conn.callable.get_object()
		connections.append({
			"signal": str(conn.signal.get_name()),
			"target": _get_scene_path(target_obj) if target_obj and target_obj is Node else str(target_obj),
			"method": str(conn.callable.get_method()),
			"flags": conn.flags
		})

	return _success({"path": path, "signal": signal_name, "count": connections.size(), "connections": connections})


func _get_incoming_connections(path: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var connections: Array[Dictionary] = []
	for conn in node.get_incoming_connections():
		var source_obj = conn.signal.get_object()
		connections.append({
			"source": _get_scene_path(source_obj) if source_obj and source_obj is Node else str(source_obj),
			"signal": str(conn.signal.get_name()),
			"method": str(conn.callable.get_method())
		})

	return _success({"path": path, "count": connections.size(), "incoming_connections": connections})


func _connect_signal(args: Dictionary) -> Dictionary:
	var source_path = args.get("source_path", args.get("path", ""))
	var signal_name = args.get("signal_name", "")
	var target_path = args.get("target_path", "")
	var method = args.get("method", "")
	var flags_array = args.get("flags", [])

	if signal_name.is_empty() or method.is_empty():
		return _error("Signal name and method are required")

	var source = _find_node_by_path(source_path)
	if not source:
		return _error("Source node not found: %s" % source_path)

	var target = _find_node_by_path(target_path)
	if not target:
		return _error("Target node not found: %s" % target_path)

	if not source.has_signal(signal_name):
		return _error("Signal not found: %s" % signal_name)

	var callable = Callable(target, method)

	if source.is_connected(signal_name, callable):
		return _error("Signal already connected")

	# Build flags
	var flags = 0
	for flag in flags_array:
		match flag.to_lower():
			"deferred": flags |= CONNECT_DEFERRED
			"persist": flags |= CONNECT_PERSIST
			"one_shot": flags |= CONNECT_ONE_SHOT

	var error = source.connect(signal_name, callable, flags)
	if error != OK:
		return _error("Failed to connect signal: %s" % error_string(error))

	return _success({
		"source": source_path,
		"signal": signal_name,
		"target": target_path,
		"method": method,
		"flags": flags_array
	}, "Signal connected")


func _disconnect_signal(args: Dictionary) -> Dictionary:
	var source_path = args.get("source_path", args.get("path", ""))
	var signal_name = args.get("signal_name", "")
	var target_path = args.get("target_path", "")
	var method = args.get("method", "")

	if signal_name.is_empty() or method.is_empty():
		return _error("Signal name and method are required")

	var source = _find_node_by_path(source_path)
	if not source:
		return _error("Source node not found: %s" % source_path)

	var target = _find_node_by_path(target_path)
	if not target:
		return _error("Target node not found: %s" % target_path)

	var callable = Callable(target, method)

	if not source.is_connected(signal_name, callable):
		return _error("Signal not connected")

	source.disconnect(signal_name, callable)

	return _success({
		"source": source_path,
		"signal": signal_name,
		"target": target_path,
		"method": method
	}, "Signal disconnected")


func _disconnect_all(path: String, signal_name: String) -> Dictionary:
	if signal_name.is_empty():
		return _error("Signal name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var connections = node.get_signal_connection_list(signal_name)
	var count = 0

	for conn in connections:
		node.disconnect(signal_name, conn.callable)
		count += 1

	return _success({
		"path": path,
		"signal": signal_name,
		"disconnected_count": count
	}, "All connections disconnected")


func _is_signal_connected(args: Dictionary) -> Dictionary:
	var source_path = args.get("source_path", args.get("path", ""))
	var signal_name = args.get("signal_name", "")
	var target_path = args.get("target_path", "")
	var method = args.get("method", "")

	var source = _find_node_by_path(source_path)
	if not source:
		return _error("Source node not found: %s" % source_path)

	var target = _find_node_by_path(target_path)
	if not target:
		return _error("Target node not found: %s" % target_path)

	var is_connected = source.is_connected(signal_name, Callable(target, method))

	return _success({
		"source": source_path,
		"signal": signal_name,
		"target": target_path,
		"method": method,
		"connected": is_connected
	})


func _emit_signal(path: String, signal_name: String, args: Array) -> Dictionary:
	if signal_name.is_empty():
		return _error("Signal name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node.has_signal(signal_name):
		return _error("Signal not found: %s" % signal_name)

	match args.size():
		0: node.emit_signal(signal_name)
		1: node.emit_signal(signal_name, args[0])
		2: node.emit_signal(signal_name, args[0], args[1])
		3: node.emit_signal(signal_name, args[0], args[1], args[2])
		4: node.emit_signal(signal_name, args[0], args[1], args[2], args[3])
		5: node.emit_signal(signal_name, args[0], args[1], args[2], args[3], args[4])
		_: return _error("Too many arguments (max 5)")

	return _success({"path": path, "signal": signal_name, "args_count": args.size()}, "Signal emitted")


func _add_user_signal(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var signal_name = args.get("signal_name", "")
	var signal_args = args.get("args", [])

	if signal_name.is_empty():
		return _error("Signal name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node.has_signal(signal_name):
		return _error("Signal already exists: %s" % signal_name)

	var arg_array: Array = []
	for arg in signal_args:
		if arg is Dictionary:
			arg_array.append({"name": arg.get("name", "arg"), "type": arg.get("type", TYPE_NIL)})

	node.add_user_signal(signal_name, arg_array)

	return _success({
		"path": path,
		"signal_name": signal_name,
		"args": arg_array
	}, "User signal added")


func _remove_user_signal(path: String, signal_name: String) -> Dictionary:
	if signal_name.is_empty():
		return _error("Signal name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node.has_signal(signal_name):
		return _error("Signal not found: %s" % signal_name)

	node.remove_user_signal(signal_name)

	return _success({"path": path, "signal_name": signal_name}, "User signal removed")


# ==================== GROUP ====================

func _execute_group(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"list": return _list_node_groups(args.get("path", ""))
		"add": return _add_to_group(args.get("path", ""), args.get("group", ""), args.get("persistent", true))
		"remove": return _remove_from_group(args.get("path", ""), args.get("group", ""))
		"is_in": return _is_in_group(args.get("path", ""), args.get("group", ""))
		"get_nodes": return _get_nodes_in_group(args.get("group", ""))
		"get_first": return _get_first_in_group(args.get("group", ""))
		"count": return _count_in_group(args.get("group", ""))
		"call_group": return _call_group_method(args.get("group", ""), args.get("method", ""), args.get("args", []))
		"notify_group": return _notify_group(args.get("group", ""), args.get("notification", 0))
		"set_group": return _set_group_property(args.get("group", ""), args.get("property", ""), args.get("value"))
		_: return _error("Unknown action: %s" % action)


func _list_node_groups(path: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var groups: Array[String] = []
	for group in node.get_groups():
		groups.append(str(group))

	return _success({"path": path, "count": groups.size(), "groups": groups})


func _add_to_group(path: String, group: String, persistent: bool) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node.is_in_group(group):
		return _error("Node already in group: %s" % group)

	node.add_to_group(group, persistent)

	return _success({"path": path, "group": group, "persistent": persistent}, "Node added to group")


func _remove_from_group(path: String, group: String) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node.is_in_group(group):
		return _error("Node not in group: %s" % group)

	node.remove_from_group(group)

	return _success({"path": path, "group": group}, "Node removed from group")


func _is_in_group(path: String, group: String) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	return _success({"path": path, "group": group, "is_in_group": node.is_in_group(group)})


func _get_nodes_in_group(group: String) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = root.get_tree()
	if not tree:
		return _error("Scene tree not available")

	var nodes = tree.get_nodes_in_group(group)
	var result: Array[Dictionary] = []

	for node in nodes:
		result.append({"name": str(node.name), "path": _get_scene_path(node), "type": str(node.get_class())})

	return _success({"group": group, "count": result.size(), "nodes": result})


func _get_first_in_group(group: String) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = root.get_tree()
	if not tree:
		return _error("Scene tree not available")

	var first = tree.get_first_node_in_group(group)
	if first:
		return _success(_node_to_dict(first, false))
	else:
		return _success({"found": false, "message": "No nodes in group"})


func _count_in_group(group: String) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = root.get_tree()
	if not tree:
		return _error("Scene tree not available")

	var count = tree.get_nodes_in_group(group).size()
	return _success({"group": group, "count": count})


func _call_group_method(group: String, method: String, args: Array) -> Dictionary:
	if group.is_empty() or method.is_empty():
		return _error("Group name and method are required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = root.get_tree()
	if not tree:
		return _error("Scene tree not available")

	match args.size():
		0: tree.call_group(group, method)
		1: tree.call_group(group, method, args[0])
		2: tree.call_group(group, method, args[0], args[1])
		3: tree.call_group(group, method, args[0], args[1], args[2])
		4: tree.call_group(group, method, args[0], args[1], args[2], args[3])
		_: return _error("Too many arguments (max 4)")

	return _success({"group": group, "method": method, "args_count": args.size()}, "Method called on group")


func _notify_group(group: String, notification: int) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = root.get_tree()
	if not tree:
		return _error("Scene tree not available")

	tree.notify_group(group, notification)

	return _success({"group": group, "notification": notification}, "Group notified")


func _set_group_property(group: String, property: String, value) -> Dictionary:
	if group.is_empty() or property.is_empty():
		return _error("Group name and property are required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = root.get_tree()
	if not tree:
		return _error("Scene tree not available")

	tree.set_group(group, property, value)

	return _success({"group": group, "property": property, "value": value}, "Group property set")


# ==================== PROCESS ====================

func _execute_process(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	match action:
		"get_status": return _get_process_status(node)
		"set_process": return _set_process_flag(node, "process", args.get("enabled", true))
		"set_physics_process": return _set_process_flag(node, "physics_process", args.get("enabled", true))
		"set_input": return _set_process_flag(node, "input", args.get("enabled", true))
		"set_unhandled_input": return _set_process_flag(node, "unhandled_input", args.get("enabled", true))
		"set_unhandled_key_input": return _set_process_flag(node, "unhandled_key_input", args.get("enabled", true))
		"set_shortcut_input": return _set_process_flag(node, "shortcut_input", args.get("enabled", true))
		"set_process_mode": return _set_process_mode(node, args.get("mode", "inherit"))
		"set_process_priority": return _set_process_priority(node, args.get("priority", 0))
		"set_physics_priority": return _set_physics_priority(node, args.get("priority", 0))
		_: return _error("Unknown action: %s" % action)


func _get_process_status(node: Node) -> Dictionary:
	return _success({
		"path": _get_scene_path(node),
		"processing": node.is_processing(),
		"physics_processing": node.is_physics_processing(),
		"input_processing": node.is_processing_input(),
		"unhandled_input_processing": node.is_processing_unhandled_input(),
		"unhandled_key_input_processing": node.is_processing_unhandled_key_input(),
		"shortcut_input_processing": node.is_processing_shortcut_input(),
		"process_mode": node.process_mode,
		"process_priority": node.process_priority,
		"physics_process_priority": node.process_physics_priority,
		"can_process": node.can_process()
	})


func _set_process_flag(node: Node, flag_type: String, enabled: bool) -> Dictionary:
	match flag_type:
		"process": node.set_process(enabled)
		"physics_process": node.set_physics_process(enabled)
		"input": node.set_process_input(enabled)
		"unhandled_input": node.set_process_unhandled_input(enabled)
		"unhandled_key_input": node.set_process_unhandled_key_input(enabled)
		"shortcut_input": node.set_process_shortcut_input(enabled)

	return _success({"path": _get_scene_path(node), flag_type: enabled}, "Process flag set")


func _set_process_mode(node: Node, mode: String) -> Dictionary:
	var mode_value: Node.ProcessMode
	match mode.to_lower():
		"inherit": mode_value = Node.PROCESS_MODE_INHERIT
		"pausable": mode_value = Node.PROCESS_MODE_PAUSABLE
		"when_paused": mode_value = Node.PROCESS_MODE_WHEN_PAUSED
		"always": mode_value = Node.PROCESS_MODE_ALWAYS
		"disabled": mode_value = Node.PROCESS_MODE_DISABLED
		_: return _error("Invalid process mode: %s" % mode)

	node.process_mode = mode_value

	return _success({"path": _get_scene_path(node), "process_mode": mode}, "Process mode set")


func _set_process_priority(node: Node, priority: int) -> Dictionary:
	node.process_priority = priority
	return _success({"path": _get_scene_path(node), "process_priority": priority}, "Process priority set")


func _set_physics_priority(node: Node, priority: int) -> Dictionary:
	node.process_physics_priority = priority
	return _success({"path": _get_scene_path(node), "physics_process_priority": priority}, "Physics process priority set")


# ==================== METADATA ====================

func _execute_metadata(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	match action:
		"get": return _get_metadata(node, args.get("key", ""))
		"set": return _set_metadata(node, args.get("key", ""), args.get("value"))
		"has": return _has_metadata(node, args.get("key", ""))
		"remove": return _remove_metadata(node, args.get("key", ""))
		"list": return _list_metadata(node)
		_: return _error("Unknown action: %s" % action)


func _get_metadata(node: Node, key: String) -> Dictionary:
	if key.is_empty():
		return _error("Key is required")

	if not node.has_meta(key):
		return _error("Metadata not found: %s" % key)

	return _success({
		"path": _get_scene_path(node),
		"key": key,
		"value": _serialize_value(node.get_meta(key))
	})


func _set_metadata(node: Node, key: String, value) -> Dictionary:
	if key.is_empty():
		return _error("Key is required")

	node.set_meta(key, value)

	return _success({
		"path": _get_scene_path(node),
		"key": key,
		"value": _serialize_value(value)
	}, "Metadata set")


func _has_metadata(node: Node, key: String) -> Dictionary:
	if key.is_empty():
		return _error("Key is required")

	return _success({
		"path": _get_scene_path(node),
		"key": key,
		"exists": node.has_meta(key)
	})


func _remove_metadata(node: Node, key: String) -> Dictionary:
	if key.is_empty():
		return _error("Key is required")

	if not node.has_meta(key):
		return _error("Metadata not found: %s" % key)

	node.remove_meta(key)

	return _success({"path": _get_scene_path(node), "key": key}, "Metadata removed")


func _list_metadata(node: Node) -> Dictionary:
	var keys: Array[String] = []
	for key in node.get_meta_list():
		keys.append(str(key))

	return _success({
		"path": _get_scene_path(node),
		"count": keys.size(),
		"keys": keys
	})


# ==================== CALL ====================

func _execute_call(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	match action:
		"call": return _call_method(node, args.get("method", ""), args.get("args", []))
		"call_deferred": return _call_method_deferred(node, args.get("method", ""), args.get("args", []))
		"propagate_call": return _propagate_call(node, args.get("method", ""), args.get("args", []), args.get("parent_first", false))
		"has_method": return _has_method(node, args.get("method", ""))
		"get_method_list": return _get_method_list(node, args.get("filter", ""))
		_: return _error("Unknown action: %s" % action)


func _call_method(node: Node, method: String, args: Array) -> Dictionary:
	if method.is_empty():
		return _error("Method name is required")

	if not node.has_method(method):
		return _error("Method not found: %s" % method)

	var result
	match args.size():
		0: result = node.call(method)
		1: result = node.call(method, args[0])
		2: result = node.call(method, args[0], args[1])
		3: result = node.call(method, args[0], args[1], args[2])
		4: result = node.call(method, args[0], args[1], args[2], args[3])
		5: result = node.call(method, args[0], args[1], args[2], args[3], args[4])
		_: return _error("Too many arguments (max 5)")

	return _success({
		"path": _get_scene_path(node),
		"method": method,
		"result": _serialize_value(result)
	}, "Method called")


func _call_method_deferred(node: Node, method: String, args: Array) -> Dictionary:
	if method.is_empty():
		return _error("Method name is required")

	if not node.has_method(method):
		return _error("Method not found: %s" % method)

	match args.size():
		0: node.call_deferred(method)
		1: node.call_deferred(method, args[0])
		2: node.call_deferred(method, args[0], args[1])
		3: node.call_deferred(method, args[0], args[1], args[2])
		4: node.call_deferred(method, args[0], args[1], args[2], args[3])
		_: return _error("Too many arguments (max 4)")

	return _success({
		"path": _get_scene_path(node),
		"method": method,
		"deferred": true
	}, "Method call deferred")


func _propagate_call(node: Node, method: String, args: Array, parent_first: bool) -> Dictionary:
	if method.is_empty():
		return _error("Method name is required")

	node.propagate_call(method, args, parent_first)

	return _success({
		"path": _get_scene_path(node),
		"method": method,
		"args_count": args.size(),
		"parent_first": parent_first
	}, "Call propagated")


func _has_method(node: Node, method: String) -> Dictionary:
	if method.is_empty():
		return _error("Method name is required")

	return _success({
		"path": _get_scene_path(node),
		"method": method,
		"exists": node.has_method(method)
	})


func _get_method_list(node: Node, filter: String) -> Dictionary:
	var methods: Array[Dictionary] = []

	for method in node.get_method_list():
		var method_name = str(method.name)
		if method_name.begins_with("_"):
			continue
		if not filter.is_empty() and not filter.to_lower() in method_name.to_lower():
			continue

		var args_info: Array = []
		for arg in method.args:
			args_info.append({"name": str(arg.name), "type": _type_to_string(arg.type)})

		methods.append({
			"name": method_name,
			"args": args_info,
			"return_type": _type_to_string(method.return.type)
		})

	return _success({
		"path": _get_scene_path(node),
		"count": methods.size(),
		"methods": methods
	})


# ==================== VISIBILITY ====================

func _execute_visibility(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	match action:
		"show": return _set_visible(node, true)
		"hide": return _set_visible(node, false)
		"toggle": return _toggle_visible(node)
		"is_visible": return _is_visible(node)
		"set_z_index": return _set_z_index(node, args.get("value", 0))
		"set_z_relative": return _set_z_relative(node, args.get("enabled", true))
		"set_y_sort": return _set_y_sort(node, args.get("enabled", true))
		"set_modulate": return _set_modulate(node, args.get("color", {}))
		"set_self_modulate": return _set_self_modulate(node, args.get("color", {}))
		"set_visibility_layer": return _set_visibility_layer(node, args.get("value", 1))
		_: return _error("Unknown action: %s" % action)


func _set_visible(node: Node, visible: bool) -> Dictionary:
	if node is CanvasItem:
		node.visible = visible
	elif node is Node3D:
		node.visible = visible
	else:
		return _error("Node does not support visibility")

	return _success({"path": _get_scene_path(node), "visible": visible}, "Visibility set")


func _toggle_visible(node: Node) -> Dictionary:
	if node is CanvasItem:
		node.visible = not node.visible
		return _success({"path": _get_scene_path(node), "visible": node.visible}, "Visibility toggled")
	elif node is Node3D:
		node.visible = not node.visible
		return _success({"path": _get_scene_path(node), "visible": node.visible}, "Visibility toggled")
	else:
		return _error("Node does not support visibility")


func _is_visible(node: Node) -> Dictionary:
	var visible = false
	var visible_in_tree = false

	if node is CanvasItem:
		visible = node.visible
		visible_in_tree = node.is_visible_in_tree()
	elif node is Node3D:
		visible = node.visible
		visible_in_tree = node.is_visible_in_tree()
	else:
		return _error("Node does not support visibility")

	return _success({
		"path": _get_scene_path(node),
		"visible": visible,
		"visible_in_tree": visible_in_tree
	})


func _set_z_index(node: Node, z_index: int) -> Dictionary:
	if not node is CanvasItem:
		return _error("Node is not a CanvasItem")

	node.z_index = z_index
	return _success({"path": _get_scene_path(node), "z_index": z_index}, "Z index set")


func _set_z_relative(node: Node, enabled: bool) -> Dictionary:
	if not node is CanvasItem:
		return _error("Node is not a CanvasItem")

	node.z_as_relative = enabled
	return _success({"path": _get_scene_path(node), "z_as_relative": enabled}, "Z relative set")


func _set_y_sort(node: Node, enabled: bool) -> Dictionary:
	if not node is CanvasItem:
		return _error("Node is not a CanvasItem")

	node.y_sort_enabled = enabled
	return _success({"path": _get_scene_path(node), "y_sort_enabled": enabled}, "Y sort set")


func _set_modulate(node: Node, color_dict: Dictionary) -> Dictionary:
	if not node is CanvasItem:
		return _error("Node is not a CanvasItem")

	var color = Color(
		color_dict.get("r", 1.0),
		color_dict.get("g", 1.0),
		color_dict.get("b", 1.0),
		color_dict.get("a", 1.0)
	)
	node.modulate = color

	return _success({
		"path": _get_scene_path(node),
		"modulate": {"r": color.r, "g": color.g, "b": color.b, "a": color.a}
	}, "Modulate set")


func _set_self_modulate(node: Node, color_dict: Dictionary) -> Dictionary:
	if not node is CanvasItem:
		return _error("Node is not a CanvasItem")

	var color = Color(
		color_dict.get("r", 1.0),
		color_dict.get("g", 1.0),
		color_dict.get("b", 1.0),
		color_dict.get("a", 1.0)
	)
	node.self_modulate = color

	return _success({
		"path": _get_scene_path(node),
		"self_modulate": {"r": color.r, "g": color.g, "b": color.b, "a": color.a}
	}, "Self modulate set")


func _set_visibility_layer(node: Node, layer: int) -> Dictionary:
	if node is CanvasItem:
		node.visibility_layer = layer
	elif node is Node3D:
		node.layers = layer
	else:
		return _error("Node does not support visibility layers")

	return _success({"path": _get_scene_path(node), "visibility_layer": layer}, "Visibility layer set")


# ==================== PHYSICS ====================

func _execute_physics(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	match action:
		"get_collision_info": return _get_collision_info(node)
		"set_collision_layer": return _set_collision_layer(node, args.get("value", 1))
		"set_collision_mask": return _set_collision_mask(node, args.get("value", 1))
		"set_collision_layer_value": return _set_collision_layer_value(node, args.get("layer", 1), args.get("value", true))
		"set_collision_mask_value": return _set_collision_mask_value(node, args.get("layer", 1), args.get("value", true))
		"apply_impulse": return _apply_impulse(node, args)
		"apply_force": return _apply_force(node, args)
		"apply_torque": return _apply_torque(node, args)
		"set_linear_velocity": return _set_linear_velocity(node, args)
		"set_angular_velocity": return _set_angular_velocity(node, args)
		_: return _error("Unknown action: %s" % action)


func _get_collision_info(node: Node) -> Dictionary:
	var info = {"path": _get_scene_path(node)}

	if node is CollisionObject2D:
		info["collision_layer"] = node.collision_layer
		info["collision_mask"] = node.collision_mask
		info["layers"] = _get_collision_layers(node.collision_layer)
		info["masks"] = _get_collision_layers(node.collision_mask)
	elif node is CollisionObject3D:
		info["collision_layer"] = node.collision_layer
		info["collision_mask"] = node.collision_mask
		info["layers"] = _get_collision_layers(node.collision_layer)
		info["masks"] = _get_collision_layers(node.collision_mask)
	else:
		return _error("Node is not a collision object")

	return _success(info)


func _get_collision_layers(bitmask: int) -> Array:
	var layers: Array = []
	for i in range(32):
		if bitmask & (1 << i):
			layers.append(i + 1)
	return layers


func _set_collision_layer(node: Node, value: int) -> Dictionary:
	if node is CollisionObject2D:
		node.collision_layer = value
	elif node is CollisionObject3D:
		node.collision_layer = value
	else:
		return _error("Node is not a collision object")

	return _success({"path": _get_scene_path(node), "collision_layer": value}, "Collision layer set")


func _set_collision_mask(node: Node, value: int) -> Dictionary:
	if node is CollisionObject2D:
		node.collision_mask = value
	elif node is CollisionObject3D:
		node.collision_mask = value
	else:
		return _error("Node is not a collision object")

	return _success({"path": _get_scene_path(node), "collision_mask": value}, "Collision mask set")


func _set_collision_layer_value(node: Node, layer: int, value: bool) -> Dictionary:
	if layer < 1 or layer > 32:
		return _error("Layer must be between 1 and 32")

	if node is CollisionObject2D:
		node.set_collision_layer_value(layer, value)
	elif node is CollisionObject3D:
		node.set_collision_layer_value(layer, value)
	else:
		return _error("Node is not a collision object")

	return _success({"path": _get_scene_path(node), "layer": layer, "value": value}, "Collision layer value set")


func _set_collision_mask_value(node: Node, layer: int, value: bool) -> Dictionary:
	if layer < 1 or layer > 32:
		return _error("Layer must be between 1 and 32")

	if node is CollisionObject2D:
		node.set_collision_mask_value(layer, value)
	elif node is CollisionObject3D:
		node.set_collision_mask_value(layer, value)
	else:
		return _error("Node is not a collision object")

	return _success({"path": _get_scene_path(node), "layer": layer, "value": value}, "Collision mask value set")


func _apply_impulse(node: Node, args: Dictionary) -> Dictionary:
	var x = args.get("x", 0.0)
	var y = args.get("y", 0.0)
	var z = args.get("z", 0.0)

	if node is RigidBody2D:
		node.apply_impulse(Vector2(x, y))
	elif node is RigidBody3D:
		node.apply_impulse(Vector3(x, y, z))
	else:
		return _error("Node is not a RigidBody")

	return _success({"path": _get_scene_path(node), "impulse": {"x": x, "y": y, "z": z}}, "Impulse applied")


func _apply_force(node: Node, args: Dictionary) -> Dictionary:
	var x = args.get("x", 0.0)
	var y = args.get("y", 0.0)
	var z = args.get("z", 0.0)

	if node is RigidBody2D:
		node.apply_force(Vector2(x, y))
	elif node is RigidBody3D:
		node.apply_force(Vector3(x, y, z))
	else:
		return _error("Node is not a RigidBody")

	return _success({"path": _get_scene_path(node), "force": {"x": x, "y": y, "z": z}}, "Force applied")


func _apply_torque(node: Node, args: Dictionary) -> Dictionary:
	var torque = args.get("value", args.get("z", 0.0))

	if node is RigidBody2D:
		node.apply_torque(torque)
	elif node is RigidBody3D:
		var tx = args.get("x", 0.0)
		var ty = args.get("y", 0.0)
		var tz = args.get("z", 0.0)
		node.apply_torque(Vector3(tx, ty, tz))
	else:
		return _error("Node is not a RigidBody")

	return _success({"path": _get_scene_path(node), "torque": torque}, "Torque applied")


func _set_linear_velocity(node: Node, args: Dictionary) -> Dictionary:
	var x = args.get("x", 0.0)
	var y = args.get("y", 0.0)
	var z = args.get("z", 0.0)

	if node is RigidBody2D:
		node.linear_velocity = Vector2(x, y)
	elif node is RigidBody3D:
		node.linear_velocity = Vector3(x, y, z)
	elif node is CharacterBody2D:
		node.velocity = Vector2(x, y)
	elif node is CharacterBody3D:
		node.velocity = Vector3(x, y, z)
	else:
		return _error("Node does not support velocity")

	return _success({"path": _get_scene_path(node), "velocity": {"x": x, "y": y, "z": z}}, "Velocity set")


func _set_angular_velocity(node: Node, args: Dictionary) -> Dictionary:
	var value = args.get("value", args.get("z", 0.0))

	if node is RigidBody2D:
		node.angular_velocity = value
	elif node is RigidBody3D:
		var x = args.get("x", 0.0)
		var y = args.get("y", 0.0)
		var z = args.get("z", 0.0)
		node.angular_velocity = Vector3(x, y, z)
	else:
		return _error("Node is not a RigidBody")

	return _success({"path": _get_scene_path(node), "angular_velocity": value}, "Angular velocity set")


# ==================== HELPERS ====================

func _serialize_value(value) -> Variant:
	match typeof(value):
		TYPE_VECTOR2:
			return {"x": float(value.x), "y": float(value.y)}
		TYPE_VECTOR2I:
			return {"x": int(value.x), "y": int(value.y)}
		TYPE_VECTOR3:
			return {"x": float(value.x), "y": float(value.y), "z": float(value.z)}
		TYPE_VECTOR3I:
			return {"x": int(value.x), "y": int(value.y), "z": int(value.z)}
		TYPE_VECTOR4:
			return {"x": float(value.x), "y": float(value.y), "z": float(value.z), "w": float(value.w)}
		TYPE_COLOR:
			return {"r": float(value.r), "g": float(value.g), "b": float(value.b), "a": float(value.a)}
		TYPE_RECT2:
			return {"position": {"x": float(value.position.x), "y": float(value.position.y)}, "size": {"x": float(value.size.x), "y": float(value.size.y)}}
		TYPE_RECT2I:
			return {"position": {"x": int(value.position.x), "y": int(value.position.y)}, "size": {"x": int(value.size.x), "y": int(value.size.y)}}
		TYPE_QUATERNION:
			return {"x": float(value.x), "y": float(value.y), "z": float(value.z), "w": float(value.w)}
		TYPE_TRANSFORM2D:
			return {"origin": {"x": float(value.origin.x), "y": float(value.origin.y)}}
		TYPE_TRANSFORM3D:
			return {"origin": {"x": float(value.origin.x), "y": float(value.origin.y), "z": float(value.origin.z)}}
		TYPE_OBJECT:
			if value == null:
				return null
			if value is Resource and value.resource_path:
				return str(value.resource_path)
			return str(value)
		TYPE_STRING_NAME:
			return str(value)
		TYPE_NODE_PATH:
			return str(value)
		TYPE_FLOAT:
			if is_nan(value) or is_inf(value):
				return 0.0
			return float(value)
		_:
			return value


func _deserialize_value(value, reference):
	# Parse JSON string if needed
	if value is String:
		var trimmed = value.strip_edges()
		if trimmed.begins_with("{") or trimmed.begins_with("["):
			var json = JSON.new()
			if json.parse(trimmed) == OK:
				value = json.get_data()

	match typeof(reference):
		TYPE_VECTOR2:
			if value is Dictionary:
				return Vector2(value.get("x", 0), value.get("y", 0))
		TYPE_VECTOR2I:
			if value is Dictionary:
				return Vector2i(int(value.get("x", 0)), int(value.get("y", 0)))
		TYPE_VECTOR3:
			if value is Dictionary:
				return Vector3(value.get("x", 0), value.get("y", 0), value.get("z", 0))
		TYPE_VECTOR3I:
			if value is Dictionary:
				return Vector3i(int(value.get("x", 0)), int(value.get("y", 0)), int(value.get("z", 0)))
		TYPE_VECTOR4:
			if value is Dictionary:
				return Vector4(value.get("x", 0), value.get("y", 0), value.get("z", 0), value.get("w", 0))
		TYPE_COLOR:
			if value is Dictionary:
				return Color(value.get("r", 1), value.get("g", 1), value.get("b", 1), value.get("a", 1))
			elif value is String:
				if value.begins_with("#") or not value.contains("{"):
					if Color.html_is_valid(value):
						return Color.html(value)
		TYPE_QUATERNION:
			if value is Dictionary:
				return Quaternion(value.get("x", 0), value.get("y", 0), value.get("z", 0), value.get("w", 1))
		TYPE_RECT2:
			if value is Dictionary:
				var pos = value.get("position", {"x": 0, "y": 0})
				var sz = value.get("size", {"x": 0, "y": 0})
				return Rect2(pos.get("x", 0), pos.get("y", 0), sz.get("x", 0), sz.get("y", 0))
		TYPE_OBJECT:
			if value is String and value.begins_with("res://"):
				return load(value)

	return value
