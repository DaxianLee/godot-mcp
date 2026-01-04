@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Shader tools for Godot MCP
## Provides shader creation, editing, and visual shader operations


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "shader",
			"description": """SHADER OPERATIONS: Create and manage shader files.

ACTIONS:
- create: Create a new shader file
- read: Read shader code
- write: Write shader code
- get_info: Get shader information (uniforms, modes)
- get_uniforms: Get all uniform parameters
- set_default: Set a uniform's default value

SHADER TYPES:
- spatial: 3D shaders (Mesh materials)
- canvas_item: 2D shaders (CanvasItem materials)
- particles: GPU particle shaders
- sky: Sky shaders
- fog: Fog volume shaders

EXAMPLES:
- Create shader: {"action": "create", "path": "res://shaders/custom.gdshader", "type": "spatial"}
- Read shader: {"action": "read", "path": "res://shaders/custom.gdshader"}
- Write shader: {"action": "write", "path": "res://shaders/custom.gdshader", "code": "shader_type spatial;\\n..."}
- Get uniforms: {"action": "get_uniforms", "path": "res://shaders/custom.gdshader"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "read", "write", "get_info", "get_uniforms", "set_default"],
						"description": "Shader action"
					},
					"path": {
						"type": "string",
						"description": "Shader file path (res://...gdshader)"
					},
					"type": {
						"type": "string",
						"enum": ["spatial", "canvas_item", "particles", "sky", "fog"],
						"description": "Shader type for creation"
					},
					"code": {
						"type": "string",
						"description": "Shader code"
					},
					"uniform": {
						"type": "string",
						"description": "Uniform name"
					},
					"value": {
						"description": "Default value for uniform"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "shader_material",
			"description": """SHADER MATERIAL: Manage ShaderMaterial instances.

ACTIONS:
- create: Create a new ShaderMaterial
- get_info: Get material information
- set_shader: Set the shader
- get_param: Get a shader parameter value
- set_param: Set a shader parameter value
- list_params: List all shader parameters
- assign_to_node: Assign to a node

EXAMPLES:
- Create material: {"action": "create", "shader_path": "res://shaders/custom.gdshader"}
- Get param: {"action": "get_param", "path": "res://materials/custom.tres", "param": "albedo_color"}
- Set param: {"action": "set_param", "path": "res://materials/custom.tres", "param": "speed", "value": 2.5}
- Assign to node: {"action": "assign_to_node", "material_path": "res://materials/custom.tres", "node_path": "/root/Mesh", "surface": 0}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_shader", "get_param", "set_param", "list_params", "assign_to_node"],
						"description": "Material action"
					},
					"path": {
						"type": "string",
						"description": "ShaderMaterial resource path"
					},
					"shader_path": {
						"type": "string",
						"description": "Shader file path"
					},
					"material_path": {
						"type": "string",
						"description": "Material path for assignment"
					},
					"node_path": {
						"type": "string",
						"description": "Target node path"
					},
					"surface": {
						"type": "integer",
						"description": "Surface index"
					},
					"param": {
						"type": "string",
						"description": "Parameter name"
					},
					"value": {
						"description": "Parameter value"
					},
					"save_path": {
						"type": "string",
						"description": "Path to save material"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"shader":
			return _execute_shader(args)
		"shader_material":
			return _execute_shader_material(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== SHADER ====================

func _execute_shader(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_shader(args)
		"read":
			return _read_shader(args.get("path", ""))
		"write":
			return _write_shader(args.get("path", ""), args.get("code", ""))
		"get_info":
			return _get_shader_info(args.get("path", ""))
		"get_uniforms":
			return _get_shader_uniforms(args.get("path", ""))
		"set_default":
			return _set_uniform_default(args.get("path", ""), args.get("uniform", ""), args.get("value"))
		_:
			return _error("Unknown action: %s" % action)


func _load_shader(path: String) -> Shader:
	if path.is_empty():
		return null

	if not path.begins_with("res://"):
		path = "res://" + path

	if ResourceLoader.exists(path):
		return load(path) as Shader

	return null


func _create_shader(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var type = args.get("type", "spatial")

	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path
	if not path.ends_with(".gdshader"):
		path += ".gdshader"

	# Generate basic shader template
	var code: String
	match type:
		"spatial":
			code = """shader_type spatial;

// Uniforms
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float roughness : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	ALBEDO = albedo_color.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
}
"""
		"canvas_item":
			code = """shader_type canvas_item;

// Uniforms
uniform vec4 modulate_color : source_color = vec4(1.0);

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = tex_color * modulate_color;
}
"""
		"particles":
			code = """shader_type particles;

uniform float spread : hint_range(0.0, 180.0) = 45.0;
uniform float initial_speed : hint_range(0.0, 100.0) = 10.0;

void start() {
	float angle = (randf() - 0.5) * spread * PI / 180.0;
	VELOCITY = vec3(sin(angle), cos(angle), 0.0) * initial_speed;
}

void process() {
	// Process particles here
}
"""
		"sky":
			code = """shader_type sky;

uniform vec3 sky_color : source_color = vec3(0.4, 0.6, 1.0);
uniform vec3 horizon_color : source_color = vec3(0.8, 0.9, 1.0);
uniform vec3 ground_color : source_color = vec3(0.3, 0.25, 0.2);

void sky() {
	float y = EYEDIR.y;
	if (y > 0.0) {
		COLOR = mix(horizon_color, sky_color, y);
	} else {
		COLOR = mix(horizon_color, ground_color, -y);
	}
}
"""
		"fog":
			code = """shader_type fog;

uniform vec4 fog_color : source_color = vec4(0.5, 0.6, 0.7, 1.0);
uniform float density : hint_range(0.0, 1.0) = 0.1;

void fog() {
	DENSITY = density;
	ALBEDO = fog_color.rgb;
}
"""
		_:
			return _error("Invalid shader type: %s" % type)

	# Write the shader file
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return _error("Failed to create shader file: %s" % path)

	file.store_string(code)
	file.close()

	# Trigger reimport
	var fs = _get_filesystem()
	if fs:
		fs.update_file(path)

	return _success({
		"path": path,
		"type": type
	}, "Shader created")


func _read_shader(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return _error("Failed to read shader: %s" % path)

	var code = file.get_as_text()
	file.close()

	return _success({
		"path": path,
		"code": code,
		"length": code.length()
	})


func _write_shader(path: String, code: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if code.is_empty():
		return _error("Code is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return _error("Failed to write shader: %s" % path)

	file.store_string(code)
	file.close()

	# Trigger reimport
	var fs = _get_filesystem()
	if fs:
		fs.update_file(path)

	return _success({
		"path": path,
		"length": code.length()
	}, "Shader written")


func _get_shader_info(path: String) -> Dictionary:
	var shader = _load_shader(path)
	if not shader:
		return _error("Shader not found: %s" % path)

	var code = shader.code
	var info = {
		"path": path,
		"mode": shader.get_mode()
	}

	# Parse shader type from code
	var type_match = RegEx.new()
	type_match.compile("shader_type\\s+(\\w+)")
	var result = type_match.search(code)
	if result:
		info["type"] = result.get_string(1)

	# Parse render modes
	var modes_match = RegEx.new()
	modes_match.compile("render_mode\\s+([^;]+)")
	result = modes_match.search(code)
	if result:
		info["render_modes"] = result.get_string(1).split(",")

	# Count uniforms
	var uniform_pattern = RegEx.new()
	uniform_pattern.compile("uniform\\s+")
	var matches = uniform_pattern.search_all(code)
	info["uniform_count"] = matches.size()

	# Count functions
	var func_pattern = RegEx.new()
	func_pattern.compile("void\\s+(\\w+)\\s*\\(")
	matches = func_pattern.search_all(code)
	var functions: Array[String] = []
	for m in matches:
		functions.append(m.get_string(1))
	info["functions"] = functions

	return _success(info)


func _get_shader_uniforms(path: String) -> Dictionary:
	var shader = _load_shader(path)
	if not shader:
		return _error("Shader not found: %s" % path)

	var code = shader.code
	var uniforms: Array[Dictionary] = []

	# Parse uniforms with regex
	var uniform_pattern = RegEx.new()
	uniform_pattern.compile("uniform\\s+(\\w+)\\s+(\\w+)\\s*(?::\\s*([^=;]+))?\\s*(?:=\\s*([^;]+))?")

	var matches = uniform_pattern.search_all(code)
	for m in matches:
		var uniform = {
			"type": m.get_string(1),
			"name": m.get_string(2)
		}
		if m.get_string(3):
			uniform["hint"] = m.get_string(3).strip_edges()
		if m.get_string(4):
			uniform["default"] = m.get_string(4).strip_edges()
		uniforms.append(uniform)

	return _success({
		"path": path,
		"count": uniforms.size(),
		"uniforms": uniforms
	})


func _set_uniform_default(path: String, uniform_name: String, value) -> Dictionary:
	if uniform_name.is_empty():
		return _error("Uniform name is required")

	if not path.begins_with("res://"):
		path = "res://" + path

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return _error("Failed to read shader: %s" % path)

	var code = file.get_as_text()
	file.close()

	# Find and update the uniform
	var pattern = RegEx.new()
	pattern.compile("(uniform\\s+\\w+\\s+" + uniform_name + "\\s*(?::[^=;]+)?\\s*=\\s*)([^;]+)")

	var result = pattern.search(code)
	if not result:
		# Try without default value
		pattern.compile("(uniform\\s+\\w+\\s+" + uniform_name + "\\s*(?::[^;]+)?)(;)")
		result = pattern.search(code)
		if result:
			# Add default value
			var new_code = code.substr(0, result.get_start(2)) + " = " + str(value) + code.substr(result.get_start(2))
			code = new_code
		else:
			return _error("Uniform not found: %s" % uniform_name)
	else:
		# Replace existing default value
		code = code.substr(0, result.get_start(2)) + str(value) + code.substr(result.get_end(2))

	# Write back
	file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return _error("Failed to write shader: %s" % path)

	file.store_string(code)
	file.close()

	return _success({
		"uniform": uniform_name,
		"value": value
	}, "Uniform default updated")


# ==================== SHADER MATERIAL ====================

func _execute_shader_material(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_shader_material(args)
		"get_info":
			return _get_shader_material_info(args.get("path", ""))
		"set_shader":
			return _set_material_shader(args.get("path", ""), args.get("shader_path", ""))
		"get_param":
			return _get_shader_param(args.get("path", ""), args.get("param", ""))
		"set_param":
			return _set_shader_param(args.get("path", ""), args.get("param", ""), args.get("value"))
		"list_params":
			return _list_shader_params(args.get("path", ""))
		"assign_to_node":
			return _assign_shader_material(args.get("material_path", ""), args.get("node_path", ""), args.get("surface", 0))
		_:
			return _error("Unknown action: %s" % action)


func _load_shader_material(path: String) -> ShaderMaterial:
	if path.is_empty():
		return null

	# Check if it's a node path
	if path.contains("/"):
		var node = _find_node_by_path(path)
		if node:
			if node is GeometryInstance3D and node.get_surface_override_material(0) is ShaderMaterial:
				return node.get_surface_override_material(0)
			if node is CanvasItem and node.material is ShaderMaterial:
				return node.material

	# Load from resource
	if not path.begins_with("res://"):
		path = "res://" + path

	if ResourceLoader.exists(path):
		return load(path) as ShaderMaterial

	return null


func _create_shader_material(args: Dictionary) -> Dictionary:
	var shader_path = args.get("shader_path", "")
	var save_path = args.get("save_path", "")

	var material = ShaderMaterial.new()

	# Set shader if provided
	if not shader_path.is_empty():
		var shader = _load_shader(shader_path)
		if not shader:
			return _error("Shader not found: %s" % shader_path)
		material.shader = shader

	# Save if path provided
	if not save_path.is_empty():
		if not save_path.begins_with("res://"):
			save_path = "res://" + save_path
		if not save_path.ends_with(".tres") and not save_path.ends_with(".res"):
			save_path += ".tres"

		var error = ResourceSaver.save(material, save_path)
		if error != OK:
			return _error("Failed to save material: %s" % error_string(error))

		return _success({
			"path": save_path,
			"shader": shader_path if not shader_path.is_empty() else null
		}, "ShaderMaterial created and saved")

	return _success({
		"shader": shader_path if not shader_path.is_empty() else null,
		"note": "Material created in memory"
	}, "ShaderMaterial created")


func _get_shader_material_info(path: String) -> Dictionary:
	var material = _load_shader_material(path)
	if not material:
		return _error("ShaderMaterial not found: %s" % path)

	var info = {
		"path": str(material.resource_path) if material.resource_path else null,
		"shader": str(material.shader.resource_path) if material.shader and material.shader.resource_path else null
	}

	# List shader parameters
	if material.shader:
		var params = {}
		for prop in material.get_property_list():
			var prop_name = str(prop.name)
			if prop_name.begins_with("shader_parameter/"):
				var param_name = prop_name.substr(17)
				params[param_name] = _serialize_value(material.get(prop_name))
		info["parameters"] = params

	return _success(info)


func _set_material_shader(path: String, shader_path: String) -> Dictionary:
	var material = _load_shader_material(path)
	if not material:
		return _error("ShaderMaterial not found: %s" % path)

	if shader_path.is_empty():
		material.shader = null
		return _success({"shader": null}, "Shader removed")

	var shader = _load_shader(shader_path)
	if not shader:
		return _error("Shader not found: %s" % shader_path)

	material.shader = shader

	return _success({
		"shader": shader_path
	}, "Shader set")


func _get_shader_param(path: String, param: String) -> Dictionary:
	if param.is_empty():
		return _error("Parameter name is required")

	var material = _load_shader_material(path)
	if not material:
		return _error("ShaderMaterial not found: %s" % path)

	var value = material.get_shader_parameter(param)

	return _success({
		"param": param,
		"value": _serialize_value(value)
	})


func _set_shader_param(path: String, param: String, value) -> Dictionary:
	if param.is_empty():
		return _error("Parameter name is required")

	var material = _load_shader_material(path)
	if not material:
		return _error("ShaderMaterial not found: %s" % path)

	# Handle special types
	if value is Dictionary:
		if value.has("r") and value.has("g") and value.has("b"):
			value = Color(value.get("r", 1), value.get("g", 1), value.get("b", 1), value.get("a", 1))
		elif value.has("x") and value.has("y"):
			if value.has("z"):
				if value.has("w"):
					value = Vector4(value.x, value.y, value.z, value.w)
				else:
					value = Vector3(value.x, value.y, value.z)
			else:
				value = Vector2(value.x, value.y)

	# Handle texture paths
	if value is String and value.begins_with("res://"):
		var texture = load(value)
		if texture:
			value = texture

	material.set_shader_parameter(param, value)

	return _success({
		"param": param,
		"value": _serialize_value(material.get_shader_parameter(param))
	}, "Parameter set")


func _list_shader_params(path: String) -> Dictionary:
	var material = _load_shader_material(path)
	if not material:
		return _error("ShaderMaterial not found: %s" % path)

	if not material.shader:
		return _success({
			"count": 0,
			"parameters": [],
			"note": "No shader assigned"
		})

	var params: Array[Dictionary] = []
	for prop in material.get_property_list():
		var prop_name = str(prop.name)
		if prop_name.begins_with("shader_parameter/"):
			var param_name = prop_name.substr(17)
			params.append({
				"name": param_name,
				"type": _type_to_string(prop.type),
				"value": _serialize_value(material.get(prop_name))
			})

	return _success({
		"count": params.size(),
		"parameters": params
	})


func _assign_shader_material(material_path: String, node_path: String, surface: int) -> Dictionary:
	if material_path.is_empty() or node_path.is_empty():
		return _error("Both material_path and node_path are required")

	var material = _load_shader_material(material_path)
	if not material:
		return _error("ShaderMaterial not found: %s" % material_path)

	var node = _find_node_by_path(node_path)
	if not node:
		return _error("Node not found: %s" % node_path)

	if node is GeometryInstance3D:
		node.set_surface_override_material(surface, material)
		return _success({
			"node": node_path,
			"surface": surface,
			"material": material_path
		}, "Material assigned to surface %d" % surface)

	elif node is CanvasItem and "material" in node:
		node.material = material
		return _success({
			"node": node_path,
			"material": material_path
		}, "Material assigned")

	return _error("Node does not support material assignment")
