@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## UI and Theme tools for Godot MCP
## Provides Theme creation/editing and Control node manipulation


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "theme",
			"description": """THEME OPERATIONS: Create and manage UI themes.

ACTIONS:
- create: Create a new Theme resource
- get_info: Get theme information
- set_color: Set a color in the theme
- get_color: Get a color from the theme
- set_constant: Set a constant (integer) value
- get_constant: Get a constant value
- set_font: Set a font
- set_font_size: Set font size
- set_stylebox: Create and set a StyleBox
- clear_item: Clear a theme item
- copy_default: Copy items from default theme
- assign_to_node: Assign theme to a Control node

THEME ITEM TYPES:
- colors: Color values
- constants: Integer values (margins, spacing, etc.)
- fonts: Font resources
- font_sizes: Integer font sizes
- icons: Texture2D resources
- styleboxes: StyleBox resources

EXAMPLES:
- Create theme: {"action": "create", "save_path": "res://themes/custom.tres"}
- Set color: {"action": "set_color", "path": "res://themes/custom.tres", "name": "font_color", "type": "Button", "color": {"r": 1, "g": 1, "b": 1, "a": 1}}
- Set constant: {"action": "set_constant", "path": "res://themes/custom.tres", "name": "margin_left", "type": "Button", "value": 10}
- Assign to node: {"action": "assign_to_node", "theme_path": "res://themes/custom.tres", "node_path": "/root/UI"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_color", "get_color", "set_constant", "get_constant", "set_font", "set_font_size", "set_stylebox", "clear_item", "copy_default", "assign_to_node"],
						"description": "Theme action"
					},
					"path": {
						"type": "string",
						"description": "Theme resource path"
					},
					"theme_path": {
						"type": "string",
						"description": "Theme to assign"
					},
					"node_path": {
						"type": "string",
						"description": "Control node path"
					},
					"save_path": {
						"type": "string",
						"description": "Path to save theme"
					},
					"name": {
						"type": "string",
						"description": "Theme item name"
					},
					"type": {
						"type": "string",
						"description": "Control type (Button, Label, etc.)"
					},
					"color": {
						"type": "object",
						"description": "Color value {r, g, b, a}"
					},
					"value": {
						"description": "Value for constants/font_sizes"
					},
					"font_path": {
						"type": "string",
						"description": "Font resource path"
					},
					"stylebox_type": {
						"type": "string",
						"enum": ["flat", "line", "texture", "empty"],
						"description": "StyleBox type to create"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "control",
			"description": """CONTROL LAYOUT: Manage Control node layout and properties.

ACTIONS:
- get_layout: Get Control layout information
- set_anchor: Set anchor values
- set_anchor_preset: Set anchor preset
- set_margins: Set margin values (now called offsets)
- set_size_flags: Set size flags
- set_min_size: Set minimum size
- set_focus_mode: Set focus mode
- set_mouse_filter: Set mouse filter
- arrange: Arrange child controls

ANCHOR PRESETS:
- top_left, top_right, bottom_left, bottom_right
- center_left, center_right, center_top, center_bottom
- center, full_rect
- top_wide, bottom_wide, left_wide, right_wide
- hcenter_wide, vcenter_wide

SIZE FLAGS:
- fill: Control fills available space
- expand: Control expands to fill
- shrink_center: Center when smaller
- shrink_end: Align to end when smaller

EXAMPLES:
- Get layout: {"action": "get_layout", "path": "/root/UI/Button"}
- Set anchor preset: {"action": "set_anchor_preset", "path": "/root/UI/Panel", "preset": "full_rect"}
- Set margins: {"action": "set_margins", "path": "/root/UI/Panel", "left": 10, "top": 10, "right": -10, "bottom": -10}
- Set size flags: {"action": "set_size_flags", "path": "/root/UI/Button", "horizontal": ["fill", "expand"]}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_layout", "set_anchor", "set_anchor_preset", "set_margins", "set_size_flags", "set_min_size", "set_focus_mode", "set_mouse_filter", "arrange"],
						"description": "Control action"
					},
					"path": {
						"type": "string",
						"description": "Control node path"
					},
					"preset": {
						"type": "string",
						"description": "Anchor preset name"
					},
					"left": {"type": "number", "description": "Left anchor/margin"},
					"top": {"type": "number", "description": "Top anchor/margin"},
					"right": {"type": "number", "description": "Right anchor/margin"},
					"bottom": {"type": "number", "description": "Bottom anchor/margin"},
					"horizontal": {
						"type": "array",
						"items": {"type": "string"},
						"description": "Horizontal size flags"
					},
					"vertical": {
						"type": "array",
						"items": {"type": "string"},
						"description": "Vertical size flags"
					},
					"width": {"type": "number", "description": "Minimum width"},
					"height": {"type": "number", "description": "Minimum height"},
					"mode": {
						"type": "string",
						"enum": ["none", "click", "all"],
						"description": "Focus mode"
					},
					"filter": {
						"type": "string",
						"enum": ["stop", "pass", "ignore"],
						"description": "Mouse filter"
					}
				},
				"required": ["action", "path"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"theme":
			return _execute_theme(args)
		"control":
			return _execute_control(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== THEME ====================

func _execute_theme(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_theme(args)
		"get_info":
			return _get_theme_info(args.get("path", ""))
		"set_color":
			return _set_theme_color(args)
		"get_color":
			return _get_theme_color(args)
		"set_constant":
			return _set_theme_constant(args)
		"get_constant":
			return _get_theme_constant(args)
		"set_font":
			return _set_theme_font(args)
		"set_font_size":
			return _set_theme_font_size(args)
		"set_stylebox":
			return _set_theme_stylebox(args)
		"clear_item":
			return _clear_theme_item(args)
		"copy_default":
			return _copy_from_default(args)
		"assign_to_node":
			return _assign_theme_to_node(args.get("theme_path", ""), args.get("node_path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _load_theme(path: String) -> Theme:
	if path.is_empty():
		return null

	if not path.begins_with("res://"):
		path = "res://" + path

	if ResourceLoader.exists(path):
		return load(path) as Theme

	return null


func _create_theme(args: Dictionary) -> Dictionary:
	var save_path = args.get("save_path", "")

	var theme = Theme.new()

	if not save_path.is_empty():
		if not save_path.begins_with("res://"):
			save_path = "res://" + save_path
		if not save_path.ends_with(".tres") and not save_path.ends_with(".res"):
			save_path += ".tres"

		var error = ResourceSaver.save(theme, save_path)
		if error != OK:
			return _error("Failed to save theme: %s" % error_string(error))

		return _success({
			"path": save_path
		}, "Theme created and saved")

	return _success({
		"note": "Theme created in memory"
	}, "Theme created")


func _get_theme_info(path: String) -> Dictionary:
	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	var info = {
		"path": str(theme.resource_path) if theme.resource_path else null,
		"default_font": str(theme.default_font.resource_path) if theme.default_font else null,
		"default_font_size": theme.default_font_size,
		"default_base_scale": theme.default_base_scale
	}

	# List theme types and items
	var type_list = theme.get_type_list()
	var types = {}

	for type_name in type_list:
		var type_info = {
			"colors": Array(theme.get_color_list(type_name)),
			"constants": Array(theme.get_constant_list(type_name)),
			"fonts": Array(theme.get_font_list(type_name)),
			"font_sizes": Array(theme.get_font_size_list(type_name)),
			"icons": Array(theme.get_icon_list(type_name)),
			"styleboxes": Array(theme.get_stylebox_list(type_name))
		}
		types[type_name] = type_info

	info["types"] = types
	info["type_count"] = type_list.size()

	return _success(info)


func _set_theme_color(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var name = args.get("name", "")
	var type_name = args.get("type", "")
	var color_dict = args.get("color", {})

	if name.is_empty() or type_name.is_empty():
		return _error("Name and type are required")

	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	var color = Color(
		color_dict.get("r", 1),
		color_dict.get("g", 1),
		color_dict.get("b", 1),
		color_dict.get("a", 1)
	)

	theme.set_color(name, type_name, color)

	return _success({
		"name": name,
		"type": type_name,
		"color": _serialize_value(color)
	}, "Color set")


func _get_theme_color(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var name = args.get("name", "")
	var type_name = args.get("type", "")

	if name.is_empty() or type_name.is_empty():
		return _error("Name and type are required")

	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	if not theme.has_color(name, type_name):
		return _error("Color not found: %s in %s" % [name, type_name])

	var color = theme.get_color(name, type_name)

	return _success({
		"name": name,
		"type": type_name,
		"color": _serialize_value(color)
	})


func _set_theme_constant(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var name = args.get("name", "")
	var type_name = args.get("type", "")
	var value = args.get("value", 0)

	if name.is_empty() or type_name.is_empty():
		return _error("Name and type are required")

	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	theme.set_constant(name, type_name, int(value))

	return _success({
		"name": name,
		"type": type_name,
		"value": int(value)
	}, "Constant set")


func _get_theme_constant(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var name = args.get("name", "")
	var type_name = args.get("type", "")

	if name.is_empty() or type_name.is_empty():
		return _error("Name and type are required")

	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	if not theme.has_constant(name, type_name):
		return _error("Constant not found: %s in %s" % [name, type_name])

	return _success({
		"name": name,
		"type": type_name,
		"value": theme.get_constant(name, type_name)
	})


func _set_theme_font(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var name = args.get("name", "")
	var type_name = args.get("type", "")
	var font_path = args.get("font_path", "")

	if name.is_empty() or type_name.is_empty():
		return _error("Name and type are required")

	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	var font: Font = null
	if not font_path.is_empty():
		if not font_path.begins_with("res://"):
			font_path = "res://" + font_path
		font = load(font_path) as Font
		if not font:
			return _error("Font not found: %s" % font_path)

	theme.set_font(name, type_name, font)

	return _success({
		"name": name,
		"type": type_name,
		"font": font_path if font else null
	}, "Font set")


func _set_theme_font_size(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var name = args.get("name", "")
	var type_name = args.get("type", "")
	var value = args.get("value", 16)

	if name.is_empty() or type_name.is_empty():
		return _error("Name and type are required")

	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	theme.set_font_size(name, type_name, int(value))

	return _success({
		"name": name,
		"type": type_name,
		"size": int(value)
	}, "Font size set")


func _set_theme_stylebox(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var name = args.get("name", "")
	var type_name = args.get("type", "")
	var stylebox_type = args.get("stylebox_type", "flat")

	if name.is_empty() or type_name.is_empty():
		return _error("Name and type are required")

	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	var stylebox: StyleBox
	match stylebox_type:
		"flat":
			var sb = StyleBoxFlat.new()
			if args.has("bg_color"):
				var c = args.bg_color
				sb.bg_color = Color(c.get("r", 1), c.get("g", 1), c.get("b", 1), c.get("a", 1))
			if args.has("corner_radius"):
				var r = int(args.corner_radius)
				sb.corner_radius_top_left = r
				sb.corner_radius_top_right = r
				sb.corner_radius_bottom_left = r
				sb.corner_radius_bottom_right = r
			if args.has("border_width"):
				var w = int(args.border_width)
				sb.border_width_left = w
				sb.border_width_top = w
				sb.border_width_right = w
				sb.border_width_bottom = w
			if args.has("border_color"):
				var c = args.border_color
				sb.border_color = Color(c.get("r", 0), c.get("g", 0), c.get("b", 0), c.get("a", 1))
			stylebox = sb
		"line":
			stylebox = StyleBoxLine.new()
		"empty":
			stylebox = StyleBoxEmpty.new()
		_:
			return _error("Invalid stylebox type: %s" % stylebox_type)

	theme.set_stylebox(name, type_name, stylebox)

	return _success({
		"name": name,
		"type": type_name,
		"stylebox_type": stylebox_type
	}, "StyleBox set")


func _clear_theme_item(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var name = args.get("name", "")
	var type_name = args.get("type", "")
	var data_type = args.get("data_type", "color")

	if name.is_empty() or type_name.is_empty():
		return _error("Name and type are required")

	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	match data_type:
		"color":
			theme.clear_color(name, type_name)
		"constant":
			theme.clear_constant(name, type_name)
		"font":
			theme.clear_font(name, type_name)
		"font_size":
			theme.clear_font_size(name, type_name)
		"icon":
			theme.clear_icon(name, type_name)
		"stylebox":
			theme.clear_stylebox(name, type_name)
		_:
			return _error("Invalid data type: %s" % data_type)

	return _success({
		"name": name,
		"type": type_name,
		"data_type": data_type
	}, "Theme item cleared")


func _copy_from_default(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var type_name = args.get("type", "")

	if type_name.is_empty():
		return _error("Type is required")

	var theme = _load_theme(path)
	if not theme:
		return _error("Theme not found: %s" % path)

	# Copy from default theme
	var default_theme = ThemeDB.get_default_theme()
	if not default_theme:
		return _error("Default theme not available")

	var items_copied = 0

	# Copy colors
	for color_name in default_theme.get_color_list(type_name):
		theme.set_color(color_name, type_name, default_theme.get_color(color_name, type_name))
		items_copied += 1

	# Copy constants
	for const_name in default_theme.get_constant_list(type_name):
		theme.set_constant(const_name, type_name, default_theme.get_constant(const_name, type_name))
		items_copied += 1

	# Copy styleboxes
	for sb_name in default_theme.get_stylebox_list(type_name):
		var sb = default_theme.get_stylebox(sb_name, type_name)
		if sb:
			theme.set_stylebox(sb_name, type_name, sb.duplicate())
			items_copied += 1

	return _success({
		"type": type_name,
		"items_copied": items_copied
	}, "Copied %d items from default theme" % items_copied)


func _assign_theme_to_node(theme_path: String, node_path: String) -> Dictionary:
	if theme_path.is_empty() or node_path.is_empty():
		return _error("Both theme_path and node_path are required")

	var theme = _load_theme(theme_path)
	if not theme:
		return _error("Theme not found: %s" % theme_path)

	var node = _find_node_by_path(node_path)
	if not node:
		return _error("Node not found: %s" % node_path)

	if not node is Control:
		return _error("Node is not a Control: %s" % node_path)

	node.theme = theme

	return _success({
		"theme": theme_path,
		"node": node_path
	}, "Theme assigned")


# ==================== CONTROL ====================

func _execute_control(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is Control:
		return _error("Node is not a Control: %s" % path)

	var control = node as Control

	match action:
		"get_layout":
			return _get_control_layout(control)
		"set_anchor":
			return _set_control_anchor(control, args)
		"set_anchor_preset":
			return _set_anchor_preset(control, args.get("preset", ""))
		"set_margins":
			return _set_control_margins(control, args)
		"set_size_flags":
			return _set_size_flags(control, args)
		"set_min_size":
			return _set_min_size(control, args)
		"set_focus_mode":
			return _set_focus_mode(control, args.get("mode", "none"))
		"set_mouse_filter":
			return _set_mouse_filter(control, args.get("filter", "stop"))
		"arrange":
			return _arrange_children(control, args)
		_:
			return _error("Unknown action: %s" % action)


func _get_control_layout(control: Control) -> Dictionary:
	return _success({
		"path": _get_scene_path(control),
		"position": _serialize_value(control.position),
		"size": _serialize_value(control.size),
		"global_position": _serialize_value(control.global_position),
		"anchors": {
			"left": control.anchor_left,
			"top": control.anchor_top,
			"right": control.anchor_right,
			"bottom": control.anchor_bottom
		},
		"offsets": {
			"left": control.offset_left,
			"top": control.offset_top,
			"right": control.offset_right,
			"bottom": control.offset_bottom
		},
		"pivot_offset": _serialize_value(control.pivot_offset),
		"rotation": control.rotation,
		"scale": _serialize_value(control.scale),
		"custom_minimum_size": _serialize_value(control.custom_minimum_size),
		"size_flags": {
			"horizontal": control.size_flags_horizontal,
			"vertical": control.size_flags_vertical,
			"stretch_ratio": control.size_flags_stretch_ratio
		},
		"focus_mode": control.focus_mode,
		"mouse_filter": control.mouse_filter,
		"tooltip_text": control.tooltip_text
	})


func _set_control_anchor(control: Control, args: Dictionary) -> Dictionary:
	if args.has("left"):
		control.anchor_left = args.left
	if args.has("top"):
		control.anchor_top = args.top
	if args.has("right"):
		control.anchor_right = args.right
	if args.has("bottom"):
		control.anchor_bottom = args.bottom

	return _success({
		"anchors": {
			"left": control.anchor_left,
			"top": control.anchor_top,
			"right": control.anchor_right,
			"bottom": control.anchor_bottom
		}
	}, "Anchors set")


func _set_anchor_preset(control: Control, preset: String) -> Dictionary:
	var preset_value: Control.LayoutPreset

	match preset.to_lower():
		"top_left": preset_value = Control.PRESET_TOP_LEFT
		"top_right": preset_value = Control.PRESET_TOP_RIGHT
		"bottom_left": preset_value = Control.PRESET_BOTTOM_LEFT
		"bottom_right": preset_value = Control.PRESET_BOTTOM_RIGHT
		"center_left": preset_value = Control.PRESET_CENTER_LEFT
		"center_right": preset_value = Control.PRESET_CENTER_RIGHT
		"center_top": preset_value = Control.PRESET_CENTER_TOP
		"center_bottom": preset_value = Control.PRESET_CENTER_BOTTOM
		"center": preset_value = Control.PRESET_CENTER
		"full_rect": preset_value = Control.PRESET_FULL_RECT
		"top_wide": preset_value = Control.PRESET_TOP_WIDE
		"bottom_wide": preset_value = Control.PRESET_BOTTOM_WIDE
		"left_wide": preset_value = Control.PRESET_LEFT_WIDE
		"right_wide": preset_value = Control.PRESET_RIGHT_WIDE
		"hcenter_wide": preset_value = Control.PRESET_HCENTER_WIDE
		"vcenter_wide": preset_value = Control.PRESET_VCENTER_WIDE
		_:
			return _error("Invalid preset: %s" % preset)

	control.set_anchors_and_offsets_preset(preset_value)

	return _success({
		"preset": preset
	}, "Anchor preset applied")


func _set_control_margins(control: Control, args: Dictionary) -> Dictionary:
	if args.has("left"):
		control.offset_left = args.left
	if args.has("top"):
		control.offset_top = args.top
	if args.has("right"):
		control.offset_right = args.right
	if args.has("bottom"):
		control.offset_bottom = args.bottom

	return _success({
		"offsets": {
			"left": control.offset_left,
			"top": control.offset_top,
			"right": control.offset_right,
			"bottom": control.offset_bottom
		}
	}, "Margins/offsets set")


func _set_size_flags(control: Control, args: Dictionary) -> Dictionary:
	if args.has("horizontal"):
		var h_flags = 0
		for flag in args.horizontal:
			match flag.to_lower():
				"fill": h_flags |= Control.SIZE_FILL
				"expand": h_flags |= Control.SIZE_EXPAND
				"shrink_center": h_flags |= Control.SIZE_SHRINK_CENTER
				"shrink_end": h_flags |= Control.SIZE_SHRINK_END
		control.size_flags_horizontal = h_flags

	if args.has("vertical"):
		var v_flags = 0
		for flag in args.vertical:
			match flag.to_lower():
				"fill": v_flags |= Control.SIZE_FILL
				"expand": v_flags |= Control.SIZE_EXPAND
				"shrink_center": v_flags |= Control.SIZE_SHRINK_CENTER
				"shrink_end": v_flags |= Control.SIZE_SHRINK_END
		control.size_flags_vertical = v_flags

	return _success({
		"horizontal": control.size_flags_horizontal,
		"vertical": control.size_flags_vertical
	}, "Size flags set")


func _set_min_size(control: Control, args: Dictionary) -> Dictionary:
	var width = args.get("width", control.custom_minimum_size.x)
	var height = args.get("height", control.custom_minimum_size.y)

	control.custom_minimum_size = Vector2(width, height)

	return _success({
		"custom_minimum_size": _serialize_value(control.custom_minimum_size)
	}, "Minimum size set")


func _set_focus_mode(control: Control, mode: String) -> Dictionary:
	match mode.to_lower():
		"none": control.focus_mode = Control.FOCUS_NONE
		"click": control.focus_mode = Control.FOCUS_CLICK
		"all": control.focus_mode = Control.FOCUS_ALL
		_: return _error("Invalid focus mode: %s" % mode)

	return _success({
		"focus_mode": mode
	}, "Focus mode set")


func _set_mouse_filter(control: Control, filter: String) -> Dictionary:
	match filter.to_lower():
		"stop": control.mouse_filter = Control.MOUSE_FILTER_STOP
		"pass": control.mouse_filter = Control.MOUSE_FILTER_PASS
		"ignore": control.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_: return _error("Invalid mouse filter: %s" % filter)

	return _success({
		"mouse_filter": filter
	}, "Mouse filter set")


func _arrange_children(control: Control, args: Dictionary) -> Dictionary:
	# This is useful for Container nodes
	if control is Container:
		control.queue_sort()
		return _success({
			"path": _get_scene_path(control),
			"child_count": control.get_child_count()
		}, "Children arranged")

	return _success({
		"note": "Node is not a Container, no arrangement needed"
	})
