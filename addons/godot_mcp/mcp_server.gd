@tool
extends Node
class_name MCPServer

## MCP Server for Godot Engine
## Implements HTTP server with JSON-RPC 2.0 protocol for MCP communication

# Tool imports - Core
const SceneTools = preload("res://addons/godot_mcp/tools/scene_tools.gd")
const NodeTools = preload("res://addons/godot_mcp/tools/node_tools.gd")
const ResourceTools = preload("res://addons/godot_mcp/tools/resource_tools.gd")
const ProjectTools = preload("res://addons/godot_mcp/tools/project_tools.gd")
const ScriptTools = preload("res://addons/godot_mcp/tools/script_tools.gd")
const EditorTools = preload("res://addons/godot_mcp/tools/editor_tools.gd")
const DebugTools = preload("res://addons/godot_mcp/tools/debug_tools.gd")
const FileSystemTools = preload("res://addons/godot_mcp/tools/filesystem_tools.gd")
const AnimationTools = preload("res://addons/godot_mcp/tools/animation_tools.gd")

# Tool imports - Visual
const MaterialTools = preload("res://addons/godot_mcp/tools/material_tools.gd")
const ShaderTools = preload("res://addons/godot_mcp/tools/shader_tools.gd")
const LightingTools = preload("res://addons/godot_mcp/tools/lighting_tools.gd")
const ParticleTools = preload("res://addons/godot_mcp/tools/particle_tools.gd")

# Tool imports - 2D
const TilemapTools = preload("res://addons/godot_mcp/tools/tilemap_tools.gd")
const GeometryTools = preload("res://addons/godot_mcp/tools/geometry_tools.gd")

# Tool imports - Gameplay
const PhysicsTools = preload("res://addons/godot_mcp/tools/physics_tools.gd")
const NavigationTools = preload("res://addons/godot_mcp/tools/navigation_tools.gd")
const AudioTools = preload("res://addons/godot_mcp/tools/audio_tools.gd")

# Tool imports - Utilities
const UITools = preload("res://addons/godot_mcp/tools/ui_tools.gd")
const SignalTools = preload("res://addons/godot_mcp/tools/signal_tools.gd")
const GroupTools = preload("res://addons/godot_mcp/tools/group_tools.gd")

signal server_started
signal server_stopped
signal client_connected
signal client_disconnected
signal request_received(method: String, params: Dictionary)

var _tcp_server: TCPServer
var _port: int = 3000
var _host: String = "127.0.0.1"
var _running: bool = false
var _debug_mode: bool = false
var _clients: Array[StreamPeerTCP] = []
var _pending_data: Dictionary = {}  # client -> accumulated data

# Tool instances
var _tools: Dictionary = {}
var _tool_definitions: Array[Dictionary] = []
var _disabled_tools: Array = []  # List of disabled tool names

# MCP Protocol info
const MCP_VERSION = "2024-11-05"
const SERVER_NAME = "godot-mcp-server"
const SERVER_VERSION = "1.0.0"


func _ready() -> void:
	_tcp_server = TCPServer.new()
	_register_tools()


func _process(_delta: float) -> void:
	if not _running:
		return

	# Accept new connections
	if _tcp_server.is_connection_available():
		var client = _tcp_server.take_connection()
		if client:
			_clients.append(client)
			_pending_data[client] = ""
			print("[MCP] Client connected (total: %d)" % _clients.size())
			client_connected.emit()

	# Process existing clients
	var clients_to_remove: Array[StreamPeerTCP] = []
	for client in _clients:
		client.poll()
		var status = client.get_status()

		if status == StreamPeerTCP.STATUS_CONNECTED:
			var available = client.get_available_bytes()
			if available > 0:
				var data = client.get_data(available)
				if data[0] == OK:
					var request_str = data[1].get_string_from_utf8()
					_pending_data[client] += request_str
					print("[MCP] Received %d bytes, total pending: %d" % [available, _pending_data[client].length()])
					_process_http_request(client)
				else:
					print("[MCP] Error receiving data: %s" % data[0])
		elif status == StreamPeerTCP.STATUS_ERROR or status == StreamPeerTCP.STATUS_NONE:
			clients_to_remove.append(client)
			print("[MCP] Client status changed: %s" % status)

	# Remove disconnected clients
	for client in clients_to_remove:
		_clients.erase(client)
		_pending_data.erase(client)
		if _debug_mode:
			print("[MCP] Client disconnected")
		client_disconnected.emit()


func initialize(port: int, host: String, debug: bool) -> void:
	_port = port
	_host = host
	_debug_mode = debug


func start() -> bool:
	if _running:
		return true

	var error = _tcp_server.listen(_port, _host)
	if error != OK:
		push_error("[MCP] Failed to start server on port %d: %s" % [_port, error_string(error)])
		return false

	_running = true
	print("[MCP] Server started on http://%s:%d/mcp" % [_host, _port])
	server_started.emit()
	return true


func stop() -> void:
	if not _running:
		return

	# Disconnect all clients
	for client in _clients:
		client.disconnect_from_host()
	_clients.clear()
	_pending_data.clear()

	_tcp_server.stop()
	_running = false
	print("[MCP] Server stopped")
	server_stopped.emit()


func is_running() -> bool:
	return _running


func set_port(port: int) -> void:
	_port = port


func set_debug_mode(debug: bool) -> void:
	_debug_mode = debug


func get_connection_count() -> int:
	return _clients.size()


func set_disabled_tools(disabled: Array) -> void:
	_disabled_tools = disabled


func get_disabled_tools() -> Array:
	return _disabled_tools


func is_tool_enabled(tool_name: String) -> bool:
	return not (tool_name in _disabled_tools)


func get_tools_by_category() -> Dictionary:
	"""Returns tools organized by category for UI display"""
	var result: Dictionary = {}

	for category in _tools:
		var executor = _tools[category]
		var tools = executor.get_tools()
		result[category] = tools

	return result


func get_enabled_tools() -> Array[Dictionary]:
	"""Returns only enabled tool definitions"""
	var enabled: Array[Dictionary] = []

	for tool_def in _tool_definitions:
		if is_tool_enabled(tool_def["name"]):
			enabled.append(tool_def)

	return enabled


func _register_tools() -> void:
	# Register all tool executors - Core
	_tools["scene"] = SceneTools.new()
	_tools["node"] = NodeTools.new()
	_tools["resource"] = ResourceTools.new()
	_tools["project"] = ProjectTools.new()
	_tools["script"] = ScriptTools.new()
	_tools["editor"] = EditorTools.new()
	_tools["debug"] = DebugTools.new()
	_tools["filesystem"] = FileSystemTools.new()
	_tools["animation"] = AnimationTools.new()

	# Register all tool executors - Visual
	_tools["material"] = MaterialTools.new()
	_tools["shader"] = ShaderTools.new()
	_tools["lighting"] = LightingTools.new()
	_tools["particle"] = ParticleTools.new()

	# Register all tool executors - 2D
	_tools["tilemap"] = TilemapTools.new()
	_tools["geometry"] = GeometryTools.new()

	# Register all tool executors - Gameplay
	_tools["physics"] = PhysicsTools.new()
	_tools["navigation"] = NavigationTools.new()
	_tools["audio"] = AudioTools.new()

	# Register all tool executors - Utilities
	_tools["ui"] = UITools.new()
	_tools["signal"] = SignalTools.new()
	_tools["group"] = GroupTools.new()

	# Collect all tool definitions
	_tool_definitions.clear()
	for category in _tools:
		var executor = _tools[category]
		var tools = executor.get_tools()
		for tool_def in tools:
			tool_def["name"] = "%s_%s" % [category, tool_def["name"]]
			_tool_definitions.append(tool_def)

	if _debug_mode:
		print("[MCP] Registered %d tools" % _tool_definitions.size())


func _process_http_request(client: StreamPeerTCP) -> void:
	var data = _pending_data.get(client, "")
	if data.is_empty():
		return

	# Check for complete HTTP request (headers end with \r\n\r\n)
	var header_end = data.find("\r\n\r\n")
	if header_end == -1:
		if _debug_mode and data.length() > 0:
			print("[MCP] Waiting for headers... current data length: %d" % data.length())
		return

	# Parse HTTP headers
	var header_section = data.substr(0, header_end)
	var headers = _parse_http_headers(header_section)

	if headers.is_empty():
		_pending_data[client] = ""
		return

	# Get content length - support chunked encoding
	var content_length = 0
	var is_chunked = false

	if headers.has("content-length"):
		content_length = int(headers["content-length"])
	elif headers.has("transfer-encoding") and headers["transfer-encoding"].to_lower().contains("chunked"):
		is_chunked = true

	# Check if we have complete body
	var body_start = header_end + 4
	var body = data.substr(body_start)

	# IMPORTANT: Content-Length is in bytes, not characters!
	# For UTF-8 strings with multi-byte chars (emojis, Chinese, etc.), we must compare byte sizes
	var body_bytes = body.to_utf8_buffer()
	var body_byte_size = body_bytes.size()

	print("[MCP] Request headers: method=%s, content_length=%d, body_bytes=%d, chunked=%s" % [headers.get("method", "?"), content_length, body_byte_size, is_chunked])

	# Handle chunked encoding
	if is_chunked:
		var decoded_body = _decode_chunked_body(body)
		if decoded_body == null:
			print("[MCP] Waiting for chunked body...")
			return  # Wait for more data
		body = decoded_body
		content_length = body.to_utf8_buffer().size()
	elif body_byte_size < content_length:
		print("[MCP] Waiting for body... need %d bytes, have %d bytes" % [content_length, body_byte_size])
		return  # Wait for more data

	# Extract the complete request body (by bytes, then convert back to string)
	var request_body: String
	if is_chunked:
		request_body = body
		_pending_data[client] = ""
	else:
		# Extract exactly content_length bytes and convert to string
		var request_bytes = body_bytes.slice(0, content_length)
		request_body = request_bytes.get_string_from_utf8()
		# Remove processed data (also by bytes)
		if body_byte_size > content_length:
			var remaining_bytes = body_bytes.slice(content_length)
			_pending_data[client] = remaining_bytes.get_string_from_utf8()
		else:
			_pending_data[client] = ""

	# Route request
	var method = headers.get("method", "GET")
	var path = headers.get("path", "/")

	print("[MCP] Processing: %s %s (body length: %d)" % [method, path, request_body.length()])

	var response: Dictionary

	if method == "POST" and path == "/mcp":
		print("[MCP] Handling MCP request...")
		response = _handle_mcp_request(request_body)
		print("[MCP] MCP response ready")
	elif method == "GET" and path == "/health":
		response = _create_health_response()
	elif method == "GET" and path == "/api/tools":
		response = _create_tools_list_response()
	elif method == "OPTIONS":
		response = _create_cors_response()
	else:
		response = {"error": "Not found", "status": 404}

	print("[MCP] Sending response...")
	_send_http_response(client, response)
	print("[MCP] Response sent")


func _decode_chunked_body(data: String):
	# Decode chunked transfer encoding
	# Returns null if more data is needed, or the decoded body string
	var result = ""
	var pos = 0

	while pos < data.length():
		# Find chunk size line end
		var line_end = data.find("\r\n", pos)
		if line_end == -1:
			return null  # Need more data

		# Parse chunk size (hex)
		var size_str = data.substr(pos, line_end - pos).strip_edges()
		# Remove any chunk extensions
		var semicolon = size_str.find(";")
		if semicolon != -1:
			size_str = size_str.substr(0, semicolon)

		var chunk_size = size_str.hex_to_int()

		if chunk_size == 0:
			# Last chunk - check for trailer and final CRLF
			return result

		# Check if we have the full chunk
		var chunk_start = line_end + 2
		var chunk_end = chunk_start + chunk_size

		if chunk_end + 2 > data.length():
			return null  # Need more data

		# Extract chunk data
		result += data.substr(chunk_start, chunk_size)
		pos = chunk_end + 2  # Skip chunk data and trailing CRLF

	return null  # Need more data


func _close_client(client: StreamPeerTCP) -> void:
	if client in _clients:
		client.disconnect_from_host()
		_clients.erase(client)
		_pending_data.erase(client)
		if _debug_mode:
			print("[MCP] Client connection closed")


func _parse_http_headers(header_section: String) -> Dictionary:
	var result: Dictionary = {}
	var lines = header_section.split("\r\n")

	if lines.size() == 0:
		return result

	# Parse request line
	var request_line = lines[0].split(" ")
	if request_line.size() >= 2:
		result["method"] = request_line[0]
		result["path"] = request_line[1]

	# Parse headers
	for i in range(1, lines.size()):
		var line = lines[i]
		var colon_pos = line.find(":")
		if colon_pos > 0:
			var key = line.substr(0, colon_pos).strip_edges().to_lower()
			var value = line.substr(colon_pos + 1).strip_edges()
			result[key] = value

	return result


func _handle_mcp_request(body: String) -> Dictionary:
	print("[MCP] Parsing request body (%d bytes)..." % body.length())
	if body.length() < 500:
		print("[MCP] Body: %s" % body)

	var json = JSON.new()
	var error = json.parse(body)

	if error != OK:
		push_error("[MCP] JSON parse error: %s" % json.get_error_message())
		return _create_json_rpc_error(-32700, "Parse error: %s" % json.get_error_message(), null)

	var request = json.get_data()
	if not request is Dictionary:
		return _create_json_rpc_error(-32600, "Invalid Request", null)

	var method = request.get("method", "")
	var params = request.get("params", {})
	var id = request.get("id")

	print("[MCP] Method: %s, ID: %s" % [method, id])

	request_received.emit(method, params)

	var response: Dictionary

	match method:
		"initialize":
			response = _handle_initialize(params, id)
		"initialized":
			response = _create_json_rpc_response({}, id)
		"tools/list":
			response = _handle_tools_list(params, id)
		"tools/call":
			response = _handle_tools_call(params, id)
		"ping":
			response = _create_json_rpc_response({}, id)
		_:
			response = _create_json_rpc_error(-32601, "Method not found: %s" % method, id)

	if _debug_mode:
		print("[MCP] Response ready for method: %s" % method)

	return response


func _handle_initialize(params: Dictionary, id) -> Dictionary:
	var result = {
		"protocolVersion": MCP_VERSION,
		"capabilities": {
			"tools": {
				"listChanged": false
			}
		},
		"serverInfo": {
			"name": SERVER_NAME,
			"version": SERVER_VERSION
		}
	}
	return _create_json_rpc_response(result, id)


func _handle_tools_list(_params: Dictionary, id) -> Dictionary:
	var tools_list: Array[Dictionary] = []

	for tool_def in _tool_definitions:
		# Only include enabled tools
		if is_tool_enabled(tool_def["name"]):
			tools_list.append({
				"name": tool_def["name"],
				"description": tool_def.get("description", ""),
				"inputSchema": tool_def.get("inputSchema", {
					"type": "object",
					"properties": {}
				})
			})

	return _create_json_rpc_response({"tools": tools_list}, id)


func _handle_tools_call(params: Dictionary, id) -> Dictionary:
	var tool_name = params.get("name", "")
	var arguments = params.get("arguments", {})

	print("[MCP] Tool call: %s" % tool_name)

	if tool_name.is_empty():
		return _create_tool_response({"success": false, "error": "Missing tool name"}, id)

	# Check if tool is enabled
	if not is_tool_enabled(tool_name):
		return _create_tool_response({"success": false, "error": "Tool '%s' is disabled" % tool_name}, id)

	# Parse tool name: category_toolname
	var parts = tool_name.split("_", true, 1)
	if parts.size() < 2:
		return _create_tool_response({"success": false, "error": "Invalid tool name format: %s" % tool_name}, id)

	var category = parts[0]
	var actual_tool_name = parts[1]

	print("[MCP] Category: %s, Tool: %s" % [category, actual_tool_name])

	if not _tools.has(category):
		return _create_tool_response({"success": false, "error": "Unknown tool category: %s" % category}, id)

	var executor = _tools[category]
	var result: Dictionary

	print("[MCP] Executing tool...")
	# Execute with error handling
	result = executor.execute(actual_tool_name, arguments)

	print("[MCP] Tool result: success=%s" % result.get("success", false))

	return _create_tool_response(result, id)


func _create_tool_response(result: Dictionary, id) -> Dictionary:
	# Always return as success to avoid AI client errors
	# Error information is included in the result message
	var sanitized_result = _sanitize_for_json(result)
	var result_text = JSON.stringify(sanitized_result)

	if _debug_mode:
		print("[MCP] Tool response text length: %d" % result_text.length())

	return _create_json_rpc_response({
		"content": [{
			"type": "text",
			"text": result_text
		}],
		"isError": false
	}, id)


func _create_json_rpc_response(result, id) -> Dictionary:
	return {
		"jsonrpc": "2.0",
		"result": result,
		"id": id
	}


func _create_json_rpc_error(code: int, message: String, id) -> Dictionary:
	return {
		"jsonrpc": "2.0",
		"error": {
			"code": code,
			"message": message
		},
		"id": id
	}


func _create_health_response() -> Dictionary:
	return {
		"status": "ok",
		"server": SERVER_NAME,
		"version": SERVER_VERSION,
		"running": _running,
		"connections": _clients.size()
	}


func _create_tools_list_response() -> Dictionary:
	return {
		"tools": _tool_definitions
	}


func _create_cors_response() -> Dictionary:
	return {
		"status": 204,
		"cors": true
	}


func _send_http_response(client: StreamPeerTCP, data: Dictionary) -> void:
	# Sanitize data before JSON serialization
	var sanitized = _sanitize_for_json(data)
	var body = JSON.stringify(sanitized)
	var body_bytes = body.to_utf8_buffer()
	var status_code = data.get("status", 200)
	var status_text = "OK" if status_code == 200 else "Error"

	var status_texts = {200: "OK", 204: "No Content", 404: "Not Found", 500: "Internal Server Error"}
	status_text = status_texts.get(status_code, "OK")

	var headers = "HTTP/1.1 %d %s\r\n" % [status_code, status_text]
	headers += "Content-Type: application/json; charset=utf-8\r\n"
	headers += "Content-Length: %d\r\n" % body_bytes.size()
	headers += "Access-Control-Allow-Origin: *\r\n"
	headers += "Access-Control-Allow-Methods: GET, POST, OPTIONS\r\n"
	headers += "Access-Control-Allow-Headers: Content-Type, Accept, X-Requested-With, Authorization\r\n"
	headers += "Access-Control-Max-Age: 86400\r\n"
	headers += "Connection: keep-alive\r\n"
	headers += "\r\n"

	# Send headers and body
	var header_bytes = headers.to_utf8_buffer()
	var err1 = client.put_data(header_bytes)
	var err2 = client.put_data(body_bytes)

	print("[MCP] Response sent: status=%d, size=%d bytes, errors=(h:%s, b:%s)" % [status_code, body_bytes.size(), err1, err2])


func _sanitize_for_json(value):
	"""Recursively sanitize values to ensure valid JSON serialization"""
	match typeof(value):
		TYPE_DICTIONARY:
			var result = {}
			for key in value:
				# Ensure key is a string
				var str_key = str(key)
				result[str_key] = _sanitize_for_json(value[key])
			return result
		TYPE_ARRAY:
			var result = []
			for item in value:
				result.append(_sanitize_for_json(item))
			return result
		TYPE_FLOAT:
			# Handle NaN and Infinity which are not valid JSON
			if is_nan(value):
				return 0.0
			if is_inf(value):
				return 999999999.0 if value > 0 else -999999999.0
			return value
		TYPE_STRING:
			# Ensure string is valid
			return value
		TYPE_STRING_NAME:
			return str(value)
		TYPE_NODE_PATH:
			return str(value)
		TYPE_OBJECT:
			# Convert objects to string representation
			if value == null:
				return null
			return str(value)
		TYPE_VECTOR2, TYPE_VECTOR3, TYPE_VECTOR4:
			return str(value)
		TYPE_COLOR:
			return {"r": value.r, "g": value.g, "b": value.b, "a": value.a}
		TYPE_NIL:
			return null
		_:
			return value
