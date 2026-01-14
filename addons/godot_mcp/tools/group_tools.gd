@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Group tools for Godot MCP
## Provides node group management functionality


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "group",
			"description": """GROUPS: Manage node groups.

ACTIONS:
- list: List all groups a node belongs to
- add: Add node to a group
- remove: Remove node from a group
- is_in: Check if node is in a group
- get_nodes: Get all nodes in a group
- call_group: Call method on all nodes in group
- set_group: Set property on all nodes in group

EXAMPLES:
- List groups: {"action": "list", "path": "/root/Enemy"}
- Add to group: {"action": "add", "path": "/root/Enemy", "group": "enemies"}
- Remove from group: {"action": "remove", "path": "/root/Enemy", "group": "enemies"}
- Get nodes in group: {"action": "get_nodes", "group": "enemies"}
- Call group method: {"action": "call_group", "group": "enemies", "method": "take_damage", "args": [10]}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "add", "remove", "is_in", "get_nodes", "call_group", "set_group"],
						"description": "Group action"
					},
					"path": {
						"type": "string",
						"description": "Node path"
					},
					"group": {
						"type": "string",
						"description": "Group name"
					},
					"method": {
						"type": "string",
						"description": "Method to call"
					},
					"property": {
						"type": "string",
						"description": "Property to set"
					},
					"value": {
						"description": "Value to set"
					},
					"args": {
						"type": "array",
						"description": "Method arguments"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"group":
			return _execute_group(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


func _execute_group(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"list":
			return _list_node_groups(args.get("path", ""))
		"add":
			return _add_to_group(args.get("path", ""), args.get("group", ""))
		"remove":
			return _remove_from_group(args.get("path", ""), args.get("group", ""))
		"is_in":
			return _is_in_group(args.get("path", ""), args.get("group", ""))
		"get_nodes":
			return _get_nodes_in_group(args.get("group", ""))
		"call_group":
			return _call_group(args.get("group", ""), args.get("method", ""), args.get("args", []))
		"set_group":
			return _set_group(args.get("group", ""), args.get("property", ""), args.get("value"))
		_:
			return _error("Unknown action: %s" % action)


func _list_node_groups(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var groups = node.get_groups()
	var group_list: Array[String] = []

	for group in groups:
		# Filter out internal groups
		if not str(group).begins_with("_"):
			group_list.append(str(group))

	return _success({
		"path": path,
		"count": group_list.size(),
		"groups": group_list
	})


func _add_to_group(path: String, group: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if group.is_empty():
		return _error("Group name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node.is_in_group(group):
		return _success({
			"path": path,
			"group": group,
			"already_in_group": true
		}, "Node already in group")

	node.add_to_group(group, true)  # persistent = true

	return _success({
		"path": path,
		"group": group
	}, "Added to group")


func _remove_from_group(path: String, group: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if group.is_empty():
		return _error("Group name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node.is_in_group(group):
		return _error("Node is not in group: %s" % group)

	node.remove_from_group(group)

	return _success({
		"path": path,
		"group": group
	}, "Removed from group")


func _is_in_group(path: String, group: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if group.is_empty():
		return _error("Group name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	return _success({
		"path": path,
		"group": group,
		"is_in_group": node.is_in_group(group)
	})


func _get_nodes_in_group(group: String) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = root.get_tree()
	var nodes = tree.get_nodes_in_group(group)
	var node_list: Array[Dictionary] = []

	for node in nodes:
		node_list.append({
			"path": _get_scene_path(node),
			"type": node.get_class(),
			"name": node.name
		})

	return _success({
		"group": group,
		"count": node_list.size(),
		"nodes": node_list
	})


func _call_group(group: String, method: String, args: Array) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")
	if method.is_empty():
		return _error("Method name is required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = root.get_tree()
	var nodes = tree.get_nodes_in_group(group)

	if nodes.is_empty():
		return _error("No nodes in group: %s" % group)

	# Call method on each node
	var called_count = 0
	for node in nodes:
		if node.has_method(method):
			match args.size():
				0:
					node.call(method)
				1:
					node.call(method, args[0])
				2:
					node.call(method, args[0], args[1])
				3:
					node.call(method, args[0], args[1], args[2])
				_:
					node.callv(method, args)
			called_count += 1

	return _success({
		"group": group,
		"method": method,
		"args": args,
		"nodes_count": nodes.size(),
		"called_count": called_count
	}, "Method called on %d nodes" % called_count)


func _set_group(group: String, property: String, value) -> Dictionary:
	if group.is_empty():
		return _error("Group name is required")
	if property.is_empty():
		return _error("Property name is required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var tree = root.get_tree()
	var nodes = tree.get_nodes_in_group(group)

	if nodes.is_empty():
		return _error("No nodes in group: %s" % group)

	var set_count = 0
	for node in nodes:
		if property in node:
			node.set(property, value)
			set_count += 1

	return _success({
		"group": group,
		"property": property,
		"value": value,
		"nodes_count": nodes.size(),
		"set_count": set_count
	}, "Property set on %d nodes" % set_count)
