@tool
extends RefCounted
class_name MCPBaseTool

## Base class for all MCP tool executors

func get_tools() -> Array[Dictionary]:
	## Override to return tool definitions
	return []


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	## Override to execute tools
	return _error("Tool not implemented: %s" % tool_name)


func _success(data = null, message: String = "") -> Dictionary:
	var result = {"success": true}
	if data != null:
		result["data"] = data
	if not message.is_empty():
		result["message"] = message
	return result


func _error(message: String, data = null, hints: Array = []) -> Dictionary:
	var result = {
		"success": false,
		"error": message
	}
	if data != null:
		result["data"] = data
	if not hints.is_empty():
		result["hints"] = hints
	return result


func _get_property_info(node: Node, property_name: String) -> Dictionary:
	"""Get detailed property information including type hints and valid values"""
	for prop in node.get_property_list():
		if str(prop.name) == property_name:
			var info = {
				"name": str(prop.name),
				"type": prop.type,
				"type_name": _type_to_string(prop.type),
				"hint": prop.hint,
				"hint_string": str(prop.hint_string),
				"usage": prop.usage
			}
			# Parse hint string based on hint type (matching Godot's _parse_range_hint)
			var hint_string = str(prop.hint_string)

			match prop.hint:
				PROPERTY_HINT_ENUM, PROPERTY_HINT_ENUM_SUGGESTION:
					# Format: "val1,val2,val3" or "val1:0,val2:1,val3:2"
					if not hint_string.is_empty():
						info["valid_values"] = hint_string.split(",")

				PROPERTY_HINT_RANGE:
					# Format: "min,max[,step][,or_greater][,or_less][,hide_slider][,exp][,suffix:<text>]"
					if not hint_string.is_empty():
						var range_info = _parse_range_hint(hint_string, prop.type == TYPE_INT)
						info["range"] = range_info

				PROPERTY_HINT_FLAGS:
					# Format: "flag1,flag2,flag3" (as bit flags)
					if not hint_string.is_empty():
						info["flags"] = hint_string.split(",")

				PROPERTY_HINT_EXP_EASING:
					# Easing function hint
					info["easing"] = true
					if "attenuation" in hint_string:
						info["easing_attenuation"] = true
					if "positive_only" in hint_string:
						info["easing_positive_only"] = true

				PROPERTY_HINT_LAYERS_2D_RENDER, PROPERTY_HINT_LAYERS_2D_PHYSICS, \
				PROPERTY_HINT_LAYERS_2D_NAVIGATION, PROPERTY_HINT_LAYERS_3D_RENDER, \
				PROPERTY_HINT_LAYERS_3D_PHYSICS, PROPERTY_HINT_LAYERS_3D_NAVIGATION, \
				PROPERTY_HINT_LAYERS_AVOIDANCE:
					# Layer hints - valid values are 1-32 (bit positions)
					info["layer_hint"] = true
					info["range"] = {"min": 1, "max": 32, "step": 1}

				PROPERTY_HINT_FILE, PROPERTY_HINT_GLOBAL_FILE, PROPERTY_HINT_SAVE_FILE, PROPERTY_HINT_GLOBAL_SAVE_FILE:
					# File filter hint
					if not hint_string.is_empty():
						info["file_filter"] = hint_string.split(",")

				PROPERTY_HINT_DIR, PROPERTY_HINT_GLOBAL_DIR:
					info["is_directory"] = true

				PROPERTY_HINT_RESOURCE_TYPE:
					# Resource type hint
					if not hint_string.is_empty():
						info["resource_types"] = hint_string.split(",")

				PROPERTY_HINT_COLOR_NO_ALPHA:
					info["color_no_alpha"] = true

				PROPERTY_HINT_NODE_TYPE:
					if not hint_string.is_empty():
						info["node_types"] = hint_string.split(",")

			# Check usage flags
			if prop.usage & PROPERTY_USAGE_READ_ONLY:
				info["read_only"] = true
			if prop.usage & PROPERTY_USAGE_CLASS_IS_ENUM:
				info["is_enum_class"] = true

			return info
	return {}


func _parse_range_hint(hint_string: String, is_int: bool = false) -> Dictionary:
	"""Parse PROPERTY_HINT_RANGE hint string (matching Godot's _parse_range_hint)"""
	var result = {
		"min": 0.0,
		"max": 100.0,
		"step": 1.0 if is_int else 0.001,
		"or_greater": false,
		"or_less": false,
		"exp": false,
		"suffix": ""
	}

	var slices = hint_string.split(",")
	if slices.size() < 2:
		return result

	result["min"] = float(slices[0])
	result["max"] = float(slices[1])

	# Parse optional step (third parameter if it's a number)
	if slices.size() >= 3:
		var third = slices[2].strip_edges()
		if third.is_valid_float():
			result["step"] = float(third)

	# Parse additional options
	for i in range(2, slices.size()):
		var slice = slices[i].strip_edges()
		match slice:
			"or_greater":
				result["or_greater"] = true
			"or_less":
				result["or_less"] = true
			"exp":
				result["exp"] = true
			"radians_as_degrees", "degrees":
				result["suffix"] = "°"
			_:
				if slice.begins_with("suffix:"):
					result["suffix"] = slice.substr(7).strip_edges()

	return result


func _type_to_string(type: int) -> String:
	"""Convert Variant type to human-readable string (matching Godot's Variant::Type enum)"""
	match type:
		TYPE_NIL: return "null"
		TYPE_BOOL: return "bool (true/false)"
		TYPE_INT: return "int"
		TYPE_FLOAT: return "float"
		TYPE_STRING: return "String"
		TYPE_VECTOR2: return "Vector2 {\"x\": float, \"y\": float}"
		TYPE_VECTOR2I: return "Vector2i {\"x\": int, \"y\": int}"
		TYPE_RECT2: return "Rect2 {\"position\": {x,y}, \"size\": {x,y}}"
		TYPE_RECT2I: return "Rect2i {\"position\": {x,y}, \"size\": {x,y}}"
		TYPE_VECTOR3: return "Vector3 {\"x\": float, \"y\": float, \"z\": float}"
		TYPE_VECTOR3I: return "Vector3i {\"x\": int, \"y\": int, \"z\": int}"
		TYPE_TRANSFORM2D: return "Transform2D"
		TYPE_VECTOR4: return "Vector4 {\"x\": float, \"y\": float, \"z\": float, \"w\": float}"
		TYPE_VECTOR4I: return "Vector4i {\"x\": int, \"y\": int, \"z\": int, \"w\": int}"
		TYPE_PLANE: return "Plane {\"normal\": {x,y,z}, \"d\": float}"
		TYPE_QUATERNION: return "Quaternion {\"x\": float, \"y\": float, \"z\": float, \"w\": float}"
		TYPE_AABB: return "AABB {\"position\": {x,y,z}, \"size\": {x,y,z}}"
		TYPE_BASIS: return "Basis"
		TYPE_TRANSFORM3D: return "Transform3D {\"basis\": Basis, \"origin\": {x,y,z}}"
		TYPE_PROJECTION: return "Projection"
		TYPE_COLOR: return "Color {\"r\": 0-1, \"g\": 0-1, \"b\": 0-1, \"a\": 0-1} or \"#RRGGBB\""
		TYPE_STRING_NAME: return "StringName (String)"
		TYPE_NODE_PATH: return "NodePath (String path)"
		TYPE_RID: return "RID (resource ID)"
		TYPE_OBJECT: return "Object/Resource (res:// path)"
		TYPE_CALLABLE: return "Callable"
		TYPE_SIGNAL: return "Signal"
		TYPE_DICTIONARY: return "Dictionary {}"
		TYPE_ARRAY: return "Array []"
		TYPE_PACKED_BYTE_ARRAY: return "PackedByteArray"
		TYPE_PACKED_INT32_ARRAY: return "PackedInt32Array"
		TYPE_PACKED_INT64_ARRAY: return "PackedInt64Array"
		TYPE_PACKED_FLOAT32_ARRAY: return "PackedFloat32Array"
		TYPE_PACKED_FLOAT64_ARRAY: return "PackedFloat64Array"
		TYPE_PACKED_STRING_ARRAY: return "PackedStringArray"
		TYPE_PACKED_VECTOR2_ARRAY: return "PackedVector2Array"
		TYPE_PACKED_VECTOR3_ARRAY: return "PackedVector3Array"
		TYPE_PACKED_COLOR_ARRAY: return "PackedColorArray"
		TYPE_PACKED_VECTOR4_ARRAY: return "PackedVector4Array"
		_: return "Unknown (type %d)" % type


func _validate_value_type(value, expected_type: int, prop_info: Dictionary = {}) -> Dictionary:
	"""Validate value matches expected type and return conversion hints if not"""
	var value_type = typeof(value)

	# Check for type compatibility
	var compatible = false
	var hints: Array = []

	# Check read-only first
	if prop_info.get("read_only", false):
		hints.append("This property is read-only")
		return {"valid": false, "hints": hints}

	match expected_type:
		TYPE_BOOL:
			compatible = value_type == TYPE_BOOL or (value_type == TYPE_INT and (value == 0 or value == 1))
			if not compatible:
				hints.append("Expected: true or false")

		TYPE_INT:
			compatible = value_type == TYPE_INT or value_type == TYPE_FLOAT
			if compatible and prop_info.has("range"):
				var r = prop_info["range"]
				var min_val = r.get("min", 0)
				var max_val = r.get("max", 100)
				var or_greater = r.get("or_greater", false)
				var or_less = r.get("or_less", false)

				# Validate against range (respecting or_greater/or_less)
				if value < min_val and not or_less:
					hints.append("Value %s is below minimum %s" % [value, min_val])
					compatible = false
				elif value > max_val and not or_greater:
					hints.append("Value %s is above maximum %s" % [value, max_val])
					compatible = false

				# Add range info to hints
				var range_desc = "Range: %s to %s" % [min_val, max_val]
				if or_greater:
					range_desc += " (or greater)"
				if or_less:
					range_desc += " (or less)"
				if r.get("suffix", "") != "":
					range_desc += " %s" % r["suffix"]
				hints.append(range_desc)

			if prop_info.has("valid_values"):
				hints.append("Valid values: %s" % ", ".join(prop_info["valid_values"]))

		TYPE_FLOAT:
			compatible = value_type == TYPE_FLOAT or value_type == TYPE_INT
			if compatible and prop_info.has("range"):
				var r = prop_info["range"]
				var min_val = r.get("min", 0.0)
				var max_val = r.get("max", 1.0)
				var or_greater = r.get("or_greater", false)
				var or_less = r.get("or_less", false)

				# Validate against range
				if value < min_val and not or_less:
					hints.append("Value %s is below minimum %s" % [value, min_val])
					compatible = false
				elif value > max_val and not or_greater:
					hints.append("Value %s is above maximum %s" % [value, max_val])
					compatible = false

				var range_desc = "Range: %s to %s" % [min_val, max_val]
				if or_greater:
					range_desc += " (or greater)"
				if or_less:
					range_desc += " (or less)"
				if r.get("suffix", "") != "":
					range_desc += " %s" % r["suffix"]
				hints.append(range_desc)

		TYPE_STRING, TYPE_STRING_NAME, TYPE_NODE_PATH:
			compatible = value_type == TYPE_STRING or value_type == TYPE_STRING_NAME
			if prop_info.has("file_filter"):
				hints.append("File types: %s" % ", ".join(prop_info["file_filter"]))
			if prop_info.get("is_directory", false):
				hints.append("Must be a directory path")

		TYPE_VECTOR2:
			compatible = value_type == TYPE_DICTIONARY and value.has("x") and value.has("y")
			if not compatible:
				hints.append("Expected: {\"x\": float, \"y\": float}")

		TYPE_VECTOR2I:
			compatible = value_type == TYPE_DICTIONARY and value.has("x") and value.has("y")
			if not compatible:
				hints.append("Expected: {\"x\": int, \"y\": int}")

		TYPE_VECTOR3:
			compatible = value_type == TYPE_DICTIONARY and value.has("x") and value.has("y") and value.has("z")
			if not compatible:
				hints.append("Expected: {\"x\": float, \"y\": float, \"z\": float}")

		TYPE_VECTOR3I:
			compatible = value_type == TYPE_DICTIONARY and value.has("x") and value.has("y") and value.has("z")
			if not compatible:
				hints.append("Expected: {\"x\": int, \"y\": int, \"z\": int}")

		TYPE_VECTOR4, TYPE_VECTOR4I:
			compatible = value_type == TYPE_DICTIONARY and value.has("x") and value.has("y") and value.has("z") and value.has("w")
			if not compatible:
				hints.append("Expected: {\"x\": num, \"y\": num, \"z\": num, \"w\": num}")

		TYPE_RECT2, TYPE_RECT2I:
			compatible = value_type == TYPE_DICTIONARY and value.has("position") and value.has("size")
			if not compatible:
				hints.append("Expected: {\"position\": {\"x\": n, \"y\": n}, \"size\": {\"x\": n, \"y\": n}}")

		TYPE_COLOR:
			if value_type == TYPE_DICTIONARY:
				compatible = value.has("r") and value.has("g") and value.has("b")
				if compatible and prop_info.get("color_no_alpha", false) and value.has("a"):
					hints.append("Note: Alpha channel will be ignored for this property")
			elif value_type == TYPE_STRING:
				# Allow color strings like "#FF0000" or "red"
				compatible = true
			if not compatible:
				hints.append("Expected: {\"r\": 0-1, \"g\": 0-1, \"b\": 0-1, \"a\": 0-1} or \"#RRGGBB\"")

		TYPE_QUATERNION:
			compatible = value_type == TYPE_DICTIONARY and value.has("x") and value.has("y") and value.has("z") and value.has("w")
			if not compatible:
				hints.append("Expected: {\"x\": float, \"y\": float, \"z\": float, \"w\": float}")

		TYPE_AABB:
			compatible = value_type == TYPE_DICTIONARY and value.has("position") and value.has("size")
			if not compatible:
				hints.append("Expected: {\"position\": {x,y,z}, \"size\": {x,y,z}}")

		TYPE_OBJECT:
			compatible = value == null or value_type == TYPE_STRING or value_type == TYPE_OBJECT
			if value_type == TYPE_STRING and not value.is_empty() and not value.begins_with("res://"):
				hints.append("Resource paths should start with 'res://'")
			if prop_info.has("resource_types"):
				hints.append("Expected resource types: %s" % ", ".join(prop_info["resource_types"]))
			if prop_info.has("node_types"):
				hints.append("Expected node types: %s" % ", ".join(prop_info["node_types"]))

		TYPE_ARRAY:
			compatible = value_type == TYPE_ARRAY
			if not compatible:
				hints.append("Expected: Array []")

		TYPE_DICTIONARY:
			compatible = value_type == TYPE_DICTIONARY
			if not compatible:
				hints.append("Expected: Dictionary {}")

		_:
			# For other types, attempt conversion
			compatible = true

	return {"valid": compatible, "hints": hints}


func _get_editor_interface() -> EditorInterface:
	# In Godot 4, EditorInterface is accessed via Engine singleton when in editor
	if Engine.has_singleton("EditorInterface"):
		return Engine.get_singleton("EditorInterface")
	return null


func _get_edited_scene_root() -> Node:
	var ei = _get_editor_interface()
	if ei:
		return ei.get_edited_scene_root()
	return null


func _get_selection() -> EditorSelection:
	var ei = _get_editor_interface()
	if ei:
		return ei.get_selection()
	return null


func _get_filesystem() -> EditorFileSystem:
	var ei = _get_editor_interface()
	if ei:
		return ei.get_resource_filesystem()
	return null


func _get_scene_path(node: Node) -> String:
	"""Get the scene-relative path of a node instead of the full editor tree path.

	This returns a clean path like 'UI/ScoreboardFrame' instead of
	'/root/@EditorNode@20475/.../@SubViewport@10532/GameScene/UI/ScoreboardFrame'
	"""
	if not node or not node.is_inside_tree():
		return ""

	var scene_root = _get_edited_scene_root()
	if not scene_root:
		# Fallback to full path if no scene is being edited
		return str(node.get_path())

	# If the node is the scene root itself
	if node == scene_root:
		return str(node.name)

	# Check if the node is under the scene root
	var node_path = node.get_path()
	var scene_path = scene_root.get_path()
	var node_path_str = str(node_path)
	var scene_path_str = str(scene_path)

	if node_path_str.begins_with(scene_path_str + "/"):
		# Return the relative path from scene root
		return node_path_str.substr(scene_path_str.length() + 1)
	elif node_path_str == scene_path_str:
		return str(node.name)
	else:
		# Node is not under the scene root, return full path
		return node_path_str


func _node_to_dict(node: Node, include_children: bool = false, max_depth: int = 3) -> Dictionary:
	if not node:
		return {}

	var result = {
		"name": str(node.name),
		"type": str(node.get_class()),
		"path": _get_scene_path(node),
		"visible": bool(node.visible) if node is CanvasItem else (bool(node.visible) if node is Node3D else true),
	}

	# Add transform info for 2D nodes
	if node is Node2D:
		result["position"] = {"x": float(node.position.x), "y": float(node.position.y)}
		result["rotation"] = float(node.rotation)
		result["scale"] = {"x": float(node.scale.x), "y": float(node.scale.y)}

	# Add transform info for 3D nodes
	if node is Node3D:
		result["position"] = {"x": float(node.position.x), "y": float(node.position.y), "z": float(node.position.z)}
		result["rotation"] = {"x": float(node.rotation.x), "y": float(node.rotation.y), "z": float(node.rotation.z)}
		result["scale"] = {"x": float(node.scale.x), "y": float(node.scale.y), "z": float(node.scale.z)}

	# Add script info
	var script = node.get_script()
	if script:
		result["script"] = str(script.resource_path)

	# Add children if requested
	if include_children and max_depth > 0:
		var children: Array[Dictionary] = []
		for child in node.get_children():
			children.append(_node_to_dict(child, true, max_depth - 1))
		if not children.is_empty():
			result["children"] = children

	return result


func _find_node_by_path(path: String) -> Node:
	var root = _get_edited_scene_root()
	if not root:
		return null

	if path == "/" or path.is_empty():
		return root

	return root.get_node_or_null(path)


func _find_nodes_by_name(name_pattern: String, parent: Node = null) -> Array[Node]:
	var result: Array[Node] = []

	if not parent:
		parent = _get_edited_scene_root()
	if not parent:
		return result

	_find_nodes_recursive(parent, name_pattern, result)
	return result


func _find_nodes_recursive(node: Node, pattern: String, result: Array[Node]) -> void:
	if node.name.match(pattern) or str(node.name).contains(pattern):
		result.append(node)

	for child in node.get_children():
		_find_nodes_recursive(child, pattern, result)


func _find_nodes_by_type(type_name: String, parent: Node = null) -> Array[Node]:
	var result: Array[Node] = []

	if not parent:
		parent = _get_edited_scene_root()
	if not parent:
		return result

	_find_nodes_by_type_recursive(parent, type_name, result)
	return result


func _find_nodes_by_type_recursive(node: Node, type_name: String, result: Array[Node]) -> void:
	if node.get_class() == type_name or node.is_class(type_name):
		result.append(node)

	for child in node.get_children():
		_find_nodes_by_type_recursive(child, type_name, result)


func _serialize_value(value) -> Variant:
	"""Convert Godot types to JSON-serializable formats (matching Godot's Variant types)"""
	match typeof(value):
		TYPE_VECTOR2:
			return {"x": float(value.x), "y": float(value.y)}
		TYPE_VECTOR2I:
			return {"x": int(value.x), "y": int(value.y)}
		TYPE_VECTOR3:
			return {"x": float(value.x), "y": float(value.y), "z": float(value.z)}
		TYPE_VECTOR3I:
			return {"x": int(value.x), "y": int(value.y), "z": int(value.z)}
		TYPE_VECTOR4:
			return {"x": float(value.x), "y": float(value.y), "z": float(value.z), "w": float(value.w)}
		TYPE_VECTOR4I:
			return {"x": int(value.x), "y": int(value.y), "z": int(value.z), "w": int(value.w)}
		TYPE_COLOR:
			return {"r": float(value.r), "g": float(value.g), "b": float(value.b), "a": float(value.a)}
		TYPE_RECT2:
			return {"position": {"x": float(value.position.x), "y": float(value.position.y)}, "size": {"x": float(value.size.x), "y": float(value.size.y)}}
		TYPE_RECT2I:
			return {"position": {"x": int(value.position.x), "y": int(value.position.y)}, "size": {"x": int(value.size.x), "y": int(value.size.y)}}
		TYPE_PLANE:
			return {"normal": {"x": float(value.normal.x), "y": float(value.normal.y), "z": float(value.normal.z)}, "d": float(value.d)}
		TYPE_QUATERNION:
			return {"x": float(value.x), "y": float(value.y), "z": float(value.z), "w": float(value.w)}
		TYPE_AABB:
			return {"position": {"x": float(value.position.x), "y": float(value.position.y), "z": float(value.position.z)}, "size": {"x": float(value.size.x), "y": float(value.size.y), "z": float(value.size.z)}}
		TYPE_TRANSFORM2D:
			return {
				"x": {"x": float(value.x.x), "y": float(value.x.y)},
				"y": {"x": float(value.y.x), "y": float(value.y.y)},
				"origin": {"x": float(value.origin.x), "y": float(value.origin.y)}
			}
		TYPE_TRANSFORM3D:
			return {
				"basis": {
					"x": {"x": float(value.basis.x.x), "y": float(value.basis.x.y), "z": float(value.basis.x.z)},
					"y": {"x": float(value.basis.y.x), "y": float(value.basis.y.y), "z": float(value.basis.y.z)},
					"z": {"x": float(value.basis.z.x), "y": float(value.basis.z.y), "z": float(value.basis.z.z)}
				},
				"origin": {"x": float(value.origin.x), "y": float(value.origin.y), "z": float(value.origin.z)}
			}
		TYPE_BASIS:
			return {
				"x": {"x": float(value.x.x), "y": float(value.x.y), "z": float(value.x.z)},
				"y": {"x": float(value.y.x), "y": float(value.y.y), "z": float(value.y.z)},
				"z": {"x": float(value.z.x), "y": float(value.z.y), "z": float(value.z.z)}
			}
		TYPE_OBJECT:
			if value == null:
				return null
			if value is Resource and value.resource_path:
				return str(value.resource_path)
			return str(value)
		TYPE_STRING_NAME:
			return str(value)
		TYPE_NODE_PATH:
			return str(value)
		TYPE_FLOAT:
			if is_nan(value) or is_inf(value):
				return 0.0
			return float(value)
		_:
			return value


func _deserialize_value(value, reference):
	"""Convert JSON values to Godot types based on reference type (matching Godot's Variant types)"""

	# If value is a string that looks like JSON, try to parse it first
	if value is String:
		var trimmed = value.strip_edges()
		if trimmed.begins_with("{") or trimmed.begins_with("["):
			var json = JSON.new()
			var err = json.parse(trimmed)
			if err == OK:
				value = json.get_data()

	match typeof(reference):
		TYPE_VECTOR2:
			if value is Dictionary:
				return Vector2(value.get("x", 0), value.get("y", 0))
		TYPE_VECTOR2I:
			if value is Dictionary:
				return Vector2i(int(value.get("x", 0)), int(value.get("y", 0)))
		TYPE_VECTOR3:
			if value is Dictionary:
				return Vector3(value.get("x", 0), value.get("y", 0), value.get("z", 0))
		TYPE_VECTOR3I:
			if value is Dictionary:
				return Vector3i(int(value.get("x", 0)), int(value.get("y", 0)), int(value.get("z", 0)))
		TYPE_VECTOR4:
			if value is Dictionary:
				return Vector4(value.get("x", 0), value.get("y", 0), value.get("z", 0), value.get("w", 0))
		TYPE_VECTOR4I:
			if value is Dictionary:
				return Vector4i(int(value.get("x", 0)), int(value.get("y", 0)), int(value.get("z", 0)), int(value.get("w", 0)))
		TYPE_COLOR:
			if value is Dictionary:
				return Color(value.get("r", 1), value.get("g", 1), value.get("b", 1), value.get("a", 1))
			elif value is String:
				# Handle hex colors and named colors
				if value.begins_with("#") or not "{" in value:
					return Color.html(value) if Color.html_is_valid(value) else Color.WHITE
		TYPE_RECT2:
			if value is Dictionary:
				var pos = value.get("position", {"x": 0, "y": 0})
				var sz = value.get("size", {"x": 0, "y": 0})
				return Rect2(pos.get("x", 0), pos.get("y", 0), sz.get("x", 0), sz.get("y", 0))
		TYPE_RECT2I:
			if value is Dictionary:
				var pos = value.get("position", {"x": 0, "y": 0})
				var sz = value.get("size", {"x": 0, "y": 0})
				return Rect2i(int(pos.get("x", 0)), int(pos.get("y", 0)), int(sz.get("x", 0)), int(sz.get("y", 0)))
		TYPE_PLANE:
			if value is Dictionary:
				var normal = value.get("normal", {"x": 0, "y": 1, "z": 0})
				return Plane(Vector3(normal.get("x", 0), normal.get("y", 1), normal.get("z", 0)), value.get("d", 0))
		TYPE_QUATERNION:
			if value is Dictionary:
				return Quaternion(value.get("x", 0), value.get("y", 0), value.get("z", 0), value.get("w", 1))
		TYPE_AABB:
			if value is Dictionary:
				var pos = value.get("position", {"x": 0, "y": 0, "z": 0})
				var sz = value.get("size", {"x": 1, "y": 1, "z": 1})
				return AABB(
					Vector3(pos.get("x", 0), pos.get("y", 0), pos.get("z", 0)),
					Vector3(sz.get("x", 1), sz.get("y", 1), sz.get("z", 1))
				)
		TYPE_TRANSFORM2D:
			if value is Dictionary:
				var x_axis = value.get("x", {"x": 1, "y": 0})
				var y_axis = value.get("y", {"x": 0, "y": 1})
				var origin = value.get("origin", {"x": 0, "y": 0})
				return Transform2D(
					Vector2(x_axis.get("x", 1), x_axis.get("y", 0)),
					Vector2(y_axis.get("x", 0), y_axis.get("y", 1)),
					Vector2(origin.get("x", 0), origin.get("y", 0))
				)
		TYPE_BASIS:
			if value is Dictionary:
				var x_axis = value.get("x", {"x": 1, "y": 0, "z": 0})
				var y_axis = value.get("y", {"x": 0, "y": 1, "z": 0})
				var z_axis = value.get("z", {"x": 0, "y": 0, "z": 1})
				return Basis(
					Vector3(x_axis.get("x", 1), x_axis.get("y", 0), x_axis.get("z", 0)),
					Vector3(y_axis.get("x", 0), y_axis.get("y", 1), y_axis.get("z", 0)),
					Vector3(z_axis.get("x", 0), z_axis.get("y", 0), z_axis.get("z", 1))
				)
		TYPE_TRANSFORM3D:
			if value is Dictionary:
				var basis_data = value.get("basis", {})
				var origin_data = value.get("origin", {"x": 0, "y": 0, "z": 0})
				var basis = Basis.IDENTITY
				if not basis_data.is_empty():
					var x_axis = basis_data.get("x", {"x": 1, "y": 0, "z": 0})
					var y_axis = basis_data.get("y", {"x": 0, "y": 1, "z": 0})
					var z_axis = basis_data.get("z", {"x": 0, "y": 0, "z": 1})
					basis = Basis(
						Vector3(x_axis.get("x", 1), x_axis.get("y", 0), x_axis.get("z", 0)),
						Vector3(y_axis.get("x", 0), y_axis.get("y", 1), y_axis.get("z", 0)),
						Vector3(z_axis.get("x", 0), z_axis.get("y", 0), z_axis.get("z", 1))
					)
				var origin = Vector3(origin_data.get("x", 0), origin_data.get("y", 0), origin_data.get("z", 0))
				return Transform3D(basis, origin)
		TYPE_OBJECT:
			if value is String and value.begins_with("res://"):
				var res = load(value)
				if res:
					return res

	return value
