@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Resource and asset management tools for Godot MCP
## Provides resource loading, querying, and management


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "query",
			"description": """RESOURCE QUERY: Search and list resources in the project.

ACTIONS:
- list: List resources by type or in directory
- search: Search for resources by name pattern
- get_info: Get detailed information about a resource
- get_dependencies: Get resource dependencies

RESOURCE TYPES:
- PackedScene (.tscn, .scn): Scene files
- Script (.gd): GDScript files
- Texture2D (.png, .jpg, .svg): Images
- AudioStream (.wav, .ogg, .mp3): Audio files
- Material (.material, .tres): Materials
- Shader (.gdshader): Shader files
- Font (.ttf, .otf): Font files
- Animation (.anim): Animation files

EXAMPLES:
- List all scenes: {"action": "list", "type": "PackedScene"}
- List in directory: {"action": "list", "path": "res://scenes"}
- Search textures: {"action": "search", "pattern": "*player*", "type": "Texture2D"}
- Get resource info: {"action": "get_info", "path": "res://sprites/player.png"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "search", "get_info", "get_dependencies"],
						"description": "Query action"
					},
					"type": {
						"type": "string",
						"description": "Resource type filter"
					},
					"path": {
						"type": "string",
						"description": "Directory path or resource path"
					},
					"pattern": {
						"type": "string",
						"description": "Search pattern (supports * wildcard)"
					},
					"recursive": {
						"type": "boolean",
						"description": "Search subdirectories (default: true)"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "manage",
			"description": """RESOURCE MANAGEMENT: Create, import, and manage resources.

ACTIONS:
- create: Create a new resource
- import: Import external file as resource
- copy: Copy a resource
- move: Move/rename a resource
- delete: Delete a resource
- reload: Reload a resource from disk

RESOURCE CREATION:
- Resource: Generic resource
- GDScript: Create new script
- StyleBox: UI style
- Environment: 3D environment
- Material: Create material resource

EXAMPLES:
- Create script: {"action": "create", "type": "GDScript", "path": "res://scripts/player.gd"}
- Copy resource: {"action": "copy", "source": "res://sprites/enemy.png", "dest": "res://sprites/boss.png"}
- Move resource: {"action": "move", "source": "res://old/file.gd", "dest": "res://new/file.gd"}
- Delete: {"action": "delete", "path": "res://unused/old.tscn"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "import", "copy", "move", "delete", "reload"],
						"description": "Management action"
					},
					"type": {
						"type": "string",
						"description": "Resource type to create"
					},
					"path": {
						"type": "string",
						"description": "Resource path"
					},
					"source": {
						"type": "string",
						"description": "Source path for copy/move"
					},
					"dest": {
						"type": "string",
						"description": "Destination path"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "texture",
			"description": """TEXTURE OPERATIONS: Manage texture resources.

ACTIONS:
- get_info: Get texture information (size, format, etc.)
- list_all: List all textures in project
- assign_to_node: Assign texture to a node's property

EXAMPLES:
- Get texture info: {"action": "get_info", "path": "res://sprites/player.png"}
- List textures: {"action": "list_all"}
- Assign to Sprite2D: {"action": "assign_to_node", "texture_path": "res://sprites/player.png", "node_path": "/root/Player/Sprite2D", "property": "texture"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_info", "list_all", "assign_to_node"],
						"description": "Texture action"
					},
					"path": {
						"type": "string",
						"description": "Texture path"
					},
					"texture_path": {
						"type": "string",
						"description": "Texture resource path"
					},
					"node_path": {
						"type": "string",
						"description": "Target node path"
					},
					"property": {
						"type": "string",
						"description": "Property name"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"query":
			return _execute_query(args)
		"manage":
			return _execute_manage(args)
		"texture":
			return _execute_texture(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== QUERY ====================

func _execute_query(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"list":
			return _list_resources(args.get("path", "res://"), args.get("type", ""), args.get("recursive", true))
		"search":
			return _search_resources(args.get("pattern", ""), args.get("type", ""), args.get("recursive", true))
		"get_info":
			return _get_resource_info(args.get("path", ""))
		"get_dependencies":
			return _get_dependencies(args.get("path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _list_resources(path: String, type_filter: String, recursive: bool) -> Dictionary:
	if not path.begins_with("res://"):
		path = "res://" + path

	var fs = _get_filesystem()
	if not fs:
		return _error("File system not available")

	var dir = fs.get_filesystem_path(path)
	if not dir:
		return _error("Directory not found: %s" % path)

	var resources: Array[Dictionary] = []
	_collect_resources(dir, type_filter, recursive, resources)

	return _success({
		"path": path,
		"count": resources.size(),
		"resources": resources
	})


func _collect_resources(dir: EditorFileSystemDirectory, type_filter: String, recursive: bool, results: Array[Dictionary]) -> void:
	# Collect files
	for i in dir.get_file_count():
		var file_type = str(dir.get_file_type(i))
		var file_path = str(dir.get_file_path(i))

		if type_filter.is_empty() or file_type == type_filter:
			results.append({
				"path": file_path,
				"type": file_type,
				"name": str(dir.get_file(i))
			})

	# Recurse into subdirectories
	if recursive:
		for i in dir.get_subdir_count():
			_collect_resources(dir.get_subdir(i), type_filter, recursive, results)


func _search_resources(pattern: String, type_filter: String, recursive: bool) -> Dictionary:
	if pattern.is_empty():
		return _error("Pattern is required")

	var fs = _get_filesystem()
	if not fs:
		return _error("File system not available")

	var root = fs.get_filesystem()
	var resources: Array[Dictionary] = []
	_search_resources_recursive(root, pattern, type_filter, recursive, resources)

	return _success({
		"pattern": pattern,
		"count": resources.size(),
		"resources": resources
	})


func _search_resources_recursive(dir: EditorFileSystemDirectory, pattern: String, type_filter: String, recursive: bool, results: Array[Dictionary]) -> void:
	for i in dir.get_file_count():
		var file_name = str(dir.get_file(i))
		var file_type = str(dir.get_file_type(i))
		var file_path = str(dir.get_file_path(i))

		var matches_pattern = file_name.match(pattern) or file_name.contains(pattern.replace("*", ""))
		var matches_type = type_filter.is_empty() or file_type == type_filter

		if matches_pattern and matches_type:
			results.append({
				"path": file_path,
				"type": file_type,
				"name": file_name
			})

	if recursive:
		for i in dir.get_subdir_count():
			_search_resources_recursive(dir.get_subdir(i), pattern, type_filter, recursive, results)


func _get_resource_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	if not ResourceLoader.exists(path):
		return _error("Resource not found: %s" % path)

	var resource = load(path)
	if not resource:
		return _error("Failed to load resource: %s" % path)

	var info = {
		"path": path,
		"type": str(resource.get_class()),
		"name": str(path.get_file()),
		"extension": str(path.get_extension())
	}

	# Add type-specific info
	if resource is Texture2D:
		info["width"] = resource.get_width()
		info["height"] = resource.get_height()
		# Get format from image if available
		var image = resource.get_image() if resource.has_method("get_image") else null
		if image:
			info["format"] = image.get_format()
		else:
			info["format"] = "compressed"
	elif resource is AudioStream:
		info["length"] = resource.get_length() if resource.has_method("get_length") else 0
	elif resource is PackedScene:
		var state = resource.get_state()
		info["node_count"] = state.get_node_count()
	elif resource is Script:
		info["base_type"] = str(resource.get_instance_base_type())
		info["is_tool"] = resource.is_tool() if resource.has_method("is_tool") else false

	return _success(info)


func _get_dependencies(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	var dependencies = ResourceLoader.get_dependencies(path)
	var deps: Array[String] = []
	for dep in dependencies:
		deps.append(str(dep))

	return _success({
		"path": path,
		"count": deps.size(),
		"dependencies": deps
	})


# ==================== MANAGE ====================

func _execute_manage(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_resource(args.get("type", ""), args.get("path", ""))
		"copy":
			return _copy_resource(args.get("source", ""), args.get("dest", ""))
		"move":
			return _move_resource(args.get("source", ""), args.get("dest", ""))
		"delete":
			return _delete_resource(args.get("path", ""))
		"reload":
			return _reload_resource(args.get("path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _create_resource(type_name: String, path: String) -> Dictionary:
	if type_name.is_empty():
		return _error("Type is required")
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	var resource: Resource

	match type_name:
		"GDScript":
			resource = GDScript.new()
			resource.source_code = "extends Node\n\n\nfunc _ready() -> void:\n\tpass\n"
		"Resource":
			resource = Resource.new()
		"Environment":
			resource = Environment.new()
		"StandardMaterial3D":
			resource = StandardMaterial3D.new()
		"ShaderMaterial":
			resource = ShaderMaterial.new()
		"StyleBoxFlat":
			resource = StyleBoxFlat.new()
		"Gradient":
			resource = Gradient.new()
		"Curve":
			resource = Curve.new()
		_:
			# Try to create by class name
			if ClassDB.class_exists(type_name) and ClassDB.is_parent_class(type_name, "Resource"):
				resource = ClassDB.instantiate(type_name)
			else:
				return _error("Unknown resource type: %s" % type_name)

	if not resource:
		return _error("Failed to create resource of type: %s" % type_name)

	# Ensure directory exists
	var dir_path = path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)

	var error = ResourceSaver.save(resource, path)
	if error != OK:
		return _error("Failed to save resource: %s" % error_string(error))

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({
		"path": path,
		"type": type_name
	}, "Resource created: %s" % path)


func _copy_resource(source: String, dest: String) -> Dictionary:
	if source.is_empty():
		return _error("Source path is required")
	if dest.is_empty():
		return _error("Destination path is required")

	if not source.begins_with("res://"):
		source = "res://" + source
	if not dest.begins_with("res://"):
		dest = "res://" + dest

	var source_abs = ProjectSettings.globalize_path(source)
	var dest_abs = ProjectSettings.globalize_path(dest)

	if not FileAccess.file_exists(source):
		return _error("Source not found: %s" % source)

	# Ensure destination directory exists
	var dest_dir = dest.get_base_dir()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dest_dir)):
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dest_dir))

	var error = DirAccess.copy_absolute(source_abs, dest_abs)
	if error != OK:
		return _error("Failed to copy resource: %s" % error_string(error))

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({
		"source": source,
		"dest": dest
	}, "Resource copied")


func _move_resource(source: String, dest: String) -> Dictionary:
	if source.is_empty():
		return _error("Source path is required")
	if dest.is_empty():
		return _error("Destination path is required")

	if not source.begins_with("res://"):
		source = "res://" + source
	if not dest.begins_with("res://"):
		dest = "res://" + dest

	var source_abs = ProjectSettings.globalize_path(source)
	var dest_abs = ProjectSettings.globalize_path(dest)

	if not FileAccess.file_exists(source):
		return _error("Source not found: %s" % source)

	# Ensure destination directory exists
	var dest_dir = dest.get_base_dir()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dest_dir)):
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dest_dir))

	var error = DirAccess.rename_absolute(source_abs, dest_abs)
	if error != OK:
		return _error("Failed to move resource: %s" % error_string(error))

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({
		"source": source,
		"dest": dest
	}, "Resource moved")


func _delete_resource(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	var abs_path = ProjectSettings.globalize_path(path)

	if not FileAccess.file_exists(path):
		return _error("Resource not found: %s" % path)

	var error = DirAccess.remove_absolute(abs_path)
	if error != OK:
		return _error("Failed to delete resource: %s" % error_string(error))

	# Also delete .import file if exists
	var import_path = abs_path + ".import"
	if FileAccess.file_exists(import_path):
		DirAccess.remove_absolute(import_path)

	# Refresh filesystem
	var fs = _get_filesystem()
	if fs:
		fs.scan()

	return _success({"deleted": path}, "Resource deleted")


func _reload_resource(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	if not ResourceLoader.exists(path):
		return _error("Resource not found: %s" % path)

	# Force reload
	var resource = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
	if not resource:
		return _error("Failed to reload resource: %s" % path)

	return _success({
		"path": path,
		"type": str(resource.get_class())
	}, "Resource reloaded")


# ==================== TEXTURE ====================

func _execute_texture(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get_info":
			return _get_texture_info(args.get("path", ""))
		"list_all":
			return _list_all_textures()
		"assign_to_node":
			return _assign_texture_to_node(args.get("texture_path", ""), args.get("node_path", ""), args.get("property", "texture"))
		_:
			return _error("Unknown action: %s" % action)


func _get_texture_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	if not ResourceLoader.exists(path):
		return _error("Texture not found: %s" % path)

	var texture = load(path) as Texture2D
	if not texture:
		return _error("Not a valid texture: %s" % path)

	var format_info = "compressed"
	var has_alpha = false
	var image = texture.get_image() if texture.has_method("get_image") else null
	if image:
		format_info = image.get_format()
		has_alpha = format_info in [Image.FORMAT_RGBA8, Image.FORMAT_RGBA4444]

	return _success({
		"path": path,
		"width": texture.get_width(),
		"height": texture.get_height(),
		"format": format_info,
		"has_alpha": has_alpha
	})


func _list_all_textures() -> Dictionary:
	return _list_resources("res://", "Texture2D", true)


func _assign_texture_to_node(texture_path: String, node_path: String, property: String) -> Dictionary:
	if texture_path.is_empty():
		return _error("Texture path is required")
	if node_path.is_empty():
		return _error("Node path is required")

	if not texture_path.begins_with("res://"):
		texture_path = "res://" + texture_path

	var texture = load(texture_path) as Texture2D
	if not texture:
		return _error("Failed to load texture: %s" % texture_path)

	var node = _find_node_by_path(node_path)
	if not node:
		return _error("Node not found: %s" % node_path)

	if not property in node:
		return _error("Property '%s' not found on node" % property)

	node.set(property, texture)

	return _success({
		"node": node_path,
		"property": property,
		"texture": texture_path
	}, "Texture assigned")
