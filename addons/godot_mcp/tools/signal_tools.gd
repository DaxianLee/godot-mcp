@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Signal tools for Godot MCP
## Provides signal inspection and connection management


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "signal",
			"description": """SIGNALS: Inspect and manage node signals and connections.

ACTIONS:
- list: List all signals of a node
- get_info: Get detailed signal information
- list_connections: List all connections of a signal
- connect: Connect a signal to a method
- disconnect: Disconnect a signal
- disconnect_all: Disconnect all connections of a signal
- emit: Emit a signal (for testing)
- is_connected: Check if signal is connected
- list_all_connections: List all signal connections in scene

EXAMPLES:
- List signals: {"action": "list", "path": "/root/Button"}
- Get signal info: {"action": "get_info", "path": "/root/Button", "signal": "pressed"}
- List connections: {"action": "list_connections", "path": "/root/Button", "signal": "pressed"}
- Connect signal: {"action": "connect", "source": "/root/Button", "signal": "pressed", "target": "/root/Player", "method": "_on_button_pressed"}
- Disconnect: {"action": "disconnect", "source": "/root/Button", "signal": "pressed", "target": "/root/Player", "method": "_on_button_pressed"}
- Emit signal: {"action": "emit", "path": "/root/Button", "signal": "pressed"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "get_info", "list_connections", "connect", "disconnect", "disconnect_all", "emit", "is_connected", "list_all_connections"],
						"description": "Signal action"
					},
					"path": {
						"type": "string",
						"description": "Node path"
					},
					"source": {
						"type": "string",
						"description": "Source node path (for connect/disconnect)"
					},
					"target": {
						"type": "string",
						"description": "Target node path"
					},
					"signal": {
						"type": "string",
						"description": "Signal name"
					},
					"method": {
						"type": "string",
						"description": "Target method name"
					},
					"args": {
						"type": "array",
						"description": "Arguments for signal emission"
					},
					"flags": {
						"type": "integer",
						"description": "Connection flags"
					},
					"include_inherited": {
						"type": "boolean",
						"description": "Include inherited signals"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"signal":
			return _execute_signal(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


func _execute_signal(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"list":
			return _list_signals(args.get("path", ""), args.get("include_inherited", true))
		"get_info":
			return _get_signal_info(args.get("path", ""), args.get("signal", ""))
		"list_connections":
			return _list_connections(args.get("path", ""), args.get("signal", ""))
		"connect":
			return _connect_signal(args)
		"disconnect":
			return _disconnect_signal(args)
		"disconnect_all":
			return _disconnect_all(args.get("path", ""), args.get("signal", ""))
		"emit":
			return _emit_signal(args.get("path", ""), args.get("signal", ""), args.get("args", []))
		"is_connected":
			return _is_connected(args)
		"list_all_connections":
			return _list_all_connections()
		_:
			return _error("Unknown action: %s" % action)


func _list_signals(path: String, include_inherited: bool) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var signals: Array[Dictionary] = []
	var signal_list = node.get_signal_list()

	for sig in signal_list:
		var sig_info = {
			"name": sig["name"],
			"args": []
		}

		for arg in sig["args"]:
			sig_info["args"].append({
				"name": arg["name"],
				"type": type_string(arg["type"])
			})

		# Check connection count
		var connections = node.get_signal_connection_list(sig["name"])
		sig_info["connection_count"] = connections.size()

		signals.append(sig_info)

	return _success({
		"path": path,
		"count": signals.size(),
		"signals": signals
	})


func _get_signal_info(path: String, signal_name: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if signal_name.is_empty():
		return _error("Signal name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node.has_signal(signal_name):
		return _error("Signal not found: %s" % signal_name)

	var signal_list = node.get_signal_list()
	var sig_info: Dictionary = {}

	for sig in signal_list:
		if sig["name"] == signal_name:
			sig_info = sig
			break

	var args: Array[Dictionary] = []
	for arg in sig_info.get("args", []):
		args.append({
			"name": arg["name"],
			"type": type_string(arg["type"]),
			"class_name": arg.get("class_name", "")
		})

	var connections = node.get_signal_connection_list(signal_name)
	var conn_list: Array[Dictionary] = []

	for conn in connections:
		conn_list.append({
			"target": _get_scene_path(conn["callable"].get_object()) if conn["callable"].get_object() else "",
			"method": conn["callable"].get_method(),
			"flags": conn["flags"]
		})

	return _success({
		"path": path,
		"signal": signal_name,
		"args": args,
		"connection_count": connections.size(),
		"connections": conn_list
	})


func _list_connections(path: String, signal_name: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if signal_name.is_empty():
		return _error("Signal name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node.has_signal(signal_name):
		return _error("Signal not found: %s" % signal_name)

	var connections = node.get_signal_connection_list(signal_name)
	var conn_list: Array[Dictionary] = []

	for conn in connections:
		var target_obj = conn["callable"].get_object()
		conn_list.append({
			"target_path": _get_scene_path(target_obj) if target_obj and target_obj is Node else "",
			"target_object": str(target_obj) if target_obj else "",
			"method": conn["callable"].get_method(),
			"flags": conn["flags"]
		})

	return _success({
		"path": path,
		"signal": signal_name,
		"count": conn_list.size(),
		"connections": conn_list
	})


func _connect_signal(args: Dictionary) -> Dictionary:
	var source_path = args.get("source", args.get("path", ""))
	var signal_name = args.get("signal", "")
	var target_path = args.get("target", "")
	var method_name = args.get("method", "")
	var flags = args.get("flags", 0)

	if source_path.is_empty():
		return _error("Source path is required")
	if signal_name.is_empty():
		return _error("Signal name is required")
	if target_path.is_empty():
		return _error("Target path is required")
	if method_name.is_empty():
		return _error("Method name is required")

	var source = _find_node_by_path(source_path)
	if not source:
		return _error("Source not found: %s" % source_path)

	var target = _find_node_by_path(target_path)
	if not target:
		return _error("Target not found: %s" % target_path)

	if not source.has_signal(signal_name):
		return _error("Signal not found: %s" % signal_name)

	if source.is_connected(signal_name, Callable(target, method_name)):
		return _error("Signal already connected")

	var error = source.connect(signal_name, Callable(target, method_name), flags)
	if error != OK:
		return _error("Failed to connect: %s" % error_string(error))

	return _success({
		"source": source_path,
		"signal": signal_name,
		"target": target_path,
		"method": method_name
	}, "Signal connected")


func _disconnect_signal(args: Dictionary) -> Dictionary:
	var source_path = args.get("source", args.get("path", ""))
	var signal_name = args.get("signal", "")
	var target_path = args.get("target", "")
	var method_name = args.get("method", "")

	if source_path.is_empty():
		return _error("Source path is required")
	if signal_name.is_empty():
		return _error("Signal name is required")
	if target_path.is_empty():
		return _error("Target path is required")
	if method_name.is_empty():
		return _error("Method name is required")

	var source = _find_node_by_path(source_path)
	if not source:
		return _error("Source not found: %s" % source_path)

	var target = _find_node_by_path(target_path)
	if not target:
		return _error("Target not found: %s" % target_path)

	var callable = Callable(target, method_name)
	if not source.is_connected(signal_name, callable):
		return _error("Signal not connected")

	source.disconnect(signal_name, callable)

	return _success({
		"source": source_path,
		"signal": signal_name,
		"target": target_path,
		"method": method_name
	}, "Signal disconnected")


func _disconnect_all(path: String, signal_name: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if signal_name.is_empty():
		return _error("Signal name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node.has_signal(signal_name):
		return _error("Signal not found: %s" % signal_name)

	var connections = node.get_signal_connection_list(signal_name)
	var count = connections.size()

	for conn in connections:
		node.disconnect(signal_name, conn["callable"])

	return _success({
		"path": path,
		"signal": signal_name,
		"disconnected_count": count
	}, "All connections disconnected")


func _emit_signal(path: String, signal_name: String, args: Array) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if signal_name.is_empty():
		return _error("Signal name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node.has_signal(signal_name):
		return _error("Signal not found: %s" % signal_name)

	# Emit with arguments
	match args.size():
		0:
			node.emit_signal(signal_name)
		1:
			node.emit_signal(signal_name, args[0])
		2:
			node.emit_signal(signal_name, args[0], args[1])
		3:
			node.emit_signal(signal_name, args[0], args[1], args[2])
		4:
			node.emit_signal(signal_name, args[0], args[1], args[2], args[3])
		_:
			return _error("Too many arguments (max 4)")

	return _success({
		"path": path,
		"signal": signal_name,
		"args": args
	}, "Signal emitted")


func _is_connected(args: Dictionary) -> Dictionary:
	var source_path = args.get("source", args.get("path", ""))
	var signal_name = args.get("signal", "")
	var target_path = args.get("target", "")
	var method_name = args.get("method", "")

	if source_path.is_empty() or signal_name.is_empty() or target_path.is_empty() or method_name.is_empty():
		return _error("source, signal, target, and method are required")

	var source = _find_node_by_path(source_path)
	if not source:
		return _error("Source not found: %s" % source_path)

	var target = _find_node_by_path(target_path)
	if not target:
		return _error("Target not found: %s" % target_path)

	var connected = source.is_connected(signal_name, Callable(target, method_name))

	return _success({
		"source": source_path,
		"signal": signal_name,
		"target": target_path,
		"method": method_name,
		"connected": connected
	})


func _list_all_connections() -> Dictionary:
	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var all_connections: Array[Dictionary] = []
	_collect_connections(root, all_connections)

	return _success({
		"count": all_connections.size(),
		"connections": all_connections
	})


func _collect_connections(node: Node, result: Array[Dictionary]) -> void:
	var signal_list = node.get_signal_list()

	for sig in signal_list:
		var connections = node.get_signal_connection_list(sig["name"])
		for conn in connections:
			var target_obj = conn["callable"].get_object()
			result.append({
				"source": _get_scene_path(node),
				"signal": sig["name"],
				"target": _get_scene_path(target_obj) if target_obj and target_obj is Node else str(target_obj),
				"method": conn["callable"].get_method()
			})

	for child in node.get_children():
		_collect_connections(child, result)
