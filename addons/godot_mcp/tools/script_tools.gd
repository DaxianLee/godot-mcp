@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Script management tools for Godot MCP
## Provides script creation, editing, and attachment to nodes


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "manage",
			"description": """SCRIPT MANAGEMENT: Create, read, and modify GDScript files.

ACTIONS:
- create: Create a new script file
- read: Read script content
- write: Write/update script content
- get_info: Get script metadata (base class, methods, etc.)
- delete: Delete a script file

SCRIPT TEMPLATES:
- When creating scripts, specify the base class (extends)
- Common base classes: Node, Node2D, Node3D, CharacterBody2D, CharacterBody3D, RigidBody2D, RigidBody3D, Area2D, Area3D, Control, Resource

EXAMPLES:
- Create script: {"action": "create", "path": "res://scripts/player.gd", "extends": "CharacterBody2D"}
- Read script: {"action": "read", "path": "res://scripts/player.gd"}
- Write script: {"action": "write", "path": "res://scripts/player.gd", "content": "extends Node2D\\n\\nfunc _ready():\\n\\tpass"}
- Get info: {"action": "get_info", "path": "res://scripts/player.gd"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "read", "write", "get_info", "delete"],
						"description": "Script action"
					},
					"path": {
						"type": "string",
						"description": "Script file path (res://...)"
					},
					"content": {
						"type": "string",
						"description": "Script content for write action"
					},
					"extends": {
						"type": "string",
						"description": "Base class for new script"
					},
					"class_name": {
						"type": "string",
						"description": "Optional class_name for the script"
					}
				},
				"required": ["action", "path"]
			}
		},
		{
			"name": "attach",
			"description": """SCRIPT ATTACHMENT: Attach or detach scripts from nodes.

ACTIONS:
- attach: Attach a script to a node
- detach: Remove script from a node
- get_attached: Get the script attached to a node
- create_and_attach: Create a new script and attach it to a node

EXAMPLES:
- Attach script: {"action": "attach", "node_path": "/root/Player", "script_path": "res://scripts/player.gd"}
- Detach script: {"action": "detach", "node_path": "/root/Player"}
- Get attached: {"action": "get_attached", "node_path": "/root/Player"}
- Create and attach: {"action": "create_and_attach", "node_path": "/root/Player", "script_path": "res://scripts/player.gd", "extends": "CharacterBody2D"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["attach", "detach", "get_attached", "create_and_attach"],
						"description": "Attachment action"
					},
					"node_path": {
						"type": "string",
						"description": "Node path in scene"
					},
					"script_path": {
						"type": "string",
						"description": "Script file path"
					},
					"extends": {
						"type": "string",
						"description": "Base class for new script"
					}
				},
				"required": ["action", "node_path"]
			}
		},
		{
			"name": "edit",
			"description": """SCRIPT EDITING: Edit script content programmatically.

ACTIONS:
- add_function: Add a new function to script
- remove_function: Remove a function from script
- add_variable: Add a variable declaration
- add_signal: Add a signal declaration
- add_export: Add an exported variable
- get_functions: List all functions in script
- get_variables: List all variables in script

EXAMPLES:
- Add function: {"action": "add_function", "path": "res://scripts/player.gd", "name": "take_damage", "params": ["amount: int"], "body": "health -= amount\\nif health <= 0:\\n\\tdie()"}
- Add variable: {"action": "add_variable", "path": "res://scripts/player.gd", "name": "health", "type": "int", "value": "100"}
- Add signal: {"action": "add_signal", "path": "res://scripts/player.gd", "name": "died"}
- Add export: {"action": "add_export", "path": "res://scripts/player.gd", "name": "speed", "type": "float", "value": "200.0"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["add_function", "remove_function", "add_variable", "add_signal", "add_export", "get_functions", "get_variables"],
						"description": "Edit action"
					},
					"path": {
						"type": "string",
						"description": "Script file path"
					},
					"name": {
						"type": "string",
						"description": "Function/variable/signal name"
					},
					"type": {
						"type": "string",
						"description": "Variable type"
					},
					"value": {
						"type": "string",
						"description": "Default value"
					},
					"params": {
						"type": "array",
						"items": {"type": "string"},
						"description": "Function parameters"
					},
					"body": {
						"type": "string",
						"description": "Function body"
					},
					"return_type": {
						"type": "string",
						"description": "Function return type"
					}
				},
				"required": ["action", "path"]
			}
		},
		{
			"name": "open",
			"description": """SCRIPT EDITOR: Open scripts in Godot's script editor.

ACTIONS:
- open: Open script in editor
- open_at_line: Open script at specific line
- close: Close script in editor
- get_open_scripts: Get list of currently open scripts

EXAMPLES:
- Open script: {"action": "open", "path": "res://scripts/player.gd"}
- Open at line: {"action": "open_at_line", "path": "res://scripts/player.gd", "line": 42}
- Get open scripts: {"action": "get_open_scripts"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["open", "open_at_line", "close", "get_open_scripts"],
						"description": "Editor action"
					},
					"path": {
						"type": "string",
						"description": "Script file path"
					},
					"line": {
						"type": "integer",
						"description": "Line number for open_at_line"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"manage":
			return _execute_manage(args)
		"attach":
			return _execute_attach(args)
		"edit":
			return _execute_edit(args)
		"open":
			return _execute_open(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== MANAGE ====================

func _execute_manage(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	match action:
		"create":
			return _create_script(path, args.get("extends", "Node"), args.get("class_name", ""))
		"read":
			return _read_script(path)
		"write":
			return _write_script(path, args.get("content", ""))
		"get_info":
			return _get_script_info(path)
		"delete":
			return _delete_script(path)
		_:
			return _error("Unknown action: %s" % action)


func _create_script(path: String, extends_class: String, class_name_str: String) -> Dictionary:
	if FileAccess.file_exists(path):
		return _error("Script already exists: %s" % path)

	# Ensure directory exists
	var dir_path = path.get_base_dir()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir_path)):
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir_path))

	# Generate script template
	var content = ""

	if not class_name_str.is_empty():
		content += "class_name %s\n" % class_name_str

	content += "extends %s\n\n" % extends_class

	# Add common lifecycle methods based on base class
	match extends_class:
		"Node", "Node2D", "Node3D", "Control":
			content += "\nfunc _ready() -> void:\n\tpass\n"
			content += "\n\nfunc _process(delta: float) -> void:\n\tpass\n"
		"CharacterBody2D", "CharacterBody3D":
			content += "\nconst SPEED = 300.0\n"
			if extends_class == "CharacterBody2D":
				content += "const JUMP_VELOCITY = -400.0\n\n"
			else:
				content += "const JUMP_VELOCITY = 4.5\n\n"
			content += "\nfunc _physics_process(delta: float) -> void:\n\tpass\n"
		"RigidBody2D", "RigidBody3D":
			content += "\nfunc _ready() -> void:\n\tpass\n"
			content += "\n\nfunc _integrate_forces(state) -> void:\n\tpass\n"
		"Area2D", "Area3D":
			content += "\nfunc _ready() -> void:\n\tpass\n"
			content += "\n\nfunc _on_body_entered(body: Node) -> void:\n\tpass\n"
		"Resource":
			content += "\n# Add your resource properties here\n"
		_:
			content += "\nfunc _ready() -> void:\n\tpass\n"

	# Write file
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return _error("Failed to create script file")

	file.store_string(content)
	file.close()

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({
		"path": path,
		"extends": extends_class,
		"class_name": class_name_str
	}, "Script created: %s" % path)


func _read_script(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return _error("Script not found: %s" % path)

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return _error("Failed to read script")

	var content = file.get_as_text()
	file.close()

	return _success({
		"path": path,
		"content": content,
		"lines": content.split("\n").size()
	})


func _write_script(path: String, content: String) -> Dictionary:
	if content.is_empty():
		return _error("Content is required")

	# Ensure directory exists
	var dir_path = path.get_base_dir()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir_path)):
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir_path))

	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return _error("Failed to write script")

	file.store_string(content)
	file.close()

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({
		"path": path,
		"lines": content.split("\n").size()
	}, "Script written: %s" % path)


func _get_script_info(path: String) -> Dictionary:
	if not ResourceLoader.exists(path):
		return _error("Script not found: %s" % path)

	var script = load(path) as Script
	if not script:
		return _error("Failed to load script")

	var info = {
		"path": path,
		"type": str(script.get_class()),
		"base_type": str(script.get_instance_base_type()),
		"is_tool": script.is_tool() if script.has_method("is_tool") else false
	}

	# Get methods
	var methods: Array[String] = []
	for method in script.get_script_method_list():
		methods.append(str(method.name))
	info["methods"] = methods

	# Get properties
	var properties: Array[String] = []
	for prop in script.get_script_property_list():
		properties.append(str(prop.name))
	info["properties"] = properties

	# Get signals
	var signals: Array[String] = []
	for sig in script.get_script_signal_list():
		signals.append(str(sig.name))
	info["signals"] = signals

	return _success(info)


func _delete_script(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return _error("Script not found: %s" % path)

	var abs_path = ProjectSettings.globalize_path(path)
	var error = DirAccess.remove_absolute(abs_path)
	if error != OK:
		return _error("Failed to delete script: %s" % error_string(error))

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({"deleted": path}, "Script deleted")


# ==================== ATTACH ====================

func _execute_attach(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var node_path = args.get("node_path", "")

	if node_path.is_empty():
		return _error("Node path is required")

	match action:
		"attach":
			return _attach_script(node_path, args.get("script_path", ""))
		"detach":
			return _detach_script(node_path)
		"get_attached":
			return _get_attached_script(node_path)
		"create_and_attach":
			return _create_and_attach_script(node_path, args.get("script_path", ""), args.get("extends", ""))
		_:
			return _error("Unknown action: %s" % action)


func _attach_script(node_path: String, script_path: String) -> Dictionary:
	if script_path.is_empty():
		return _error("Script path is required")

	if not script_path.begins_with("res://"):
		script_path = "res://" + script_path

	var node = _find_node_by_path(node_path)
	if not node:
		return _error("Node not found: %s" % node_path)

	if not ResourceLoader.exists(script_path):
		return _error("Script not found: %s" % script_path)

	var script = load(script_path)
	if not script:
		return _error("Failed to load script")

	node.set_script(script)

	return _success({
		"node": node_path,
		"script": script_path
	}, "Script attached")


func _detach_script(node_path: String) -> Dictionary:
	var node = _find_node_by_path(node_path)
	if not node:
		return _error("Node not found: %s" % node_path)

	var script = node.get_script()
	if not script:
		return _error("Node has no script attached")

	node.set_script(null)

	return _success({
		"node": node_path,
		"detached": script.resource_path if script else ""
	}, "Script detached")


func _get_attached_script(node_path: String) -> Dictionary:
	var node = _find_node_by_path(node_path)
	if not node:
		return _error("Node not found: %s" % node_path)

	var script = node.get_script()
	if not script:
		return _success({
			"node": node_path,
			"has_script": false
		})

	return _success({
		"node": node_path,
		"has_script": true,
		"script_path": str(script.resource_path),
		"base_type": str(script.get_instance_base_type())
	})


func _create_and_attach_script(node_path: String, script_path: String, extends_class: String) -> Dictionary:
	if script_path.is_empty():
		return _error("Script path is required")

	var node = _find_node_by_path(node_path)
	if not node:
		return _error("Node not found: %s" % node_path)

	# Determine base class from node if not specified
	if extends_class.is_empty():
		extends_class = node.get_class()

	# Create the script
	var create_result = _create_script(script_path, extends_class, "")
	if not create_result.get("success", false):
		return create_result

	# Attach the script
	return _attach_script(node_path, script_path)


# ==================== EDIT ====================

func _execute_edit(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	match action:
		"add_function":
			return _add_function(path, args)
		"remove_function":
			return _remove_function(path, args.get("name", ""))
		"add_variable":
			return _add_variable(path, args)
		"add_signal":
			return _add_signal(path, args.get("name", ""), args.get("params", []))
		"add_export":
			return _add_export(path, args)
		"get_functions":
			return _get_functions(path)
		"get_variables":
			return _get_variables(path)
		_:
			return _error("Unknown action: %s" % action)


func _add_function(path: String, args: Dictionary) -> Dictionary:
	var name = args.get("name", "")
	if name.is_empty():
		return _error("Function name is required")

	var read_result = _read_script(path)
	if not read_result.get("success", false):
		return read_result

	var content = read_result.data.content as String

	# Build function signature
	var params_str = ", ".join(args.get("params", []))
	var return_type = args.get("return_type", "void")
	var body = args.get("body", "pass")

	var func_code = "\n\nfunc %s(%s) -> %s:\n" % [name, params_str, return_type]

	# Indent body
	for line in body.split("\n"):
		func_code += "\t%s\n" % line

	content += func_code

	return _write_script(path, content)


func _remove_function(path: String, name: String) -> Dictionary:
	if name.is_empty():
		return _error("Function name is required")

	var read_result = _read_script(path)
	if not read_result.get("success", false):
		return read_result

	var content = read_result.data.content as String
	var lines = content.split("\n")
	var new_lines: Array[String] = []
	var in_function = false
	var func_indent = 0

	for line in lines:
		var stripped = line.strip_edges()

		if stripped.begins_with("func %s" % name):
			in_function = true
			func_indent = line.length() - line.strip_edges(true, false).length()
			continue

		if in_function:
			# Check if we're still in the function
			var current_indent = line.length() - line.strip_edges(true, false).length()
			if not stripped.is_empty() and current_indent <= func_indent:
				in_function = false

		if not in_function:
			new_lines.append(line)

	return _write_script(path, "\n".join(new_lines))


func _add_variable(path: String, args: Dictionary) -> Dictionary:
	var name = args.get("name", "")
	if name.is_empty():
		return _error("Variable name is required")

	var read_result = _read_script(path)
	if not read_result.get("success", false):
		return read_result

	var content = read_result.data.content as String
	var lines = content.split("\n")

	# Find position after extends/class_name
	var insert_index = 0
	for i in lines.size():
		var line = lines[i].strip_edges()
		if line.begins_with("extends ") or line.begins_with("class_name "):
			insert_index = i + 1
		elif not line.is_empty() and not line.begins_with("#"):
			break

	# Build variable declaration
	var var_type = args.get("type", "")
	var value = args.get("value", "")
	var var_line = "var %s" % name

	if not var_type.is_empty():
		var_line += ": %s" % var_type

	if not value.is_empty():
		var_line += " = %s" % value

	lines.insert(insert_index, var_line)

	return _write_script(path, "\n".join(lines))


func _add_signal(path: String, name: String, params: Array) -> Dictionary:
	if name.is_empty():
		return _error("Signal name is required")

	var read_result = _read_script(path)
	if not read_result.get("success", false):
		return read_result

	var content = read_result.data.content as String
	var lines = content.split("\n")

	# Find position after extends/class_name
	var insert_index = 0
	for i in lines.size():
		var line = lines[i].strip_edges()
		if line.begins_with("extends ") or line.begins_with("class_name "):
			insert_index = i + 1
		elif not line.is_empty() and not line.begins_with("#") and not line.begins_with("signal "):
			break

	# Build signal declaration
	var signal_line = "signal %s" % name
	if not params.is_empty():
		signal_line += "(%s)" % ", ".join(params)

	lines.insert(insert_index, signal_line)

	return _write_script(path, "\n".join(lines))


func _add_export(path: String, args: Dictionary) -> Dictionary:
	var name = args.get("name", "")
	if name.is_empty():
		return _error("Export variable name is required")

	var read_result = _read_script(path)
	if not read_result.get("success", false):
		return read_result

	var content = read_result.data.content as String
	var lines = content.split("\n")

	# Find position after extends/class_name/signals
	var insert_index = 0
	for i in lines.size():
		var line = lines[i].strip_edges()
		if line.begins_with("extends ") or line.begins_with("class_name ") or line.begins_with("signal "):
			insert_index = i + 1
		elif not line.is_empty() and not line.begins_with("#"):
			break

	# Build export declaration
	var var_type = args.get("type", "")
	var value = args.get("value", "")

	var export_line = "@export var %s" % name

	if not var_type.is_empty():
		export_line += ": %s" % var_type

	if not value.is_empty():
		export_line += " = %s" % value

	lines.insert(insert_index, export_line)

	return _write_script(path, "\n".join(lines))


func _get_functions(path: String) -> Dictionary:
	var read_result = _read_script(path)
	if not read_result.get("success", false):
		return read_result

	var content = read_result.data.content as String
	var functions: Array[Dictionary] = []

	var regex = RegEx.new()
	regex.compile("func\\s+(\\w+)\\s*\\(([^)]*)\\)(?:\\s*->\\s*(\\w+))?:")

	for result in regex.search_all(content):
		functions.append({
			"name": str(result.get_string(1)),
			"params": str(result.get_string(2)),
			"return_type": str(result.get_string(3)) if result.get_string(3) else "void"
		})

	return _success({
		"path": path,
		"count": functions.size(),
		"functions": functions
	})


func _get_variables(path: String) -> Dictionary:
	var read_result = _read_script(path)
	if not read_result.get("success", false):
		return read_result

	var content = read_result.data.content as String
	var variables: Array[Dictionary] = []

	var regex = RegEx.new()
	regex.compile("(?:@export\\s+)?var\\s+(\\w+)(?:\\s*:\\s*(\\w+))?(?:\\s*=\\s*(.+))?")

	for result in regex.search_all(content):
		var var_info = {
			"name": str(result.get_string(1)),
			"exported": str(result.get_string(0)).begins_with("@export")
		}

		if result.get_string(2):
			var_info["type"] = str(result.get_string(2))
		if result.get_string(3):
			var_info["default"] = str(result.get_string(3)).strip_edges()

		variables.append(var_info)

	return _success({
		"path": path,
		"count": variables.size(),
		"variables": variables
	})


# ==================== OPEN ====================

func _execute_open(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"open":
			return _open_script(args.get("path", ""))
		"open_at_line":
			return _open_script_at_line(args.get("path", ""), args.get("line", 1))
		"get_open_scripts":
			return _get_open_scripts()
		_:
			return _error("Unknown action: %s" % action)


func _open_script(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	if not ResourceLoader.exists(path):
		return _error("Script not found: %s" % path)

	var script = load(path)
	if not script:
		return _error("Failed to load script")

	var ei = _get_editor_interface()
	if ei:
		ei.edit_script(script)

	return _success({"path": path}, "Script opened in editor")


func _open_script_at_line(path: String, line: int) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	if not ResourceLoader.exists(path):
		return _error("Script not found: %s" % path)

	var script = load(path)
	if not script:
		return _error("Failed to load script")

	var ei = _get_editor_interface()
	if ei:
		ei.edit_script(script, line)

	return _success({
		"path": path,
		"line": line
	}, "Script opened at line %d" % line)


func _get_open_scripts() -> Dictionary:
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	var script_editor = ei.get_script_editor()
	if not script_editor:
		return _error("Script editor not available")

	var open_scripts = script_editor.get_open_scripts()
	var scripts: Array[Dictionary] = []

	for script in open_scripts:
		scripts.append({
			"path": str(script.resource_path),
			"type": str(script.get_class())
		})

	return _success({
		"count": scripts.size(),
		"scripts": scripts
	})
