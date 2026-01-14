@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Editor control tools for Godot MCP
## Provides editor UI, theme, and preferences management


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "status",
			"description": """EDITOR STATUS: Get information about the current editor state.

ACTIONS:
- get_info: Get editor version and status info
- get_main_screen: Get currently active main screen (2D, 3D, Script, AssetLib)
- set_main_screen: Switch to a different main screen
- get_distraction_free: Get distraction-free mode status
- set_distraction_free: Toggle distraction-free mode

EXAMPLES:
- Get editor info: {"action": "get_info"}
- Get main screen: {"action": "get_main_screen"}
- Switch to 3D: {"action": "set_main_screen", "screen": "3D"}
- Toggle distraction-free: {"action": "set_distraction_free", "enabled": true}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_info", "get_main_screen", "set_main_screen", "get_distraction_free", "set_distraction_free"],
						"description": "Status action"
					},
					"screen": {
						"type": "string",
						"enum": ["2D", "3D", "Script", "AssetLib"],
						"description": "Main screen to switch to"
					},
					"enabled": {
						"type": "boolean",
						"description": "Enable/disable distraction-free mode"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "settings",
			"description": """EDITOR SETTINGS: Access and modify editor preferences.

ACTIONS:
- get: Get an editor setting
- set: Set an editor setting
- list_category: List settings in a category
- reset: Reset setting to default

COMMON SETTINGS:
- interface/theme/preset: Editor theme
- interface/editor/font_size: Font size
- text_editor/theme/highlighting/background_color: Script editor background
- filesystem/file_dialog/show_hidden_files: Show hidden files

EXAMPLES:
- Get font size: {"action": "get", "setting": "interface/editor/font_size"}
- Set font size: {"action": "set", "setting": "interface/editor/font_size", "value": 16}
- List interface settings: {"action": "list_category", "category": "interface"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get", "set", "list_category", "reset"],
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
			"name": "undo_redo",
			"description": """UNDO/REDO: Access the editor's undo/redo system with action tracking.

ACTIONS:
- get_info: Get current undo/redo state
- undo: Perform undo
- redo: Perform redo
- create_action: Start a new tracked action
- commit_action: Commit current action
- add_do_property: Add property change for do
- add_undo_property: Add property change for undo
- add_do_method: Add method call for do
- add_undo_method: Add method call for undo
- merge_mode: Get/set merge mode for actions

CONTEXTS:
- local: Scene-specific history (default)
- global: Editor-wide history

EXAMPLES:
- Get info: {"action": "get_info"}
- Create action: {"action": "create_action", "name": "Move Node", "context": "local"}
- Add do property: {"action": "add_do_property", "path": "/root/Player", "property": "position", "value": {"x": 100, "y": 200}}
- Commit: {"action": "commit_action"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_info", "undo", "redo", "create_action", "commit_action", "add_do_property", "add_undo_property", "add_do_method", "add_undo_method", "merge_mode"],
						"description": "Undo/redo action"
					},
					"name": {
						"type": "string",
						"description": "Action name for create_action"
					},
					"context": {
						"type": "string",
						"enum": ["local", "global"],
						"description": "Undo/redo context"
					},
					"path": {
						"type": "string",
						"description": "Node path for property/method"
					},
					"property": {
						"type": "string",
						"description": "Property name"
					},
					"value": {
						"description": "Property value"
					},
					"method": {
						"type": "string",
						"description": "Method name"
					},
					"args": {
						"type": "array",
						"description": "Method arguments"
					},
					"merge_mode": {
						"type": "string",
						"enum": ["disable", "ends", "all"],
						"description": "Merge mode for actions"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "notification",
			"description": """NOTIFICATIONS: Show notifications in the editor.

ACTIONS:
- toast: Show a toast notification
- popup: Show a popup dialog
- confirm: Show a confirmation dialog (non-blocking, returns immediately)

SEVERITY:
- info: Informational (blue)
- warning: Warning (yellow)
- error: Error (red)

EXAMPLES:
- Show toast: {"action": "toast", "message": "Build complete!", "severity": "info"}
- Show popup: {"action": "popup", "title": "Alert", "message": "Something happened"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["toast", "popup", "confirm"],
						"description": "Notification action"
					},
					"message": {
						"type": "string",
						"description": "Notification message"
					},
					"title": {
						"type": "string",
						"description": "Dialog title"
					},
					"severity": {
						"type": "string",
						"enum": ["info", "warning", "error"],
						"description": "Notification severity"
					}
				},
				"required": ["action", "message"]
			}
		},
		{
			"name": "inspector",
			"description": """INSPECTOR CONTROL: Control the editor inspector panel.

ACTIONS:
- edit_object: Edit a specific node/resource in inspector
- get_edited: Get currently edited object info
- refresh: Refresh the inspector
- get_selected_property: Get the currently selected property path
- inspect_resource: Inspect a resource file

EXAMPLES:
- Edit node: {"action": "edit_object", "path": "/root/Player"}
- Get edited: {"action": "get_edited"}
- Refresh: {"action": "refresh"}
- Inspect resource: {"action": "inspect_resource", "resource_path": "res://materials/metal.tres"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["edit_object", "get_edited", "refresh", "get_selected_property", "inspect_resource"],
						"description": "Inspector action"
					},
					"path": {
						"type": "string",
						"description": "Node path to edit"
					},
					"resource_path": {
						"type": "string",
						"description": "Resource path to inspect"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "filesystem",
			"description": """FILESYSTEM DOCK: Control the FileSystem dock.

ACTIONS:
- select_file: Select a file in the FileSystem dock
- get_selected: Get currently selected paths
- get_current_path: Get current directory path
- scan: Trigger filesystem scan
- reimport: Reimport specific files

EXAMPLES:
- Select file: {"action": "select_file", "path": "res://scenes/main.tscn"}
- Get selected: {"action": "get_selected"}
- Scan filesystem: {"action": "scan"}
- Reimport: {"action": "reimport", "paths": ["res://sprites/player.png"]}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["select_file", "get_selected", "get_current_path", "scan", "reimport"],
						"description": "Filesystem action"
					},
					"path": {
						"type": "string",
						"description": "File path to select"
					},
					"paths": {
						"type": "array",
						"items": {"type": "string"},
						"description": "File paths to reimport"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "plugin",
			"description": """PLUGIN MANAGEMENT: Enable/disable editor plugins.

ACTIONS:
- list: List all available plugins
- is_enabled: Check if a plugin is enabled
- enable: Enable a plugin
- disable: Disable a plugin

EXAMPLES:
- List plugins: {"action": "list"}
- Check status: {"action": "is_enabled", "plugin": "my_plugin"}
- Enable plugin: {"action": "enable", "plugin": "my_plugin"}
- Disable plugin: {"action": "disable", "plugin": "my_plugin"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "is_enabled", "enable", "disable"],
						"description": "Plugin action"
					},
					"plugin": {
						"type": "string",
						"description": "Plugin name (folder name in addons/)"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"status":
			return _execute_status(args)
		"settings":
			return _execute_settings(args)
		"undo_redo":
			return _execute_undo_redo(args)
		"notification":
			return _execute_notification(args)
		"inspector":
			return _execute_inspector(args)
		"filesystem":
			return _execute_filesystem(args)
		"plugin":
			return _execute_plugin(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== STATUS ====================

func _execute_status(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get_info":
			return _get_editor_info()
		"get_main_screen":
			return _get_main_screen()
		"set_main_screen":
			return _set_main_screen(args.get("screen", ""))
		"get_distraction_free":
			return _get_distraction_free()
		"set_distraction_free":
			return _set_distraction_free(args.get("enabled", false))
		_:
			return _error("Unknown action: %s" % action)


func _get_editor_info() -> Dictionary:
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	var version_info = Engine.get_version_info()

	return _success({
		"godot_version": "%d.%d.%d" % [int(version_info.get("major", 0)), int(version_info.get("minor", 0)), int(version_info.get("patch", 0))],
		"version_string": str(version_info.get("string", "")),
		"is_debug": OS.is_debug_build(),
		"os": str(OS.get_name()),
		"editor_scale": float(ei.get_editor_scale())
	})


func _get_main_screen() -> Dictionary:
	# Note: Getting the current main screen directly is limited
	# This provides what info we can
	return _success({
		"message": "Use set_main_screen to switch screens",
		"available": ["2D", "3D", "Script", "AssetLib"]
	})


func _set_main_screen(screen: String) -> Dictionary:
	if screen.is_empty():
		return _error("Screen is required")

	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	ei.set_main_screen_editor(screen)

	return _success({"screen": screen}, "Switched to %s editor" % screen)


func _get_distraction_free() -> Dictionary:
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	return _success({
		"enabled": ei.is_distraction_free_mode_enabled()
	})


func _set_distraction_free(enabled: bool) -> Dictionary:
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	ei.set_distraction_free_mode(enabled)

	return _success({"enabled": enabled}, "Distraction-free mode %s" % ("enabled" if enabled else "disabled"))


# ==================== SETTINGS ====================

func _execute_settings(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get":
			return _get_editor_setting(args.get("setting", ""))
		"set":
			return _set_editor_setting(args.get("setting", ""), args.get("value"))
		"list_category":
			return _list_editor_category(args.get("category", ""))
		"reset":
			return _reset_editor_setting(args.get("setting", ""))
		_:
			return _error("Unknown action: %s" % action)


func _get_editor_setting(setting: String) -> Dictionary:
	if setting.is_empty():
		return _error("Setting path is required")

	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	var editor_settings = ei.get_editor_settings()
	if not editor_settings:
		return _error("Editor settings not available")

	if not editor_settings.has_setting(setting):
		return _error("Setting not found: %s" % setting)

	return _success({
		"setting": setting,
		"value": editor_settings.get_setting(setting)
	})


func _set_editor_setting(setting: String, value) -> Dictionary:
	if setting.is_empty():
		return _error("Setting path is required")

	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	var editor_settings = ei.get_editor_settings()
	if not editor_settings:
		return _error("Editor settings not available")

	editor_settings.set_setting(setting, value)

	return _success({
		"setting": setting,
		"value": value
	}, "Editor setting updated")


func _list_editor_category(category: String) -> Dictionary:
	if category.is_empty():
		return _error("Category is required")

	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	var editor_settings = ei.get_editor_settings()
	if not editor_settings:
		return _error("Editor settings not available")

	var settings: Dictionary = {}
	var property_list = editor_settings.get_property_list()

	for prop in property_list:
		var prop_name = str(prop.name)
		if prop_name.begins_with(category + "/"):
			settings[prop_name] = editor_settings.get_setting(prop_name)

	return _success({
		"category": category,
		"count": settings.size(),
		"settings": settings
	})


func _reset_editor_setting(setting: String) -> Dictionary:
	if setting.is_empty():
		return _error("Setting path is required")

	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	var editor_settings = ei.get_editor_settings()
	if not editor_settings:
		return _error("Editor settings not available")

	if not editor_settings.has_setting(setting):
		return _error("Setting not found: %s" % setting)

	# Set to null to reset
	editor_settings.set_setting(setting, null)

	return _success({"setting": setting}, "Editor setting reset")


# ==================== UNDO/REDO ====================

# Track current action state for multi-step operations
var _current_action_name: String = ""
var _undo_redo_manager: EditorUndoRedoManager = null

func _execute_undo_redo(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get_info":
			return _get_undo_info()
		"undo":
			return _perform_undo()
		"redo":
			return _perform_redo()
		"create_action":
			return _create_undo_action(args)
		"commit_action":
			return _commit_undo_action()
		"add_do_property":
			return _add_do_property(args)
		"add_undo_property":
			return _add_undo_property(args)
		"add_do_method":
			return _add_do_method(args)
		"add_undo_method":
			return _add_undo_method(args)
		"merge_mode":
			return _handle_merge_mode(args)
		_:
			return _error("Unknown action: %s" % action)


func _get_undo_redo() -> EditorUndoRedoManager:
	if _undo_redo_manager:
		return _undo_redo_manager

	var ei = _get_editor_interface()
	if ei:
		_undo_redo_manager = ei.get_editor_undo_redo()

	return _undo_redo_manager


func _get_undo_info() -> Dictionary:
	var urm = _get_undo_redo()
	if not urm:
		return _error("EditorUndoRedoManager not available")

	return _success({
		"has_undo": urm.has_undo(),
		"has_redo": urm.has_redo(),
		"current_action": _current_action_name if not _current_action_name.is_empty() else null,
		"is_committing": urm.is_committing_action()
	})


func _perform_undo() -> Dictionary:
	var urm = _get_undo_redo()
	if not urm:
		return _error("EditorUndoRedoManager not available")

	if not urm.has_undo():
		return _error("Nothing to undo")

	# Get the undo_redo for the current context
	var scene_root = Engine.get_main_loop().get_edited_scene_root() if Engine.get_main_loop() else null
	if scene_root:
		var local_ur = urm.get_history_undo_redo(urm.get_object_history_id(scene_root))
		if local_ur and local_ur.has_undo():
			local_ur.undo()
			return _success({"action": "undo"}, "Undo performed")

	return _success({
		"note": "Use Ctrl+Z in the editor to undo, or Edit > Undo menu",
		"has_undo": urm.has_undo()
	}, "Undo available via editor")


func _perform_redo() -> Dictionary:
	var urm = _get_undo_redo()
	if not urm:
		return _error("EditorUndoRedoManager not available")

	if not urm.has_redo():
		return _error("Nothing to redo")

	# Get the undo_redo for the current context
	var scene_root = Engine.get_main_loop().get_edited_scene_root() if Engine.get_main_loop() else null
	if scene_root:
		var local_ur = urm.get_history_undo_redo(urm.get_object_history_id(scene_root))
		if local_ur and local_ur.has_redo():
			local_ur.redo()
			return _success({"action": "redo"}, "Redo performed")

	return _success({
		"note": "Use Ctrl+Y in the editor to redo, or Edit > Redo menu",
		"has_redo": urm.has_redo()
	}, "Redo available via editor")


func _create_undo_action(args: Dictionary) -> Dictionary:
	var action_name = args.get("name", "MCP Action")
	var context = args.get("context", "local")

	var urm = _get_undo_redo()
	if not urm:
		return _error("EditorUndoRedoManager not available")

	# Get the appropriate history context
	var merge_mode = UndoRedo.MERGE_DISABLE
	var merge_str = args.get("merge_mode", "disable")
	match merge_str:
		"ends":
			merge_mode = UndoRedo.MERGE_ENDS
		"all":
			merge_mode = UndoRedo.MERGE_ALL

	# Determine context object
	var context_obj = null
	if context == "local":
		var tree = Engine.get_main_loop() as SceneTree
		if tree:
			context_obj = tree.get_edited_scene_root()

	if context_obj:
		urm.create_action(action_name, merge_mode, context_obj)
	else:
		urm.create_action(action_name, merge_mode)

	_current_action_name = action_name

	return _success({
		"name": action_name,
		"context": context,
		"merge_mode": merge_str
	}, "Undo action created - add do/undo operations then commit")


func _commit_undo_action() -> Dictionary:
	var urm = _get_undo_redo()
	if not urm:
		return _error("EditorUndoRedoManager not available")

	if _current_action_name.is_empty():
		return _error("No action to commit. Create an action first.")

	urm.commit_action()
	var committed_name = _current_action_name
	_current_action_name = ""

	return _success({
		"name": committed_name
	}, "Undo action committed")


func _add_do_property(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var property = args.get("property", "")
	var value = args.get("value")

	if path.is_empty():
		return _error("Path is required")
	if property.is_empty():
		return _error("Property is required")

	var urm = _get_undo_redo()
	if not urm:
		return _error("EditorUndoRedoManager not available")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	# Convert value if needed
	var converted_value = _convert_value(value)

	urm.add_do_property(node, property, converted_value)

	return _success({
		"path": path,
		"property": property,
		"value": value
	}, "Do property added")


func _add_undo_property(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var property = args.get("property", "")
	var value = args.get("value")

	if path.is_empty():
		return _error("Path is required")
	if property.is_empty():
		return _error("Property is required")

	var urm = _get_undo_redo()
	if not urm:
		return _error("EditorUndoRedoManager not available")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	# If value not provided, use current value
	var undo_value = value
	if undo_value == null:
		undo_value = node.get(property)
	else:
		undo_value = _convert_value(undo_value)

	urm.add_undo_property(node, property, undo_value)

	return _success({
		"path": path,
		"property": property,
		"value": undo_value
	}, "Undo property added")


func _add_do_method(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var method = args.get("method", "")
	var method_args = args.get("args", [])

	if path.is_empty():
		return _error("Path is required")
	if method.is_empty():
		return _error("Method is required")

	var urm = _get_undo_redo()
	if not urm:
		return _error("EditorUndoRedoManager not available")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	# Build callable with args and add to undo/redo
	var callable = Callable(node, method)
	if method_args.size() > 0:
		callable = callable.bindv(method_args)

	# EditorUndoRedoManager requires object and method separately
	if method_args.size() == 0:
		urm.add_do_method(node, method)
	elif method_args.size() == 1:
		urm.add_do_method(node, method, method_args[0])
	elif method_args.size() == 2:
		urm.add_do_method(node, method, method_args[0], method_args[1])
	elif method_args.size() == 3:
		urm.add_do_method(node, method, method_args[0], method_args[1], method_args[2])
	else:
		urm.add_do_method(node, method, method_args[0], method_args[1], method_args[2], method_args[3])

	return _success({
		"path": path,
		"method": method,
		"args": method_args
	}, "Do method added")


func _add_undo_method(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var method = args.get("method", "")
	var method_args = args.get("args", [])

	if path.is_empty():
		return _error("Path is required")
	if method.is_empty():
		return _error("Method is required")

	var urm = _get_undo_redo()
	if not urm:
		return _error("EditorUndoRedoManager not available")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	# EditorUndoRedoManager requires object and method separately
	if method_args.size() == 0:
		urm.add_undo_method(node, method)
	elif method_args.size() == 1:
		urm.add_undo_method(node, method, method_args[0])
	elif method_args.size() == 2:
		urm.add_undo_method(node, method, method_args[0], method_args[1])
	elif method_args.size() == 3:
		urm.add_undo_method(node, method, method_args[0], method_args[1], method_args[2])
	else:
		urm.add_undo_method(node, method, method_args[0], method_args[1], method_args[2], method_args[3])

	return _success({
		"path": path,
		"method": method,
		"args": method_args
	}, "Undo method added")


func _handle_merge_mode(args: Dictionary) -> Dictionary:
	var mode = args.get("merge_mode", "")

	if mode.is_empty():
		return _success({
			"available_modes": ["disable", "ends", "all"],
			"descriptions": {
				"disable": "No merging, each action is separate",
				"ends": "Merge with previous action if same name",
				"all": "Merge all actions with same name"
			}
		})

	return _success({
		"merge_mode": mode,
		"note": "Set merge_mode when calling create_action"
	})


func _convert_value(value):
	"""Convert dictionary values to Godot types"""
	if value is Dictionary:
		if value.has("x") and value.has("y"):
			if value.has("z"):
				if value.has("w"):
					return Vector4(value.x, value.y, value.z, value.w)
				return Vector3(value.x, value.y, value.z)
			return Vector2(value.x, value.y)
		elif value.has("r") and value.has("g") and value.has("b"):
			return Color(value.r, value.g, value.b, value.get("a", 1.0))
	return value


# ==================== NOTIFICATION ====================

func _execute_notification(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var message = args.get("message", "")

	if message.is_empty():
		return _error("Message is required")

	match action:
		"toast":
			return _show_toast(message, args.get("severity", "info"))
		"popup":
			return _show_popup(args.get("title", ""), message)
		"confirm":
			return _show_confirm(args.get("title", ""), message)
		_:
			return _error("Unknown action: %s" % action)


func _show_toast(message: String, severity: String) -> Dictionary:
	var ei = _get_editor_interface()
	if not ei:
		# Fallback to print
		print("[Toast] %s: %s" % [severity, message])
		return _success({"method": "print"}, "Toast shown (via print)")

	# EditorToaster not directly accessible, use print as fallback
	match severity:
		"warning":
			push_warning(message)
		"error":
			push_error(message)
		_:
			print(message)

	return _success({
		"message": message,
		"severity": severity
	}, "Notification shown")


func _show_popup(title: String, message: String) -> Dictionary:
	# Create and show a simple popup
	# Note: This is limited in headless/plugin context
	print("[Popup] %s: %s" % [title, message])

	return _success({
		"title": title,
		"message": message
	}, "Popup shown (via console)")


func _show_confirm(title: String, message: String) -> Dictionary:
	# Confirmation dialogs need user interaction
	# Return info about what would be shown
	print("[Confirm] %s: %s" % [title, message])

	return _success({
		"title": title,
		"message": message,
		"note": "Confirmation dialogs require user interaction"
	}, "Confirmation logged")


# ==================== INSPECTOR ====================

func _execute_inspector(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	match action:
		"edit_object":
			return _edit_object(ei, args.get("path", ""))
		"get_edited":
			return _get_edited_object(ei)
		"refresh":
			return _refresh_inspector(ei)
		"get_selected_property":
			return _get_selected_property(ei)
		"inspect_resource":
			return _inspect_resource(ei, args.get("resource_path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _edit_object(ei: EditorInterface, path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	ei.edit_node(node)

	return _success({
		"path": path,
		"type": str(node.get_class())
	}, "Now editing: %s" % path)


func _get_edited_object(ei: EditorInterface) -> Dictionary:
	var inspector = ei.get_inspector()
	if not inspector:
		return _error("Inspector not available")

	var edited = inspector.get_edited_object()
	if not edited:
		return _success({"editing": null}, "No object being edited")

	var info = {
		"editing": true,
		"class": str(edited.get_class())
	}

	if edited is Node:
		info["path"] = _get_scene_path(edited)
		info["name"] = str(edited.name)
	elif edited is Resource:
		info["resource_path"] = str(edited.resource_path)

	return _success(info)


func _refresh_inspector(ei: EditorInterface) -> Dictionary:
	var inspector = ei.get_inspector()
	if not inspector:
		return _error("Inspector not available")

	# Trigger refresh by re-editing the current object
	var edited = inspector.get_edited_object()
	if edited:
		ei.inspect_object(edited)

	return _success(null, "Inspector refreshed")


func _get_selected_property(ei: EditorInterface) -> Dictionary:
	var inspector = ei.get_inspector()
	if not inspector:
		return _error("Inspector not available")

	var selected_path = inspector.get_selected_path()

	return _success({
		"selected_path": str(selected_path)
	})


func _inspect_resource(ei: EditorInterface, resource_path: String) -> Dictionary:
	if resource_path.is_empty():
		return _error("Resource path is required")

	if not resource_path.begins_with("res://"):
		resource_path = "res://" + resource_path

	if not ResourceLoader.exists(resource_path):
		return _error("Resource not found: %s" % resource_path)

	var resource = load(resource_path)
	if not resource:
		return _error("Failed to load resource: %s" % resource_path)

	ei.edit_resource(resource)

	return _success({
		"resource_path": resource_path,
		"type": str(resource.get_class())
	}, "Now inspecting resource")


# ==================== FILESYSTEM ====================

func _execute_filesystem(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	match action:
		"select_file":
			return _select_file(ei, args.get("path", ""))
		"get_selected":
			return _get_selected_files(ei)
		"get_current_path":
			return _get_current_filesystem_path(ei)
		"scan":
			return _scan_filesystem(ei)
		"reimport":
			return _reimport_files(ei, args.get("paths", []))
		_:
			return _error("Unknown action: %s" % action)


func _select_file(ei: EditorInterface, path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	ei.select_file(path)

	return _success({"path": path}, "File selected in FileSystem dock")


func _get_selected_files(ei: EditorInterface) -> Dictionary:
	var paths = ei.get_selected_paths()

	return _success({
		"count": paths.size(),
		"paths": Array(paths)
	})


func _get_current_filesystem_path(ei: EditorInterface) -> Dictionary:
	var current_path = ei.get_current_path()
	var current_dir = ei.get_current_directory()

	return _success({
		"current_path": str(current_path),
		"current_directory": str(current_dir)
	})


func _scan_filesystem(ei: EditorInterface) -> Dictionary:
	var fs = ei.get_resource_filesystem()
	if not fs:
		return _error("Filesystem not available")

	fs.scan()

	return _success(null, "Filesystem scan triggered")


func _reimport_files(ei: EditorInterface, paths: Array) -> Dictionary:
	if paths.is_empty():
		return _error("Paths are required")

	var fs = ei.get_resource_filesystem()
	if not fs:
		return _error("Filesystem not available")

	# Convert to PackedStringArray
	var packed_paths = PackedStringArray()
	for p in paths:
		if not p.begins_with("res://"):
			p = "res://" + p
		packed_paths.append(p)

	fs.reimport_files(packed_paths)

	return _success({
		"count": packed_paths.size(),
		"paths": Array(packed_paths)
	}, "Reimport triggered")


# ==================== PLUGIN ====================

func _execute_plugin(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var ei = _get_editor_interface()
	if not ei:
		return _error("Editor interface not available")

	match action:
		"list":
			return _list_plugins()
		"is_enabled":
			return _is_plugin_enabled(ei, args.get("plugin", ""))
		"enable":
			return _enable_plugin(ei, args.get("plugin", ""))
		"disable":
			return _disable_plugin(ei, args.get("plugin", ""))
		_:
			return _error("Unknown action: %s" % action)


func _list_plugins() -> Dictionary:
	# Scan addons directory for plugins
	var plugins: Array[Dictionary] = []
	var dir = DirAccess.open("res://addons")

	if dir:
		dir.list_dir_begin()
		var folder = dir.get_next()

		while not folder.is_empty():
			if dir.current_is_dir() and not folder.begins_with("."):
				var plugin_cfg = "res://addons/%s/plugin.cfg" % folder
				if FileAccess.file_exists(plugin_cfg):
					var cfg = ConfigFile.new()
					if cfg.load(plugin_cfg) == OK:
						plugins.append({
							"name": folder,
							"script": str(cfg.get_value("plugin", "script", "")),
							"description": str(cfg.get_value("plugin", "description", "")),
							"author": str(cfg.get_value("plugin", "author", "")),
							"version": str(cfg.get_value("plugin", "version", ""))
						})
			folder = dir.get_next()
		dir.list_dir_end()

	return _success({
		"count": plugins.size(),
		"plugins": plugins
	})


func _is_plugin_enabled(ei: EditorInterface, plugin_name: String) -> Dictionary:
	if plugin_name.is_empty():
		return _error("Plugin name is required")

	var enabled = ei.is_plugin_enabled(plugin_name)

	return _success({
		"plugin": plugin_name,
		"enabled": enabled
	})


func _enable_plugin(ei: EditorInterface, plugin_name: String) -> Dictionary:
	if plugin_name.is_empty():
		return _error("Plugin name is required")

	# Check if plugin exists
	var plugin_cfg = "res://addons/%s/plugin.cfg" % plugin_name
	if not FileAccess.file_exists(plugin_cfg):
		return _error("Plugin not found: %s" % plugin_name)

	ei.set_plugin_enabled(plugin_name, true)

	return _success({
		"plugin": plugin_name,
		"enabled": true
	}, "Plugin enabled")


func _disable_plugin(ei: EditorInterface, plugin_name: String) -> Dictionary:
	if plugin_name.is_empty():
		return _error("Plugin name is required")

	ei.set_plugin_enabled(plugin_name, false)

	return _success({
		"plugin": plugin_name,
		"enabled": false
	}, "Plugin disabled")
