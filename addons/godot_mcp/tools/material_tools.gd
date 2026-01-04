@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Material and Mesh tools for Godot MCP
## Provides material creation/editing and mesh operations


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "material",
			"description": """MATERIAL OPERATIONS: Create and manage materials.

ACTIONS:
- create: Create a new material
- get_info: Get material information
- set_property: Set a material property
- get_property: Get a material property
- list_properties: List all material properties
- assign_to_node: Assign material to a node
- duplicate: Duplicate a material
- save: Save material to file

MATERIAL TYPES:
- StandardMaterial3D: PBR material for 3D
- ORMMaterial3D: ORM workflow material
- ShaderMaterial: Custom shader material
- CanvasItemMaterial: 2D material

COMMON PROPERTIES (StandardMaterial3D):
- albedo_color: Base color
- metallic: Metallic value (0-1)
- roughness: Roughness value (0-1)
- emission: Emission color
- normal_scale: Normal map strength

EXAMPLES:
- Create material: {"action": "create", "type": "StandardMaterial3D", "name": "MyMaterial"}
- Get info: {"action": "get_info", "path": "res://materials/metal.tres"}
- Set property: {"action": "set_property", "path": "res://materials/metal.tres", "property": "metallic", "value": 0.9}
- Assign to node: {"action": "assign_to_node", "material_path": "res://materials/metal.tres", "node_path": "/root/Mesh", "surface": 0}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_property", "get_property", "list_properties", "assign_to_node", "duplicate", "save"],
						"description": "Material action"
					},
					"type": {
						"type": "string",
						"enum": ["StandardMaterial3D", "ORMMaterial3D", "ShaderMaterial", "CanvasItemMaterial"],
						"description": "Material type for creation"
					},
					"name": {
						"type": "string",
						"description": "Material name"
					},
					"path": {
						"type": "string",
						"description": "Material resource path"
					},
					"material_path": {
						"type": "string",
						"description": "Material to assign"
					},
					"node_path": {
						"type": "string",
						"description": "Target node path"
					},
					"surface": {
						"type": "integer",
						"description": "Surface index for MeshInstance3D"
					},
					"property": {
						"type": "string",
						"description": "Property name"
					},
					"value": {
						"description": "Property value"
					},
					"save_path": {
						"type": "string",
						"description": "Path to save material"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "mesh",
			"description": """MESH OPERATIONS: Query and manipulate meshes.

ACTIONS:
- get_info: Get mesh information
- list_surfaces: List all surfaces in a mesh
- get_surface_material: Get material assigned to a surface
- set_surface_material: Set surface material override
- create_primitive: Create a primitive mesh
- get_aabb: Get mesh bounding box

PRIMITIVE TYPES:
- box: BoxMesh
- sphere: SphereMesh
- cylinder: CylinderMesh
- capsule: CapsuleMesh
- plane: PlaneMesh
- prism: PrismMesh
- torus: TorusMesh
- quad: QuadMesh

EXAMPLES:
- Get mesh info: {"action": "get_info", "path": "/root/MeshInstance3D"}
- List surfaces: {"action": "list_surfaces", "path": "/root/MeshInstance3D"}
- Set surface material: {"action": "set_surface_material", "path": "/root/MeshInstance3D", "surface": 0, "material_path": "res://materials/metal.tres"}
- Create primitive: {"action": "create_primitive", "type": "sphere", "radius": 0.5, "height": 1.0}
- Get AABB: {"action": "get_aabb", "path": "/root/MeshInstance3D"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_info", "list_surfaces", "get_surface_material", "set_surface_material", "create_primitive", "get_aabb"],
						"description": "Mesh action"
					},
					"path": {
						"type": "string",
						"description": "MeshInstance3D/MeshInstance2D node path"
					},
					"mesh_path": {
						"type": "string",
						"description": "Mesh resource path"
					},
					"type": {
						"type": "string",
						"enum": ["box", "sphere", "cylinder", "capsule", "plane", "prism", "torus", "quad"],
						"description": "Primitive type"
					},
					"surface": {
						"type": "integer",
						"description": "Surface index"
					},
					"material_path": {
						"type": "string",
						"description": "Material resource path"
					},
					"radius": {
						"type": "number",
						"description": "Primitive radius"
					},
					"height": {
						"type": "number",
						"description": "Primitive height"
					},
					"size": {
						"type": "object",
						"description": "Size {x, y, z}"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"material":
			return _execute_material(args)
		"mesh":
			return _execute_mesh(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== MATERIAL ====================

func _execute_material(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_material(args)
		"get_info":
			return _get_material_info(args.get("path", ""))
		"set_property":
			return _set_material_property(args.get("path", ""), args.get("property", ""), args.get("value"))
		"get_property":
			return _get_material_property(args.get("path", ""), args.get("property", ""))
		"list_properties":
			return _list_material_properties(args.get("path", ""))
		"assign_to_node":
			return _assign_material_to_node(args.get("material_path", ""), args.get("node_path", ""), args.get("surface", 0))
		"duplicate":
			return _duplicate_material(args.get("path", ""), args.get("save_path", ""))
		"save":
			return _save_material(args.get("path", ""), args.get("save_path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _load_material(path: String) -> Material:
	if path.is_empty():
		return null

	# Check if it's a node path with material
	if path.contains("/"):
		var node = _find_node_by_path(path)
		if node:
			if node is GeometryInstance3D and node.get_surface_override_material(0):
				return node.get_surface_override_material(0)
			if node is MeshInstance3D and node.mesh:
				return node.mesh.surface_get_material(0) if node.mesh.get_surface_count() > 0 else null
			if node is CanvasItem and "material" in node:
				return node.material

	# Load from resource path
	if not path.begins_with("res://"):
		path = "res://" + path

	if ResourceLoader.exists(path):
		var resource = load(path)
		if resource is Material:
			return resource

	return null


func _create_material(args: Dictionary) -> Dictionary:
	var type_name = args.get("type", "StandardMaterial3D")
	var mat_name = args.get("name", "NewMaterial")

	var material: Material
	match type_name:
		"StandardMaterial3D":
			material = StandardMaterial3D.new()
		"ORMMaterial3D":
			material = ORMMaterial3D.new()
		"ShaderMaterial":
			material = ShaderMaterial.new()
		"CanvasItemMaterial":
			material = CanvasItemMaterial.new()
		_:
			return _error("Invalid material type: %s" % type_name)

	material.resource_name = mat_name

	# Optionally save
	var save_path = args.get("save_path", "")
	if not save_path.is_empty():
		if not save_path.begins_with("res://"):
			save_path = "res://" + save_path
		if not save_path.ends_with(".tres") and not save_path.ends_with(".res"):
			save_path += ".tres"

		var error = ResourceSaver.save(material, save_path)
		if error != OK:
			return _error("Failed to save material: %s" % error_string(error))

		return _success({
			"type": type_name,
			"name": mat_name,
			"path": save_path
		}, "Material created and saved")

	return _success({
		"type": type_name,
		"name": mat_name,
		"note": "Material created in memory. Use 'save' to persist."
	}, "Material created")


func _get_material_info(path: String) -> Dictionary:
	var material = _load_material(path)
	if not material:
		return _error("Material not found: %s" % path)

	var info = {
		"type": str(material.get_class()),
		"name": str(material.resource_name),
		"path": str(material.resource_path) if material.resource_path else null
	}

	# Type-specific info
	if material is StandardMaterial3D or material is ORMMaterial3D:
		info["albedo_color"] = _serialize_value(material.albedo_color)
		info["metallic"] = material.metallic
		info["roughness"] = material.roughness
		info["emission_enabled"] = material.emission_enabled
		if material.emission_enabled:
			info["emission"] = _serialize_value(material.emission)
			info["emission_energy_multiplier"] = material.emission_energy_multiplier
		info["normal_enabled"] = material.normal_enabled
		info["transparency"] = material.transparency
		info["cull_mode"] = material.cull_mode

		# Textures
		info["albedo_texture"] = str(material.albedo_texture.resource_path) if material.albedo_texture else null
		info["metallic_texture"] = str(material.metallic_texture.resource_path) if material.metallic_texture else null
		info["roughness_texture"] = str(material.roughness_texture.resource_path) if material.roughness_texture else null
		info["normal_texture"] = str(material.normal_texture.resource_path) if material.normal_texture else null

	elif material is ShaderMaterial:
		info["shader"] = str(material.shader.resource_path) if material.shader else null
		# List shader params
		if material.shader:
			var params = {}
			for prop in material.get_property_list():
				if str(prop.name).begins_with("shader_parameter/"):
					var param_name = str(prop.name).substr(17)  # Remove prefix
					params[param_name] = material.get(prop.name)
			info["shader_parameters"] = params

	elif material is CanvasItemMaterial:
		info["blend_mode"] = material.blend_mode
		info["light_mode"] = material.light_mode
		info["particles_animation"] = material.particles_animation

	return _success(info)


func _set_material_property(path: String, property: String, value) -> Dictionary:
	if property.is_empty():
		return _error("Property name is required")

	var material = _load_material(path)
	if not material:
		return _error("Material not found: %s" % path)

	# Handle color values
	if value is Dictionary and value.has("r"):
		value = Color(value.get("r", 1), value.get("g", 1), value.get("b", 1), value.get("a", 1))

	# Handle texture paths
	if property.ends_with("_texture") and value is String:
		if value.is_empty():
			value = null
		else:
			if not value.begins_with("res://"):
				value = "res://" + value
			value = load(value)

	# For ShaderMaterial, handle shader_parameter prefix
	if material is ShaderMaterial and not property.begins_with("shader_parameter/"):
		if property in ["shader"]:
			pass  # Keep as is
		else:
			property = "shader_parameter/" + property

	if not property in material:
		return _error("Property not found: %s" % property)

	material.set(property, value)

	return _success({
		"property": property,
		"value": _serialize_value(material.get(property))
	}, "Property set")


func _get_material_property(path: String, property: String) -> Dictionary:
	if property.is_empty():
		return _error("Property name is required")

	var material = _load_material(path)
	if not material:
		return _error("Material not found: %s" % path)

	# For ShaderMaterial, handle shader_parameter prefix
	if material is ShaderMaterial and not property.begins_with("shader_parameter/"):
		if not property in ["shader"]:
			property = "shader_parameter/" + property

	if not property in material:
		return _error("Property not found: %s" % property)

	return _success({
		"property": property,
		"value": _serialize_value(material.get(property))
	})


func _list_material_properties(path: String) -> Dictionary:
	var material = _load_material(path)
	if not material:
		return _error("Material not found: %s" % path)

	var properties: Array[Dictionary] = []
	for prop in material.get_property_list():
		var prop_name = str(prop.name)
		if prop_name.begins_with("_") or prop_name in ["resource_path", "resource_name", "resource_local_to_scene"]:
			continue
		if prop.usage & PROPERTY_USAGE_EDITOR:
			properties.append({
				"name": prop_name,
				"type": _type_to_string(prop.type),
				"value": _serialize_value(material.get(prop_name))
			})

	return _success({
		"type": str(material.get_class()),
		"count": properties.size(),
		"properties": properties
	})


func _assign_material_to_node(material_path: String, node_path: String, surface: int) -> Dictionary:
	if material_path.is_empty() or node_path.is_empty():
		return _error("Both material_path and node_path are required")

	var material = _load_material(material_path)
	if not material:
		return _error("Material not found: %s" % material_path)

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

	elif node is MeshInstance2D:
		node.material = material
		return _success({
			"node": node_path,
			"material": material_path
		}, "Material assigned")

	elif node is CanvasItem and "material" in node:
		node.material = material
		return _success({
			"node": node_path,
			"material": material_path
		}, "Material assigned")

	return _error("Node does not support material assignment")


func _duplicate_material(path: String, save_path: String) -> Dictionary:
	var material = _load_material(path)
	if not material:
		return _error("Material not found: %s" % path)

	var duplicated = material.duplicate(true)

	if not save_path.is_empty():
		if not save_path.begins_with("res://"):
			save_path = "res://" + save_path
		if not save_path.ends_with(".tres") and not save_path.ends_with(".res"):
			save_path += ".tres"

		var error = ResourceSaver.save(duplicated, save_path)
		if error != OK:
			return _error("Failed to save: %s" % error_string(error))

		return _success({
			"original": path,
			"duplicate": save_path
		}, "Material duplicated and saved")

	return _success({
		"original": path,
		"note": "Material duplicated in memory"
	}, "Material duplicated")


func _save_material(path: String, save_path: String) -> Dictionary:
	var material = _load_material(path)
	if not material:
		return _error("Material not found: %s" % path)

	if save_path.is_empty():
		save_path = material.resource_path
	if save_path.is_empty():
		return _error("Save path is required")

	if not save_path.begins_with("res://"):
		save_path = "res://" + save_path
	if not save_path.ends_with(".tres") and not save_path.ends_with(".res"):
		save_path += ".tres"

	var error = ResourceSaver.save(material, save_path)
	if error != OK:
		return _error("Failed to save: %s" % error_string(error))

	return _success({
		"path": save_path
	}, "Material saved")


# ==================== MESH ====================

func _execute_mesh(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get_info":
			return _get_mesh_info(args)
		"list_surfaces":
			return _list_mesh_surfaces(args)
		"get_surface_material":
			return _get_surface_material(args)
		"set_surface_material":
			return _set_surface_material(args)
		"create_primitive":
			return _create_primitive_mesh(args)
		"get_aabb":
			return _get_mesh_aabb(args)
		_:
			return _error("Unknown action: %s" % action)


func _get_mesh(args: Dictionary) -> Mesh:
	var path = args.get("path", "")
	var mesh_path = args.get("mesh_path", "")

	if not path.is_empty():
		var node = _find_node_by_path(path)
		if node is MeshInstance3D and node.mesh:
			return node.mesh
		if node is MeshInstance2D and node.mesh:
			return node.mesh

	if not mesh_path.is_empty():
		if not mesh_path.begins_with("res://"):
			mesh_path = "res://" + mesh_path
		if ResourceLoader.exists(mesh_path):
			return load(mesh_path) as Mesh

	return null


func _get_mesh_info(args: Dictionary) -> Dictionary:
	var mesh = _get_mesh(args)
	if not mesh:
		return _error("Mesh not found")

	var info = {
		"type": str(mesh.get_class()),
		"path": str(mesh.resource_path) if mesh.resource_path else null,
		"surface_count": mesh.get_surface_count()
	}

	# Get AABB
	var aabb = mesh.get_aabb()
	info["aabb"] = {
		"position": _serialize_value(aabb.position),
		"size": _serialize_value(aabb.size)
	}

	# Primitive-specific info
	if mesh is BoxMesh:
		info["size"] = _serialize_value(mesh.size)
	elif mesh is SphereMesh:
		info["radius"] = mesh.radius
		info["height"] = mesh.height
	elif mesh is CylinderMesh:
		info["top_radius"] = mesh.top_radius
		info["bottom_radius"] = mesh.bottom_radius
		info["height"] = mesh.height
	elif mesh is CapsuleMesh:
		info["radius"] = mesh.radius
		info["height"] = mesh.height
	elif mesh is PlaneMesh:
		info["size"] = _serialize_value(mesh.size)
	elif mesh is TorusMesh:
		info["inner_radius"] = mesh.inner_radius
		info["outer_radius"] = mesh.outer_radius

	# Surface info summary
	var surfaces: Array[Dictionary] = []
	for i in range(mesh.get_surface_count()):
		var mat = mesh.surface_get_material(i)
		surfaces.append({
			"index": i,
			"material": str(mat.resource_path) if mat and mat.resource_path else str(mat) if mat else null
		})
	info["surfaces"] = surfaces

	return _success(info)


func _list_mesh_surfaces(args: Dictionary) -> Dictionary:
	var mesh = _get_mesh(args)
	if not mesh:
		return _error("Mesh not found")

	var surfaces: Array[Dictionary] = []
	for i in range(mesh.get_surface_count()):
		var mat = mesh.surface_get_material(i)
		var surface_info = {
			"index": i,
			"primitive_type": mesh.surface_get_primitive_type(i),
			"material": null
		}

		if mat:
			surface_info["material"] = {
				"type": str(mat.get_class()),
				"path": str(mat.resource_path) if mat.resource_path else null
			}

		surfaces.append(surface_info)

	return _success({
		"count": surfaces.size(),
		"surfaces": surfaces
	})


func _get_surface_material(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var surface = args.get("surface", 0)

	if path.is_empty():
		return _error("Node path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var material: Material = null

	if node is GeometryInstance3D:
		# First check override
		material = node.get_surface_override_material(surface)
		if not material and node is MeshInstance3D and node.mesh:
			if surface < node.mesh.get_surface_count():
				material = node.mesh.surface_get_material(surface)

	if material:
		return _success({
			"surface": surface,
			"material": {
				"type": str(material.get_class()),
				"path": str(material.resource_path) if material.resource_path else null
			}
		})

	return _success({
		"surface": surface,
		"material": null
	})


func _set_surface_material(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var surface = args.get("surface", 0)
	var material_path = args.get("material_path", "")

	if path.is_empty():
		return _error("Node path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is GeometryInstance3D:
		return _error("Node is not a GeometryInstance3D")

	var material: Material = null
	if not material_path.is_empty():
		material = _load_material(material_path)
		if not material:
			return _error("Material not found: %s" % material_path)

	node.set_surface_override_material(surface, material)

	return _success({
		"node": path,
		"surface": surface,
		"material": material_path if material else null
	}, "Surface material set")


func _create_primitive_mesh(args: Dictionary) -> Dictionary:
	var type = args.get("type", "box")
	var mesh: Mesh

	match type:
		"box":
			var m = BoxMesh.new()
			var size = args.get("size", {"x": 1, "y": 1, "z": 1})
			m.size = Vector3(size.get("x", 1), size.get("y", 1), size.get("z", 1))
			mesh = m

		"sphere":
			var m = SphereMesh.new()
			m.radius = args.get("radius", 0.5)
			m.height = args.get("height", 1.0)
			mesh = m

		"cylinder":
			var m = CylinderMesh.new()
			m.top_radius = args.get("top_radius", args.get("radius", 0.5))
			m.bottom_radius = args.get("bottom_radius", args.get("radius", 0.5))
			m.height = args.get("height", 2.0)
			mesh = m

		"capsule":
			var m = CapsuleMesh.new()
			m.radius = args.get("radius", 0.5)
			m.height = args.get("height", 2.0)
			mesh = m

		"plane":
			var m = PlaneMesh.new()
			var size = args.get("size", {"x": 2, "y": 2})
			m.size = Vector2(size.get("x", 2), size.get("y", 2))
			mesh = m

		"prism":
			var m = PrismMesh.new()
			m.left_to_right = args.get("left_to_right", 0.5)
			var size = args.get("size", {"x": 1, "y": 1, "z": 1})
			m.size = Vector3(size.get("x", 1), size.get("y", 1), size.get("z", 1))
			mesh = m

		"torus":
			var m = TorusMesh.new()
			m.inner_radius = args.get("inner_radius", 0.5)
			m.outer_radius = args.get("outer_radius", 1.0)
			mesh = m

		"quad":
			var m = QuadMesh.new()
			var size = args.get("size", {"x": 1, "y": 1})
			m.size = Vector2(size.get("x", 1), size.get("y", 1))
			mesh = m

		_:
			return _error("Invalid primitive type: %s" % type)

	# Optionally save
	var save_path = args.get("save_path", "")
	if not save_path.is_empty():
		if not save_path.begins_with("res://"):
			save_path = "res://" + save_path
		if not save_path.ends_with(".tres") and not save_path.ends_with(".res"):
			save_path += ".tres"

		var error = ResourceSaver.save(mesh, save_path)
		if error != OK:
			return _error("Failed to save: %s" % error_string(error))

		return _success({
			"type": type,
			"mesh_type": str(mesh.get_class()),
			"path": save_path
		}, "Primitive mesh created and saved")

	# Optionally assign to node
	var node_path = args.get("node_path", "")
	if not node_path.is_empty():
		var node = _find_node_by_path(node_path)
		if node is MeshInstance3D:
			node.mesh = mesh
			return _success({
				"type": type,
				"mesh_type": str(mesh.get_class()),
				"assigned_to": node_path
			}, "Primitive mesh created and assigned")
		elif node is MeshInstance2D:
			node.mesh = mesh
			return _success({
				"type": type,
				"mesh_type": str(mesh.get_class()),
				"assigned_to": node_path
			}, "Primitive mesh created and assigned")

	return _success({
		"type": type,
		"mesh_type": str(mesh.get_class()),
		"note": "Mesh created in memory"
	}, "Primitive mesh created")


func _get_mesh_aabb(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Node path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var aabb: AABB

	if node is MeshInstance3D and node.mesh:
		aabb = node.mesh.get_aabb()
	elif node is VisualInstance3D:
		aabb = node.get_aabb()
	else:
		return _error("Node does not have an AABB")

	return _success({
		"aabb": {
			"position": _serialize_value(aabb.position),
			"size": _serialize_value(aabb.size),
			"end": _serialize_value(aabb.end)
		}
	})
