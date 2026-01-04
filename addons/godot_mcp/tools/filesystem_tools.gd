@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## File system tools for Godot MCP
## Provides file and directory operations within the project


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "directory",
			"description": """DIRECTORY OPERATIONS: Manage directories in the project.

ACTIONS:
- list: List contents of a directory
- create: Create a new directory
- delete: Delete an empty directory
- exists: Check if directory exists
- get_files: Get all files in directory (with filters)

EXAMPLES:
- List directory: {"action": "list", "path": "res://scenes"}
- Create directory: {"action": "create", "path": "res://new_folder"}
- Get all .gd files: {"action": "get_files", "path": "res://scripts", "filter": "*.gd"}
- Check exists: {"action": "exists", "path": "res://assets"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "create", "delete", "exists", "get_files"],
						"description": "Directory action"
					},
					"path": {
						"type": "string",
						"description": "Directory path (res://...)"
					},
					"filter": {
						"type": "string",
						"description": "File filter pattern (e.g., *.gd, *.tscn)"
					},
					"recursive": {
						"type": "boolean",
						"description": "Include subdirectories"
					}
				},
				"required": ["action", "path"]
			}
		},
		{
			"name": "file",
			"description": """FILE OPERATIONS: Read and write files in the project.

ACTIONS:
- read: Read file contents
- write: Write content to file
- append: Append content to file
- delete: Delete a file
- exists: Check if file exists
- copy: Copy a file
- move: Move/rename a file
- get_info: Get file information

NOTE: For script files, prefer using script_manage tools.
For resources, prefer using resource_manage tools.

EXAMPLES:
- Read file: {"action": "read", "path": "res://data/config.json"}
- Write file: {"action": "write", "path": "res://data/save.json", "content": "{\\"level\\": 1}"}
- Copy file: {"action": "copy", "source": "res://template.txt", "dest": "res://copy.txt"}
- Get info: {"action": "get_info", "path": "res://project.godot"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["read", "write", "append", "delete", "exists", "copy", "move", "get_info"],
						"description": "File action"
					},
					"path": {
						"type": "string",
						"description": "File path"
					},
					"content": {
						"type": "string",
						"description": "Content to write/append"
					},
					"source": {
						"type": "string",
						"description": "Source path for copy/move"
					},
					"dest": {
						"type": "string",
						"description": "Destination path for copy/move"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "json",
			"description": """JSON OPERATIONS: Read and write JSON files.

ACTIONS:
- read: Read and parse JSON file
- write: Write data as JSON file
- get_value: Get a specific value from JSON file using path
- set_value: Set a specific value in JSON file

EXAMPLES:
- Read JSON: {"action": "read", "path": "res://data/config.json"}
- Write JSON: {"action": "write", "path": "res://data/settings.json", "data": {"volume": 0.8}}
- Get value: {"action": "get_value", "path": "res://data/config.json", "key": "player.health"}
- Set value: {"action": "set_value", "path": "res://data/config.json", "key": "player.health", "value": 100}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["read", "write", "get_value", "set_value"],
						"description": "JSON action"
					},
					"path": {
						"type": "string",
						"description": "JSON file path"
					},
					"data": {
						"description": "Data to write (for write action)"
					},
					"key": {
						"type": "string",
						"description": "Dot-separated path to value (e.g., 'player.health')"
					},
					"value": {
						"description": "Value to set"
					}
				},
				"required": ["action", "path"]
			}
		},
		{
			"name": "search",
			"description": """FILE SEARCH: Search for files and content in the project.

ACTIONS:
- find_files: Find files by name pattern
- grep: Search for text content in files
- find_and_replace: Find and replace text in files

EXAMPLES:
- Find files: {"action": "find_files", "pattern": "*.gd", "path": "res://"}
- Search content: {"action": "grep", "pattern": "func _ready", "path": "res://scripts"}
- Find and replace: {"action": "find_and_replace", "find": "old_name", "replace": "new_name", "path": "res://scripts", "filter": "*.gd"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["find_files", "grep", "find_and_replace"],
						"description": "Search action"
					},
					"pattern": {
						"type": "string",
						"description": "Search pattern"
					},
					"path": {
						"type": "string",
						"description": "Directory to search in"
					},
					"find": {
						"type": "string",
						"description": "Text to find (for find_and_replace)"
					},
					"replace": {
						"type": "string",
						"description": "Replacement text"
					},
					"filter": {
						"type": "string",
						"description": "File filter (e.g., *.gd)"
					},
					"recursive": {
						"type": "boolean",
						"description": "Search recursively"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"directory":
			return _execute_directory(args)
		"file":
			return _execute_file(args)
		"json":
			return _execute_json(args)
		"search":
			return _execute_search(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== DIRECTORY ====================

func _execute_directory(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://") and not path.begins_with("user://"):
		path = "res://" + path

	match action:
		"list":
			return _list_directory(path)
		"create":
			return _create_directory(path)
		"delete":
			return _delete_directory(path)
		"exists":
			return _directory_exists(path)
		"get_files":
			return _get_files(path, args.get("filter", "*"), args.get("recursive", false))
		_:
			return _error("Unknown action: %s" % action)


func _list_directory(path: String) -> Dictionary:
	var dir = DirAccess.open(path)
	if not dir:
		return _error("Cannot open directory: %s" % path)

	var files: Array[String] = []
	var dirs: Array[String] = []

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			if not file_name.begins_with("."):
				dirs.append(file_name)
		else:
			files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	files.sort()
	dirs.sort()

	return _success({
		"path": path,
		"directories": dirs,
		"files": files,
		"total_dirs": dirs.size(),
		"total_files": files.size()
	})


func _create_directory(path: String) -> Dictionary:
	var abs_path = ProjectSettings.globalize_path(path)
	var error = DirAccess.make_dir_recursive_absolute(abs_path)

	if error != OK:
		return _error("Failed to create directory: %s" % error_string(error))

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({"path": path}, "Directory created")


func _delete_directory(path: String) -> Dictionary:
	var abs_path = ProjectSettings.globalize_path(path)

	if not DirAccess.dir_exists_absolute(abs_path):
		return _error("Directory not found: %s" % path)

	var error = DirAccess.remove_absolute(abs_path)
	if error != OK:
		return _error("Failed to delete directory (must be empty): %s" % error_string(error))

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({"path": path}, "Directory deleted")


func _directory_exists(path: String) -> Dictionary:
	var abs_path = ProjectSettings.globalize_path(path)
	return _success({
		"path": path,
		"exists": DirAccess.dir_exists_absolute(abs_path)
	})


func _get_files(path: String, filter: String, recursive: bool) -> Dictionary:
	var files: Array[String] = []
	_collect_files(path, filter, recursive, files)

	return _success({
		"path": path,
		"filter": filter,
		"recursive": recursive,
		"count": files.size(),
		"files": files
	})


func _collect_files(path: String, filter: String, recursive: bool, results: Array[String]) -> void:
	var dir = DirAccess.open(path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = path.path_join(file_name)

		if dir.current_is_dir():
			if recursive and not file_name.begins_with("."):
				_collect_files(full_path, filter, recursive, results)
		else:
			if file_name.match(filter):
				results.append(full_path)

		file_name = dir.get_next()
	dir.list_dir_end()


# ==================== FILE ====================

func _execute_file(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"read":
			return _read_file(args.get("path", ""))
		"write":
			return _write_file(args.get("path", ""), args.get("content", ""))
		"append":
			return _append_file(args.get("path", ""), args.get("content", ""))
		"delete":
			return _delete_file(args.get("path", ""))
		"exists":
			return _file_exists(args.get("path", ""))
		"copy":
			return _copy_file(args.get("source", ""), args.get("dest", ""))
		"move":
			return _move_file(args.get("source", ""), args.get("dest", ""))
		"get_info":
			return _get_file_info(args.get("path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _read_file(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://") and not path.begins_with("user://"):
		path = "res://" + path

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return _error("Cannot read file: %s" % path)

	var content = file.get_as_text()
	file.close()

	return _success({
		"path": path,
		"content": content,
		"size": content.length()
	})


func _write_file(path: String, content: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://") and not path.begins_with("user://"):
		path = "res://" + path

	# Ensure directory exists
	var dir_path = path.get_base_dir()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir_path)):
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir_path))

	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return _error("Cannot write file: %s" % path)

	file.store_string(content)
	file.close()

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({
		"path": path,
		"size": content.length()
	}, "File written")


func _append_file(path: String, content: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://") and not path.begins_with("user://"):
		path = "res://" + path

	# Read existing content if file exists
	var existing = ""
	if FileAccess.file_exists(path):
		var read_file = FileAccess.open(path, FileAccess.READ)
		if read_file:
			existing = read_file.get_as_text()
			read_file.close()

	return _write_file(path, existing + content)


func _delete_file(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://") and not path.begins_with("user://"):
		path = "res://" + path

	var abs_path = ProjectSettings.globalize_path(path)

	if not FileAccess.file_exists(path):
		return _error("File not found: %s" % path)

	var error = DirAccess.remove_absolute(abs_path)
	if error != OK:
		return _error("Failed to delete file: %s" % error_string(error))

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({"path": path}, "File deleted")


func _file_exists(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://") and not path.begins_with("user://"):
		path = "res://" + path

	return _success({
		"path": path,
		"exists": FileAccess.file_exists(path)
	})


func _copy_file(source: String, dest: String) -> Dictionary:
	if source.is_empty() or dest.is_empty():
		return _error("Source and destination paths are required")

	if not source.begins_with("res://") and not source.begins_with("user://"):
		source = "res://" + source
	if not dest.begins_with("res://") and not dest.begins_with("user://"):
		dest = "res://" + dest

	var source_abs = ProjectSettings.globalize_path(source)
	var dest_abs = ProjectSettings.globalize_path(dest)

	if not FileAccess.file_exists(source):
		return _error("Source file not found: %s" % source)

	# Ensure destination directory exists
	var dest_dir = dest.get_base_dir()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dest_dir)):
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dest_dir))

	var error = DirAccess.copy_absolute(source_abs, dest_abs)
	if error != OK:
		return _error("Failed to copy file: %s" % error_string(error))

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({
		"source": source,
		"dest": dest
	}, "File copied")


func _move_file(source: String, dest: String) -> Dictionary:
	if source.is_empty() or dest.is_empty():
		return _error("Source and destination paths are required")

	if not source.begins_with("res://") and not source.begins_with("user://"):
		source = "res://" + source
	if not dest.begins_with("res://") and not dest.begins_with("user://"):
		dest = "res://" + dest

	var source_abs = ProjectSettings.globalize_path(source)
	var dest_abs = ProjectSettings.globalize_path(dest)

	if not FileAccess.file_exists(source):
		return _error("Source file not found: %s" % source)

	# Ensure destination directory exists
	var dest_dir = dest.get_base_dir()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dest_dir)):
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dest_dir))

	var error = DirAccess.rename_absolute(source_abs, dest_abs)
	if error != OK:
		return _error("Failed to move file: %s" % error_string(error))

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({
		"source": source,
		"dest": dest
	}, "File moved")


func _get_file_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://") and not path.begins_with("user://"):
		path = "res://" + path

	if not FileAccess.file_exists(path):
		return _error("File not found: %s" % path)

	var abs_path = ProjectSettings.globalize_path(path)

	return _success({
		"path": path,
		"name": path.get_file(),
		"extension": path.get_extension(),
		"directory": path.get_base_dir(),
		"modified_time": FileAccess.get_modified_time(path)
	})


# ==================== JSON ====================

func _execute_json(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://") and not path.begins_with("user://"):
		path = "res://" + path

	match action:
		"read":
			return _read_json(path)
		"write":
			return _write_json(path, args.get("data"))
		"get_value":
			return _get_json_value(path, args.get("key", ""))
		"set_value":
			return _set_json_value(path, args.get("key", ""), args.get("value"))
		_:
			return _error("Unknown action: %s" % action)


func _read_json(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return _error("Cannot read file: %s" % path)

	var content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		return _error("Invalid JSON: %s at line %d" % [json.get_error_message(), json.get_error_line()])

	return _success({
		"path": path,
		"data": json.get_data()
	})


func _write_json(path: String, data) -> Dictionary:
	if data == null:
		return _error("Data is required")

	var content = JSON.stringify(data, "\t")

	return _write_file(path, content)


func _get_json_value(path: String, key: String) -> Dictionary:
	if key.is_empty():
		return _error("Key is required")

	var read_result = _read_json(path)
	if not read_result.get("success", false):
		return read_result

	var data = read_result.data.data
	var keys = key.split(".")

	for k in keys:
		if data is Dictionary and data.has(k):
			data = data[k]
		elif data is Array and k.is_valid_int():
			var index = int(k)
			if index >= 0 and index < data.size():
				data = data[index]
			else:
				return _error("Array index out of bounds: %s" % key)
		else:
			return _error("Key not found: %s" % key)

	return _success({
		"path": path,
		"key": key,
		"value": data
	})


func _set_json_value(path: String, key: String, value) -> Dictionary:
	if key.is_empty():
		return _error("Key is required")

	# Read existing data or create new
	var data = {}
	if FileAccess.file_exists(path):
		var read_result = _read_json(path)
		if read_result.get("success", false):
			data = read_result.data.data
		if not data is Dictionary:
			data = {}

	# Set the value at the key path
	var keys = key.split(".")
	var current = data

	for i in keys.size() - 1:
		var k = keys[i]
		if not current.has(k) or not current[k] is Dictionary:
			current[k] = {}
		current = current[k]

	current[keys[-1]] = value

	return _write_json(path, data)


# ==================== SEARCH ====================

func _execute_search(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"find_files":
			return _find_files(args.get("pattern", "*"), args.get("path", "res://"), args.get("recursive", true))
		"grep":
			return _grep(args.get("pattern", ""), args.get("path", "res://"), args.get("filter", "*"), args.get("recursive", true))
		"find_and_replace":
			return _find_and_replace(args.get("find", ""), args.get("replace", ""), args.get("path", "res://"), args.get("filter", "*"), args.get("recursive", true))
		_:
			return _error("Unknown action: %s" % action)


func _find_files(pattern: String, path: String, recursive: bool) -> Dictionary:
	if not path.begins_with("res://"):
		path = "res://" + path

	var files: Array[String] = []
	_collect_files(path, pattern, recursive, files)

	return _success({
		"pattern": pattern,
		"path": path,
		"count": files.size(),
		"files": files
	})


func _grep(pattern: String, path: String, filter: String, recursive: bool) -> Dictionary:
	if pattern.is_empty():
		return _error("Pattern is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	var files: Array[String] = []
	_collect_files(path, filter, recursive, files)

	var matches: Array[Dictionary] = []
	var regex = RegEx.new()
	var regex_error = regex.compile(pattern)

	for file_path in files:
		var file = FileAccess.open(file_path, FileAccess.READ)
		if not file:
			continue

		var content = file.get_as_text()
		file.close()

		var lines = content.split("\n")
		for i in lines.size():
			var line = lines[i]
			if regex_error == OK:
				if regex.search(line):
					matches.append({
						"file": file_path,
						"line": i + 1,
						"content": line.strip_edges()
					})
			else:
				if line.contains(pattern):
					matches.append({
						"file": file_path,
						"line": i + 1,
						"content": line.strip_edges()
					})

	return _success({
		"pattern": pattern,
		"path": path,
		"count": matches.size(),
		"matches": matches
	})


func _find_and_replace(find: String, replace: String, path: String, filter: String, recursive: bool) -> Dictionary:
	if find.is_empty():
		return _error("Find pattern is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	var files: Array[String] = []
	_collect_files(path, filter, recursive, files)

	var modified_files: Array[String] = []
	var total_replacements = 0

	for file_path in files:
		var file = FileAccess.open(file_path, FileAccess.READ)
		if not file:
			continue

		var content = file.get_as_text()
		file.close()

		var new_content = content.replace(find, replace)
		if new_content != content:
			var write_file = FileAccess.open(file_path, FileAccess.WRITE)
			if write_file:
				write_file.store_string(new_content)
				write_file.close()
				modified_files.append(file_path)
				total_replacements += content.count(find)

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({
		"find": find,
		"replace": replace,
		"path": path,
		"files_modified": modified_files.size(),
		"total_replacements": total_replacements,
		"modified_files": modified_files
	})
