@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Project management tools for Godot MCP
## Provides project settings, export, and configuration management


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "info",
			"description": """PROJECT INFO: Get information about the current Godot project.

ACTIONS:
- get_info: Get basic project information
- get_settings: Get project settings
- get_features: Get enabled project features
- get_export_presets: Get configured export presets

EXAMPLES:
- Get project info: {"action": "get_info"}
- Get settings: {"action": "get_settings"}
- Get specific setting: {"action": "get_settings", "setting": "application/config/name"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_info", "get_settings", "get_features", "get_export_presets"],
						"description": "Info action"
					},
					"setting": {
						"type": "string",
						"description": "Specific setting path to retrieve"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "settings",
			"description": """PROJECT SETTINGS: Modify project settings.

ACTIONS:
- set: Set a project setting value
- reset: Reset setting to default
- list_category: List all settings in a category

COMMON SETTINGS:
- application/config/name: Project name
- application/config/description: Project description
- application/run/main_scene: Main scene path
- display/window/size/viewport_width: Window width
- display/window/size/viewport_height: Window height
- rendering/renderer/rendering_method: Renderer (forward_plus, mobile, gl_compatibility)
- physics/2d/default_gravity: 2D gravity
- physics/3d/default_gravity: 3D gravity

CATEGORIES:
- application
- display
- rendering
- physics
- input
- audio
- network
- debug

EXAMPLES:
- Set project name: {"action": "set", "setting": "application/config/name", "value": "My Game"}
- Set window size: {"action": "set", "setting": "display/window/size/viewport_width", "value": 1920}
- List display settings: {"action": "list_category", "category": "display"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["set", "reset", "list_category"],
						"description": "Settings action"
					},
					"setting": {
						"type": "string",
						"description": "Setting path"
					},
					"value": {
						"description": "New value for setting"
					},
					"category": {
						"type": "string",
						"description": "Category to list"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "input",
			"description": """INPUT MAP: Manage input actions and bindings.

ACTIONS:
- list_actions: List all input actions
- get_action: Get bindings for an action
- add_action: Add a new input action
- remove_action: Remove an input action
- add_binding: Add a binding to an action
- remove_binding: Remove a binding from an action

INPUT TYPES:
- key: Keyboard key (e.g., "A", "Space", "Enter", "Escape")
- mouse: Mouse button (e.g., "left", "right", "middle")
- joypad_button: Gamepad button (e.g., 0 for A/Cross)
- joypad_axis: Gamepad axis (e.g., 0 for left stick X)

EXAMPLES:
- List actions: {"action": "list_actions"}
- Add action: {"action": "add_action", "name": "jump"}
- Add key binding: {"action": "add_binding", "name": "jump", "type": "key", "key": "Space"}
- Add mouse binding: {"action": "add_binding", "name": "shoot", "type": "mouse", "button": "left"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list_actions", "get_action", "add_action", "remove_action", "add_binding", "remove_binding"],
						"description": "Input action"
					},
					"name": {
						"type": "string",
						"description": "Action name"
					},
					"type": {
						"type": "string",
						"enum": ["key", "mouse", "joypad_button", "joypad_axis"],
						"description": "Input type"
					},
					"key": {
						"type": "string",
						"description": "Key name for keyboard input"
					},
					"button": {
						"type": "string",
						"description": "Button for mouse/joypad"
					},
					"axis": {
						"type": "integer",
						"description": "Axis index for joypad"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "autoload",
			"description": """AUTOLOAD: Manage autoloaded scripts and scenes.

ACTIONS:
- list: List all autoloads
- add: Add a new autoload
- remove: Remove an autoload
- reorder: Change autoload order

EXAMPLES:
- List autoloads: {"action": "list"}
- Add autoload: {"action": "add", "name": "GameManager", "path": "res://scripts/game_manager.gd"}
- Remove autoload: {"action": "remove", "name": "GameManager"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "add", "remove", "reorder"],
						"description": "Autoload action"
					},
					"name": {
						"type": "string",
						"description": "Autoload name"
					},
					"path": {
						"type": "string",
						"description": "Script/scene path"
					},
					"index": {
						"type": "integer",
						"description": "New index for reorder"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"info":
			return _execute_info(args)
		"settings":
			return _execute_settings(args)
		"input":
			return _execute_input(args)
		"autoload":
			return _execute_autoload(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== INFO ====================

func _execute_info(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get_info":
			return _get_project_info()
		"get_settings":
			return _get_project_settings(args.get("setting", ""))
		"get_features":
			return _get_features()
		"get_export_presets":
			return _get_export_presets()
		_:
			return _error("Unknown action: %s" % action)


func _get_project_info() -> Dictionary:
	var version_info = Engine.get_version_info()
	var info = {
		"name": str(ProjectSettings.get_setting("application/config/name", "Untitled")),
		"description": str(ProjectSettings.get_setting("application/config/description", "")),
		"version": str(ProjectSettings.get_setting("application/config/version", "")),
		"main_scene": str(ProjectSettings.get_setting("application/run/main_scene", "")),
		"godot_version": "%d.%d.%d" % [version_info.get("major", 0), version_info.get("minor", 0), version_info.get("patch", 0)],
		"godot_version_string": str(version_info.get("string", "")),
		"project_path": ProjectSettings.globalize_path("res://"),
		"renderer": str(ProjectSettings.get_setting("rendering/renderer/rendering_method", "")),
		"window": {
			"width": int(ProjectSettings.get_setting("display/window/size/viewport_width", 1152)),
			"height": int(ProjectSettings.get_setting("display/window/size/viewport_height", 648)),
			"mode": int(ProjectSettings.get_setting("display/window/size/mode", 0)),
			"resizable": bool(ProjectSettings.get_setting("display/window/size/resizable", true))
		}
	}

	return _success(info)


func _get_project_settings(setting: String) -> Dictionary:
	if not setting.is_empty():
		if not ProjectSettings.has_setting(setting):
			return _error("Setting not found: %s" % setting)

		var value = ProjectSettings.get_setting(setting)
		# Convert to JSON-safe value
		if typeof(value) == TYPE_OBJECT:
			value = str(value)

		return _success({
			"setting": setting,
			"value": value
		})

	# Return common settings
	var settings = {}
	var common_settings = [
		"application/config/name",
		"application/config/description",
		"application/run/main_scene",
		"display/window/size/viewport_width",
		"display/window/size/viewport_height",
		"rendering/renderer/rendering_method",
		"physics/2d/default_gravity",
		"physics/3d/default_gravity"
	]

	for s in common_settings:
		if ProjectSettings.has_setting(s):
			settings[s] = ProjectSettings.get_setting(s)

	return _success({"settings": settings})


func _get_features() -> Dictionary:
	# Get project features
	var features: Array[String] = []

	# Check for common features
	if ProjectSettings.has_setting("application/config/features"):
		var f = ProjectSettings.get_setting("application/config/features")
		if f is PackedStringArray:
			for feature in f:
				features.append(feature)

	return _success({
		"features": features,
		"os": OS.get_name(),
		"debug": OS.is_debug_build()
	})


func _get_export_presets() -> Dictionary:
	# Export presets are in export_presets.cfg
	var presets: Array[Dictionary] = []

	var preset_path = "res://export_presets.cfg"
	if FileAccess.file_exists(preset_path):
		var config = ConfigFile.new()
		var err = config.load(preset_path)
		if err == OK:
			for section in config.get_sections():
				if section.begins_with("preset."):
					presets.append({
						"name": config.get_value(section, "name", ""),
						"platform": config.get_value(section, "platform", ""),
						"export_path": config.get_value(section, "export_path", "")
					})

	return _success({
		"count": presets.size(),
		"presets": presets
	})


# ==================== SETTINGS ====================

func _execute_settings(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"set":
			return _set_setting(args.get("setting", ""), args.get("value"))
		"reset":
			return _reset_setting(args.get("setting", ""))
		"list_category":
			return _list_category(args.get("category", ""))
		_:
			return _error("Unknown action: %s" % action)


func _set_setting(setting: String, value) -> Dictionary:
	if setting.is_empty():
		return _error("Setting path is required")

	ProjectSettings.set_setting(setting, value)
	var error = ProjectSettings.save()

	if error != OK:
		return _error("Failed to save project settings")

	return _success({
		"setting": setting,
		"value": value
	}, "Setting updated")


func _reset_setting(setting: String) -> Dictionary:
	if setting.is_empty():
		return _error("Setting path is required")

	if not ProjectSettings.has_setting(setting):
		return _error("Setting not found: %s" % setting)

	ProjectSettings.set_setting(setting, null)
	var error = ProjectSettings.save()

	if error != OK:
		return _error("Failed to save project settings")

	return _success({"setting": setting}, "Setting reset to default")


func _list_category(category: String) -> Dictionary:
	if category.is_empty():
		return _error("Category is required")

	var settings: Dictionary = {}
	var property_list = ProjectSettings.get_property_list()

	for prop in property_list:
		var prop_name = str(prop.name)
		if prop_name.begins_with(category + "/"):
			settings[prop_name] = ProjectSettings.get_setting(prop_name)

	return _success({
		"category": category,
		"count": settings.size(),
		"settings": settings
	})


# ==================== INPUT ====================

func _execute_input(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"list_actions":
			return _list_input_actions()
		"get_action":
			return _get_input_action(args.get("name", ""))
		"add_action":
			return _add_input_action(args.get("name", ""))
		"remove_action":
			return _remove_input_action(args.get("name", ""))
		"add_binding":
			return _add_input_binding(args)
		"remove_binding":
			return _remove_input_binding(args)
		_:
			return _error("Unknown action: %s" % action)


func _list_input_actions() -> Dictionary:
	var actions: Array[Dictionary] = []
	var property_list = ProjectSettings.get_property_list()

	for prop in property_list:
		var prop_name = str(prop.name)
		if prop_name.begins_with("input/"):
			var action_name = prop_name.substr(6)  # Remove "input/" prefix
			var action_data = ProjectSettings.get_setting(prop_name)

			if action_data is Dictionary:
				var events = action_data.get("events", [])
				actions.append({
					"name": action_name,
					"deadzone": action_data.get("deadzone", 0.5),
					"event_count": events.size()
				})

	return _success({
		"count": actions.size(),
		"actions": actions
	})


func _get_input_action(name: String) -> Dictionary:
	if name.is_empty():
		return _error("Action name is required")

	var setting_path = "input/" + name
	if not ProjectSettings.has_setting(setting_path):
		return _error("Action not found: %s" % name)

	var action_data = ProjectSettings.get_setting(setting_path)
	var events_info: Array[Dictionary] = []

	if action_data is Dictionary:
		var events = action_data.get("events", [])
		for event in events:
			events_info.append(_event_to_dict(event))

	return _success({
		"name": name,
		"deadzone": action_data.get("deadzone", 0.5) if action_data is Dictionary else 0.5,
		"events": events_info
	})


func _add_input_action(name: String) -> Dictionary:
	if name.is_empty():
		return _error("Action name is required")

	var setting_path = "input/" + name
	if ProjectSettings.has_setting(setting_path):
		return _error("Action already exists: %s" % name)

	ProjectSettings.set_setting(setting_path, {
		"deadzone": 0.5,
		"events": []
	})

	var error = ProjectSettings.save()
	if error != OK:
		return _error("Failed to save project settings")

	return _success({"name": name}, "Input action added")


func _remove_input_action(name: String) -> Dictionary:
	if name.is_empty():
		return _error("Action name is required")

	var setting_path = "input/" + name
	if not ProjectSettings.has_setting(setting_path):
		return _error("Action not found: %s" % name)

	ProjectSettings.set_setting(setting_path, null)

	var error = ProjectSettings.save()
	if error != OK:
		return _error("Failed to save project settings")

	return _success({"name": name}, "Input action removed")


func _add_input_binding(args: Dictionary) -> Dictionary:
	var name = args.get("name", "")
	var type = args.get("type", "")

	if name.is_empty():
		return _error("Action name is required")
	if type.is_empty():
		return _error("Input type is required")

	var setting_path = "input/" + name
	if not ProjectSettings.has_setting(setting_path):
		return _error("Action not found: %s" % name)

	var action_data = ProjectSettings.get_setting(setting_path)
	if not action_data is Dictionary:
		action_data = {"deadzone": 0.5, "events": []}

	var events = action_data.get("events", [])
	var new_event: InputEvent

	match type:
		"key":
			new_event = InputEventKey.new()
			var key_string = args.get("key", "")
			if key_string.is_empty():
				return _error("Key is required for keyboard input")
			new_event.keycode = OS.find_keycode_from_string(key_string)
		"mouse":
			new_event = InputEventMouseButton.new()
			var button = args.get("button", "left")
			match button:
				"left":
					new_event.button_index = MOUSE_BUTTON_LEFT
				"right":
					new_event.button_index = MOUSE_BUTTON_RIGHT
				"middle":
					new_event.button_index = MOUSE_BUTTON_MIDDLE
		"joypad_button":
			new_event = InputEventJoypadButton.new()
			new_event.button_index = args.get("button", 0)
		"joypad_axis":
			new_event = InputEventJoypadMotion.new()
			new_event.axis = args.get("axis", 0)
			new_event.axis_value = args.get("axis_value", 1.0)
		_:
			return _error("Unknown input type: %s" % type)

	events.append(new_event)
	action_data["events"] = events
	ProjectSettings.set_setting(setting_path, action_data)

	var error = ProjectSettings.save()
	if error != OK:
		return _error("Failed to save project settings")

	return _success({
		"name": name,
		"type": type,
		"event_count": events.size()
	}, "Input binding added")


func _remove_input_binding(args: Dictionary) -> Dictionary:
	var name = args.get("name", "")
	var index = args.get("index", -1)

	if name.is_empty():
		return _error("Action name is required")
	if index < 0:
		return _error("Binding index is required")

	var setting_path = "input/" + name
	if not ProjectSettings.has_setting(setting_path):
		return _error("Action not found: %s" % name)

	var action_data = ProjectSettings.get_setting(setting_path)
	if not action_data is Dictionary:
		return _error("Invalid action data")

	var events = action_data.get("events", [])
	if index >= events.size():
		return _error("Binding index out of range")

	events.remove_at(index)
	action_data["events"] = events
	ProjectSettings.set_setting(setting_path, action_data)

	var error = ProjectSettings.save()
	if error != OK:
		return _error("Failed to save project settings")

	return _success({
		"name": name,
		"removed_index": index
	}, "Input binding removed")


func _event_to_dict(event: InputEvent) -> Dictionary:
	var result = {"type": str(event.get_class())}

	if event is InputEventKey:
		result["keycode"] = event.keycode
		result["key_name"] = str(OS.get_keycode_string(event.keycode))
	elif event is InputEventMouseButton:
		result["button"] = event.button_index
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				result["button_name"] = "left"
			MOUSE_BUTTON_RIGHT:
				result["button_name"] = "right"
			MOUSE_BUTTON_MIDDLE:
				result["button_name"] = "middle"
	elif event is InputEventJoypadButton:
		result["button"] = event.button_index
	elif event is InputEventJoypadMotion:
		result["axis"] = event.axis
		result["axis_value"] = event.axis_value

	return result


# ==================== AUTOLOAD ====================

func _execute_autoload(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"list":
			return _list_autoloads()
		"add":
			return _add_autoload(args.get("name", ""), args.get("path", ""))
		"remove":
			return _remove_autoload(args.get("name", ""))
		_:
			return _error("Unknown action: %s" % action)


func _list_autoloads() -> Dictionary:
	var autoloads: Array[Dictionary] = []
	var property_list = ProjectSettings.get_property_list()

	for prop in property_list:
		var prop_name = str(prop.name)
		if prop_name.begins_with("autoload/"):
			var autoload_name = prop_name.substr(9)  # Remove "autoload/" prefix
			var path_value = str(ProjectSettings.get_setting(prop_name))
			# Path format is "*res://..." where * means singleton
			var is_singleton = path_value.begins_with("*")
			if is_singleton:
				path_value = path_value.substr(1)

			autoloads.append({
				"name": autoload_name,
				"path": path_value,
				"singleton": is_singleton
			})

	return _success({
		"count": autoloads.size(),
		"autoloads": autoloads
	})


func _add_autoload(name: String, path: String) -> Dictionary:
	if name.is_empty():
		return _error("Autoload name is required")
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	var setting_path = "autoload/" + name
	if ProjectSettings.has_setting(setting_path):
		return _error("Autoload already exists: %s" % name)

	# Add with singleton prefix
	ProjectSettings.set_setting(setting_path, "*" + path)

	var error = ProjectSettings.save()
	if error != OK:
		return _error("Failed to save project settings")

	return _success({
		"name": name,
		"path": path
	}, "Autoload added")


func _remove_autoload(name: String) -> Dictionary:
	if name.is_empty():
		return _error("Autoload name is required")

	var setting_path = "autoload/" + name
	if not ProjectSettings.has_setting(setting_path):
		return _error("Autoload not found: %s" % name)

	ProjectSettings.set_setting(setting_path, null)

	var error = ProjectSettings.save()
	if error != OK:
		return _error("Failed to save project settings")

	return _success({"name": name}, "Autoload removed")
