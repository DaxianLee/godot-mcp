@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Navigation tools for Godot MCP
## Provides NavigationMesh, NavigationAgent, and pathfinding operations


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "navigation",
			"description": """NAVIGATION SYSTEM: Manage navigation meshes, regions, and agents.

ACTIONS:
- get_map_info: Get navigation map information
- list_regions: List all NavigationRegion2D/3D nodes
- list_agents: List all NavigationAgent2D/3D nodes
- bake_mesh: Bake a NavigationRegion's mesh
- get_path: Calculate path between two points
- set_agent_target: Set an agent's target position
- get_agent_info: Get agent state information
- set_region_enabled: Enable/disable a navigation region
- set_agent_enabled: Enable/disable navigation agent

NAVIGATION TYPES:
- 2D: Uses NavigationServer2D, NavigationRegion2D, NavigationAgent2D
- 3D: Uses NavigationServer3D, NavigationRegion3D, NavigationAgent3D

EXAMPLES:
- Get map info: {"action": "get_map_info"}
- List regions: {"action": "list_regions"}
- Bake mesh: {"action": "bake_mesh", "path": "/root/NavigationRegion3D"}
- Get path: {"action": "get_path", "from": {"x": 0, "y": 0, "z": 0}, "to": {"x": 10, "y": 0, "z": 10}, "mode": "3d"}
- Set target: {"action": "set_agent_target", "path": "/root/Enemy/NavigationAgent3D", "target": {"x": 5, "y": 0, "z": 5}}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_map_info", "list_regions", "list_agents", "bake_mesh", "get_path", "set_agent_target", "get_agent_info", "set_region_enabled", "set_agent_enabled"],
						"description": "Navigation action"
					},
					"path": {
						"type": "string",
						"description": "Node path for regions/agents"
					},
					"mode": {
						"type": "string",
						"enum": ["2d", "3d"],
						"description": "Navigation mode (2D or 3D)"
					},
					"from": {
						"type": "object",
						"description": "Start position {x, y} or {x, y, z}"
					},
					"to": {
						"type": "object",
						"description": "End position {x, y} or {x, y, z}"
					},
					"target": {
						"type": "object",
						"description": "Target position for agent"
					},
					"enabled": {
						"type": "boolean",
						"description": "Enable/disable state"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"navigation":
			return _execute_navigation(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


func _execute_navigation(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get_map_info":
			return _get_map_info(args.get("mode", "3d"))
		"list_regions":
			return _list_regions(args.get("mode", ""))
		"list_agents":
			return _list_agents(args.get("mode", ""))
		"bake_mesh":
			return _bake_mesh(args.get("path", ""))
		"get_path":
			return _get_navigation_path(args)
		"set_agent_target":
			return _set_agent_target(args.get("path", ""), args.get("target", {}))
		"get_agent_info":
			return _get_agent_info(args.get("path", ""))
		"set_region_enabled":
			return _set_region_enabled(args.get("path", ""), args.get("enabled", true))
		"set_agent_enabled":
			return _set_agent_enabled(args.get("path", ""), args.get("enabled", true))
		_:
			return _error("Unknown action: %s" % action)


func _get_map_info(mode: String) -> Dictionary:
	var info = {}

	if mode == "3d" or mode.is_empty():
		var map_3d = NavigationServer3D.get_maps()
		info["3d"] = {
			"map_count": map_3d.size(),
			"maps": []
		}
		for map_rid in map_3d:
			var map_info = {
				"active": NavigationServer3D.map_is_active(map_rid),
				"cell_size": NavigationServer3D.map_get_cell_size(map_rid),
				"cell_height": NavigationServer3D.map_get_cell_height(map_rid),
				"edge_connection_margin": NavigationServer3D.map_get_edge_connection_margin(map_rid),
				"link_connection_radius": NavigationServer3D.map_get_link_connection_radius(map_rid)
			}
			info["3d"]["maps"].append(map_info)

	if mode == "2d" or mode.is_empty():
		var map_2d = NavigationServer2D.get_maps()
		info["2d"] = {
			"map_count": map_2d.size(),
			"maps": []
		}
		for map_rid in map_2d:
			var map_info = {
				"active": NavigationServer2D.map_is_active(map_rid),
				"cell_size": NavigationServer2D.map_get_cell_size(map_rid),
				"edge_connection_margin": NavigationServer2D.map_get_edge_connection_margin(map_rid),
				"link_connection_radius": NavigationServer2D.map_get_link_connection_radius(map_rid)
			}
			info["2d"]["maps"].append(map_info)

	return _success(info)


func _list_regions(mode: String) -> Dictionary:
	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var regions: Array[Dictionary] = []
	_find_navigation_regions(root, regions, mode)

	return _success({
		"count": regions.size(),
		"regions": regions
	})


func _find_navigation_regions(node: Node, result: Array[Dictionary], mode: String) -> void:
	if node is NavigationRegion3D and (mode == "3d" or mode.is_empty()):
		result.append({
			"path": _get_scene_path(node),
			"type": "NavigationRegion3D",
			"enabled": node.enabled,
			"has_mesh": node.navigation_mesh != null,
			"layers": node.navigation_layers
		})
	elif node is NavigationRegion2D and (mode == "2d" or mode.is_empty()):
		result.append({
			"path": _get_scene_path(node),
			"type": "NavigationRegion2D",
			"enabled": node.enabled,
			"has_polygon": node.navigation_polygon != null,
			"layers": node.navigation_layers
		})

	for child in node.get_children():
		_find_navigation_regions(child, result, mode)


func _list_agents(mode: String) -> Dictionary:
	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var agents: Array[Dictionary] = []
	_find_navigation_agents(root, agents, mode)

	return _success({
		"count": agents.size(),
		"agents": agents
	})


func _find_navigation_agents(node: Node, result: Array[Dictionary], mode: String) -> void:
	if node is NavigationAgent3D and (mode == "3d" or mode.is_empty()):
		result.append({
			"path": _get_scene_path(node),
			"type": "NavigationAgent3D",
			"target_position": _serialize_value(node.target_position),
			"radius": node.radius,
			"height": node.height,
			"path_desired_distance": node.path_desired_distance,
			"target_desired_distance": node.target_desired_distance,
			"avoidance_enabled": node.avoidance_enabled
		})
	elif node is NavigationAgent2D and (mode == "2d" or mode.is_empty()):
		result.append({
			"path": _get_scene_path(node),
			"type": "NavigationAgent2D",
			"target_position": _serialize_value(node.target_position),
			"radius": node.radius,
			"path_desired_distance": node.path_desired_distance,
			"target_desired_distance": node.target_desired_distance,
			"avoidance_enabled": node.avoidance_enabled
		})

	for child in node.get_children():
		_find_navigation_agents(child, result, mode)


func _bake_mesh(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is NavigationRegion3D:
		if not node.navigation_mesh:
			return _error("NavigationRegion3D has no NavigationMesh")

		node.bake_navigation_mesh()
		return _success({
			"path": path,
			"type": "NavigationRegion3D"
		}, "Navigation mesh baking started")

	elif node is NavigationRegion2D:
		if not node.navigation_polygon:
			return _error("NavigationRegion2D has no NavigationPolygon")

		node.bake_navigation_polygon()
		return _success({
			"path": path,
			"type": "NavigationRegion2D"
		}, "Navigation polygon baking started")

	return _error("Node is not a NavigationRegion")


func _get_navigation_path(args: Dictionary) -> Dictionary:
	var mode = args.get("mode", "3d")
	var from_dict = args.get("from", {})
	var to_dict = args.get("to", {})

	if from_dict.is_empty() or to_dict.is_empty():
		return _error("Both 'from' and 'to' positions are required")

	if mode == "3d":
		var from = Vector3(from_dict.get("x", 0), from_dict.get("y", 0), from_dict.get("z", 0))
		var to = Vector3(to_dict.get("x", 0), to_dict.get("y", 0), to_dict.get("z", 0))

		var maps = NavigationServer3D.get_maps()
		if maps.is_empty():
			return _error("No 3D navigation maps available")

		var map = maps[0]  # Use first map
		var path = NavigationServer3D.map_get_path(map, from, to, true)

		var path_points: Array[Dictionary] = []
		for point in path:
			path_points.append(_serialize_value(point))

		return _success({
			"mode": "3d",
			"from": _serialize_value(from),
			"to": _serialize_value(to),
			"point_count": path_points.size(),
			"path": path_points,
			"valid": path_points.size() > 0
		})

	else:  # 2d
		var from = Vector2(from_dict.get("x", 0), from_dict.get("y", 0))
		var to = Vector2(to_dict.get("x", 0), to_dict.get("y", 0))

		var maps = NavigationServer2D.get_maps()
		if maps.is_empty():
			return _error("No 2D navigation maps available")

		var map = maps[0]
		var path = NavigationServer2D.map_get_path(map, from, to, true)

		var path_points: Array[Dictionary] = []
		for point in path:
			path_points.append(_serialize_value(point))

		return _success({
			"mode": "2d",
			"from": _serialize_value(from),
			"to": _serialize_value(to),
			"point_count": path_points.size(),
			"path": path_points,
			"valid": path_points.size() > 0
		})


func _set_agent_target(path: String, target_dict: Dictionary) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if target_dict.is_empty():
		return _error("Target position is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is NavigationAgent3D:
		var target = Vector3(target_dict.get("x", 0), target_dict.get("y", 0), target_dict.get("z", 0))
		node.target_position = target
		return _success({
			"path": path,
			"target": _serialize_value(target)
		}, "Agent target set")

	elif node is NavigationAgent2D:
		var target = Vector2(target_dict.get("x", 0), target_dict.get("y", 0))
		node.target_position = target
		return _success({
			"path": path,
			"target": _serialize_value(target)
		}, "Agent target set")

	return _error("Node is not a NavigationAgent")


func _get_agent_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is NavigationAgent3D:
		return _success({
			"path": path,
			"type": "NavigationAgent3D",
			"target_position": _serialize_value(node.target_position),
			"is_target_reached": node.is_target_reached(),
			"is_target_reachable": node.is_target_reachable(),
			"is_navigation_finished": node.is_navigation_finished(),
			"distance_to_target": node.distance_to_target(),
			"next_path_position": _serialize_value(node.get_next_path_position()),
			"current_navigation_path_index": node.get_current_navigation_path_index(),
			"velocity": _serialize_value(node.velocity),
			"radius": node.radius,
			"height": node.height,
			"max_speed": node.max_speed,
			"avoidance_enabled": node.avoidance_enabled
		})

	elif node is NavigationAgent2D:
		return _success({
			"path": path,
			"type": "NavigationAgent2D",
			"target_position": _serialize_value(node.target_position),
			"is_target_reached": node.is_target_reached(),
			"is_target_reachable": node.is_target_reachable(),
			"is_navigation_finished": node.is_navigation_finished(),
			"distance_to_target": node.distance_to_target(),
			"next_path_position": _serialize_value(node.get_next_path_position()),
			"current_navigation_path_index": node.get_current_navigation_path_index(),
			"velocity": _serialize_value(node.velocity),
			"radius": node.radius,
			"max_speed": node.max_speed,
			"avoidance_enabled": node.avoidance_enabled
		})

	return _error("Node is not a NavigationAgent")


func _set_region_enabled(path: String, enabled: bool) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is NavigationRegion3D or node is NavigationRegion2D:
		node.enabled = enabled
		return _success({
			"path": path,
			"enabled": enabled
		}, "Region %s" % ("enabled" if enabled else "disabled"))

	return _error("Node is not a NavigationRegion")


func _set_agent_enabled(path: String, enabled: bool) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is NavigationAgent3D or node is NavigationAgent2D:
		# Agents don't have an enabled property, but we can enable/disable avoidance
		node.avoidance_enabled = enabled
		return _success({
			"path": path,
			"avoidance_enabled": enabled
		}, "Agent avoidance %s" % ("enabled" if enabled else "disabled"))

	return _error("Node is not a NavigationAgent")
