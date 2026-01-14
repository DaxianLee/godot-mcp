@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## 3D Geometry tools for Godot MCP
## Provides CSG, GridMap, and MultiMesh operations


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "csg",
			"description": """CSG (Constructive Solid Geometry): Create and combine 3D primitives.

ACTIONS:
- create: Create a CSG primitive node
- get_info: Get CSG node information
- set_operation: Set CSG operation mode
- set_material: Assign material to CSG
- set_size: Set primitive dimensions
- set_use_collision: Enable/disable collision
- bake_mesh: Convert CSG to static mesh
- list: List all CSG nodes in scene

CSG TYPES:
- csg_box_3d: Box primitive
- csg_sphere_3d: Sphere primitive
- csg_cylinder_3d: Cylinder primitive
- csg_torus_3d: Torus/donut primitive
- csg_polygon_3d: Extruded polygon
- csg_mesh_3d: Mesh-based CSG
- csg_combiner_3d: Combines child CSG nodes

OPERATIONS:
- union: Combine shapes (default)
- intersection: Keep only overlapping parts
- subtraction: Cut one shape from another

EXAMPLES:
- Create box: {"action": "create", "type": "csg_box_3d", "parent": "/root/Scene"}
- Set operation: {"action": "set_operation", "path": "/root/CSGBox3D", "operation": "subtraction"}
- Set size: {"action": "set_size", "path": "/root/CSGBox3D", "size": {"x": 2, "y": 1, "z": 2}}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_operation", "set_material", "set_size", "set_use_collision", "bake_mesh", "list"],
						"description": "CSG action"
					},
					"path": {
						"type": "string",
						"description": "CSG node path"
					},
					"parent": {
						"type": "string",
						"description": "Parent node path"
					},
					"name": {
						"type": "string",
						"description": "Node name"
					},
					"type": {
						"type": "string",
						"enum": ["csg_box_3d", "csg_sphere_3d", "csg_cylinder_3d", "csg_torus_3d", "csg_polygon_3d", "csg_mesh_3d", "csg_combiner_3d"],
						"description": "CSG type"
					},
					"operation": {
						"type": "string",
						"enum": ["union", "intersection", "subtraction"],
						"description": "CSG operation"
					},
					"material": {
						"type": "string",
						"description": "Material resource path"
					},
					"size": {
						"type": "object",
						"description": "Dimensions {x, y, z}"
					},
					"radius": {
						"type": "number",
						"description": "Radius for sphere/cylinder/torus"
					},
					"height": {
						"type": "number",
						"description": "Height for cylinder"
					},
					"use_collision": {
						"type": "boolean",
						"description": "Enable collision"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "gridmap",
			"description": """GRIDMAP: 3D tile-based level design.

ACTIONS:
- create: Create a GridMap node
- get_info: Get GridMap information
- set_mesh_library: Assign MeshLibrary
- get_cell: Get cell item at position
- set_cell: Place item at cell position
- erase_cell: Remove item at cell position
- clear: Clear all cells
- get_used_cells: Get all cells with items
- get_used_cells_by_item: Get cells with specific item
- get_meshes: Get mesh instances in GridMap
- set_cell_size: Set cell size

ORIENTATION:
- Cell orientation is specified as an integer (0-23)
- Common orientations: 0=identity, 10=rotate_y_90, 16=rotate_y_180

EXAMPLES:
- Create GridMap: {"action": "create", "parent": "/root/Scene"}
- Set cell: {"action": "set_cell", "path": "/root/GridMap", "x": 0, "y": 0, "z": 0, "item": 0}
- Get cell: {"action": "get_cell", "path": "/root/GridMap", "x": 0, "y": 0, "z": 0}
- Erase cell: {"action": "erase_cell", "path": "/root/GridMap", "x": 0, "y": 0, "z": 0}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_mesh_library", "get_cell", "set_cell", "erase_cell", "clear", "get_used_cells", "get_used_cells_by_item", "get_meshes", "set_cell_size"],
						"description": "GridMap action"
					},
					"path": {
						"type": "string",
						"description": "GridMap node path"
					},
					"parent": {
						"type": "string",
						"description": "Parent node path"
					},
					"name": {
						"type": "string",
						"description": "Node name"
					},
					"library": {
						"type": "string",
						"description": "MeshLibrary resource path"
					},
					"x": {
						"type": "integer",
						"description": "Cell X coordinate"
					},
					"y": {
						"type": "integer",
						"description": "Cell Y coordinate"
					},
					"z": {
						"type": "integer",
						"description": "Cell Z coordinate"
					},
					"item": {
						"type": "integer",
						"description": "Item index from MeshLibrary"
					},
					"orientation": {
						"type": "integer",
						"description": "Cell orientation (0-23)"
					},
					"cell_size": {
						"type": "object",
						"description": "Cell size {x, y, z}"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "multimesh",
			"description": """MULTIMESH: Efficient rendering of many identical meshes.

ACTIONS:
- create: Create MultiMeshInstance3D
- get_info: Get MultiMesh information
- set_mesh: Set the mesh to instance
- set_instance_count: Set number of instances
- set_transform: Set transform for specific instance
- set_color: Set color for specific instance (requires use_colors)
- set_custom_data: Set custom data for instance
- set_visible_count: Set number of visible instances
- populate_random: Randomly distribute instances in bounds
- clear: Remove all instances

EXAMPLES:
- Create: {"action": "create", "parent": "/root/Scene", "name": "Trees"}
- Set mesh: {"action": "set_mesh", "path": "/root/Trees", "mesh": "res://tree.tres"}
- Set count: {"action": "set_instance_count", "path": "/root/Trees", "count": 100}
- Set transform: {"action": "set_transform", "path": "/root/Trees", "index": 0, "position": {"x": 5, "y": 0, "z": 3}}
- Populate: {"action": "populate_random", "path": "/root/Trees", "count": 50, "bounds": {"min": {"x": -10, "y": 0, "z": -10}, "max": {"x": 10, "y": 0, "z": 10}}}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_mesh", "set_instance_count", "set_transform", "set_color", "set_custom_data", "set_visible_count", "populate_random", "clear"],
						"description": "MultiMesh action"
					},
					"path": {
						"type": "string",
						"description": "MultiMeshInstance3D path"
					},
					"parent": {
						"type": "string",
						"description": "Parent node path"
					},
					"name": {
						"type": "string",
						"description": "Node name"
					},
					"mesh": {
						"type": "string",
						"description": "Mesh resource path"
					},
					"count": {
						"type": "integer",
						"description": "Instance count"
					},
					"index": {
						"type": "integer",
						"description": "Instance index"
					},
					"position": {
						"type": "object",
						"description": "Position {x, y, z}"
					},
					"rotation": {
						"type": "object",
						"description": "Rotation {x, y, z} in degrees"
					},
					"scale": {
						"type": "object",
						"description": "Scale {x, y, z}"
					},
					"color": {
						"type": "object",
						"description": "Color {r, g, b, a}"
					},
					"bounds": {
						"type": "object",
						"description": "Bounds for random population"
					},
					"use_colors": {
						"type": "boolean",
						"description": "Enable per-instance colors"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"csg":
			return _execute_csg(args)
		"gridmap":
			return _execute_gridmap(args)
		"multimesh":
			return _execute_multimesh(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# CSG Implementation
func _execute_csg(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_csg(args)
		"get_info":
			return _get_csg_info(args.get("path", ""))
		"set_operation":
			return _set_csg_operation(args.get("path", ""), args.get("operation", ""))
		"set_material":
			return _set_csg_material(args.get("path", ""), args.get("material", ""))
		"set_size":
			return _set_csg_size(args)
		"set_use_collision":
			return _set_csg_collision(args.get("path", ""), args.get("use_collision", true))
		"bake_mesh":
			return _bake_csg_mesh(args.get("path", ""))
		"list":
			return _list_csg_nodes()
		_:
			return _error("Unknown action: %s" % action)


func _create_csg(args: Dictionary) -> Dictionary:
	var csg_type = args.get("type", "csg_box_3d")
	var parent_path = args.get("parent", "")
	var node_name = args.get("name", "")

	if parent_path.is_empty():
		return _error("Parent path is required")

	var parent = _find_node_by_path(parent_path)
	if not parent:
		return _error("Parent not found: %s" % parent_path)

	var csg: CSGShape3D
	match csg_type:
		"csg_box_3d":
			csg = CSGBox3D.new()
		"csg_sphere_3d":
			csg = CSGSphere3D.new()
		"csg_cylinder_3d":
			csg = CSGCylinder3D.new()
		"csg_torus_3d":
			csg = CSGTorus3D.new()
		"csg_polygon_3d":
			csg = CSGPolygon3D.new()
		"csg_mesh_3d":
			csg = CSGMesh3D.new()
		"csg_combiner_3d":
			csg = CSGCombiner3D.new()
		_:
			return _error("Unknown CSG type: %s" % csg_type)

	if node_name.is_empty():
		node_name = csg_type.to_pascal_case()
	csg.name = node_name

	parent.add_child(csg)
	csg.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(csg),
		"type": csg_type,
		"name": node_name
	}, "CSG node created")


func _get_csg_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is CSGShape3D:
		return _error("CSG node not found: %s" % path)

	var info = {
		"path": path,
		"type": node.get_class(),
		"operation": node.operation,
		"use_collision": node.use_collision,
		"has_material": node.material != null
	}

	if node is CSGBox3D:
		info["size"] = _serialize_value(node.size)
	elif node is CSGSphere3D:
		info["radius"] = node.radius
		info["rings"] = node.rings
		info["radial_segments"] = node.radial_segments
	elif node is CSGCylinder3D:
		info["radius"] = node.radius
		info["height"] = node.height
		info["sides"] = node.sides
	elif node is CSGTorus3D:
		info["inner_radius"] = node.inner_radius
		info["outer_radius"] = node.outer_radius

	return _success(info)


func _set_csg_operation(path: String, operation: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is CSGShape3D:
		return _error("CSG node not found: %s" % path)

	match operation:
		"union":
			node.operation = CSGShape3D.OPERATION_UNION
		"intersection":
			node.operation = CSGShape3D.OPERATION_INTERSECTION
		"subtraction":
			node.operation = CSGShape3D.OPERATION_SUBTRACTION
		_:
			return _error("Unknown operation: %s" % operation)

	return _success({
		"path": path,
		"operation": operation
	}, "CSG operation set")


func _set_csg_material(path: String, material_path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is CSGShape3D:
		return _error("CSG node not found: %s" % path)

	if material_path.is_empty():
		node.material = null
	else:
		var material = load(material_path)
		if not material:
			return _error("Failed to load material: %s" % material_path)
		node.material = material

	return _success({
		"path": path,
		"material": material_path
	}, "Material set")


func _set_csg_size(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is CSGShape3D:
		return _error("CSG node not found: %s" % path)

	if node is CSGBox3D:
		var size = args.get("size", {})
		node.size = Vector3(size.get("x", node.size.x), size.get("y", node.size.y), size.get("z", node.size.z))
	elif node is CSGSphere3D:
		if args.has("radius"):
			node.radius = args.get("radius")
	elif node is CSGCylinder3D:
		if args.has("radius"):
			node.radius = args.get("radius")
		if args.has("height"):
			node.height = args.get("height")
	elif node is CSGTorus3D:
		if args.has("inner_radius"):
			node.inner_radius = args.get("inner_radius")
		if args.has("outer_radius"):
			node.outer_radius = args.get("outer_radius")
	else:
		return _error("Size not applicable for this CSG type")

	return _success({
		"path": path
	}, "Size updated")


func _set_csg_collision(path: String, use_collision: bool) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is CSGShape3D:
		return _error("CSG node not found: %s" % path)

	node.use_collision = use_collision

	return _success({
		"path": path,
		"use_collision": use_collision
	}, "Collision %s" % ("enabled" if use_collision else "disabled"))


func _bake_csg_mesh(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is CSGShape3D:
		return _error("CSG node not found: %s" % path)

	var meshes = node.get_meshes()
	if meshes.is_empty():
		return _error("No mesh to bake")

	# Create MeshInstance3D from baked mesh
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = node.name + "_Baked"
	mesh_instance.mesh = meshes[1]  # [0] is transform, [1] is mesh
	mesh_instance.transform = meshes[0]

	node.get_parent().add_child(mesh_instance)
	mesh_instance.owner = _get_edited_scene_root()

	return _success({
		"original": path,
		"baked_path": _get_scene_path(mesh_instance)
	}, "CSG baked to mesh")


func _list_csg_nodes() -> Dictionary:
	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var nodes: Array[Dictionary] = []
	_find_csg_nodes(root, nodes)

	return _success({
		"count": nodes.size(),
		"nodes": nodes
	})


func _find_csg_nodes(node: Node, result: Array[Dictionary]) -> void:
	if node is CSGShape3D:
		result.append({
			"path": _get_scene_path(node),
			"type": node.get_class(),
			"operation": node.operation
		})

	for child in node.get_children():
		_find_csg_nodes(child, result)


# GridMap Implementation
func _execute_gridmap(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_gridmap(args)
		"get_info":
			return _get_gridmap_info(args.get("path", ""))
		"set_mesh_library":
			return _set_mesh_library(args.get("path", ""), args.get("library", ""))
		"get_cell":
			return _get_gridmap_cell(args.get("path", ""), args.get("x", 0), args.get("y", 0), args.get("z", 0))
		"set_cell":
			return _set_gridmap_cell(args)
		"erase_cell":
			return _erase_gridmap_cell(args.get("path", ""), args.get("x", 0), args.get("y", 0), args.get("z", 0))
		"clear":
			return _clear_gridmap(args.get("path", ""))
		"get_used_cells":
			return _get_used_cells(args.get("path", ""))
		"get_used_cells_by_item":
			return _get_used_cells_by_item(args.get("path", ""), args.get("item", 0))
		"set_cell_size":
			return _set_cell_size(args.get("path", ""), args.get("cell_size", {}))
		_:
			return _error("Unknown action: %s" % action)


func _create_gridmap(args: Dictionary) -> Dictionary:
	var parent_path = args.get("parent", "")
	var node_name = args.get("name", "GridMap")

	if parent_path.is_empty():
		return _error("Parent path is required")

	var parent = _find_node_by_path(parent_path)
	if not parent:
		return _error("Parent not found: %s" % parent_path)

	var gridmap = GridMap.new()
	gridmap.name = node_name

	parent.add_child(gridmap)
	gridmap.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(gridmap),
		"name": node_name
	}, "GridMap created")


func _get_gridmap_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is GridMap:
		return _error("GridMap not found: %s" % path)

	return _success({
		"path": path,
		"cell_size": _serialize_value(node.cell_size),
		"cell_octant_size": node.cell_octant_size,
		"has_mesh_library": node.mesh_library != null,
		"used_cells_count": node.get_used_cells().size()
	})


func _set_mesh_library(path: String, library_path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is GridMap:
		return _error("GridMap not found: %s" % path)

	if library_path.is_empty():
		node.mesh_library = null
	else:
		var library = load(library_path)
		if not library or not library is MeshLibrary:
			return _error("Failed to load MeshLibrary: %s" % library_path)
		node.mesh_library = library

	return _success({
		"path": path,
		"library": library_path
	}, "MeshLibrary set")


func _get_gridmap_cell(path: String, x: int, y: int, z: int) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is GridMap:
		return _error("GridMap not found: %s" % path)

	var item = node.get_cell_item(Vector3i(x, y, z))
	var orientation = node.get_cell_item_orientation(Vector3i(x, y, z))

	return _success({
		"path": path,
		"position": {"x": x, "y": y, "z": z},
		"item": item,
		"orientation": orientation,
		"empty": item == GridMap.INVALID_CELL_ITEM
	})


func _set_gridmap_cell(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var x = args.get("x", 0)
	var y = args.get("y", 0)
	var z = args.get("z", 0)
	var item = args.get("item", 0)
	var orientation = args.get("orientation", 0)

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is GridMap:
		return _error("GridMap not found: %s" % path)

	node.set_cell_item(Vector3i(x, y, z), item, orientation)

	return _success({
		"path": path,
		"position": {"x": x, "y": y, "z": z},
		"item": item,
		"orientation": orientation
	}, "Cell set")


func _erase_gridmap_cell(path: String, x: int, y: int, z: int) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is GridMap:
		return _error("GridMap not found: %s" % path)

	node.set_cell_item(Vector3i(x, y, z), GridMap.INVALID_CELL_ITEM)

	return _success({
		"path": path,
		"position": {"x": x, "y": y, "z": z}
	}, "Cell erased")


func _clear_gridmap(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is GridMap:
		return _error("GridMap not found: %s" % path)

	node.clear()

	return _success({
		"path": path
	}, "GridMap cleared")


func _get_used_cells(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is GridMap:
		return _error("GridMap not found: %s" % path)

	var cells = node.get_used_cells()
	var cell_list: Array[Dictionary] = []

	for cell in cells:
		cell_list.append({
			"x": cell.x,
			"y": cell.y,
			"z": cell.z,
			"item": node.get_cell_item(cell)
		})

	return _success({
		"path": path,
		"count": cell_list.size(),
		"cells": cell_list
	})


func _get_used_cells_by_item(path: String, item: int) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is GridMap:
		return _error("GridMap not found: %s" % path)

	var cells = node.get_used_cells_by_item(item)
	var cell_list: Array[Dictionary] = []

	for cell in cells:
		cell_list.append({"x": cell.x, "y": cell.y, "z": cell.z})

	return _success({
		"path": path,
		"item": item,
		"count": cell_list.size(),
		"cells": cell_list
	})


func _set_cell_size(path: String, cell_size: Dictionary) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is GridMap:
		return _error("GridMap not found: %s" % path)

	node.cell_size = Vector3(
		cell_size.get("x", node.cell_size.x),
		cell_size.get("y", node.cell_size.y),
		cell_size.get("z", node.cell_size.z)
	)

	return _success({
		"path": path,
		"cell_size": _serialize_value(node.cell_size)
	}, "Cell size set")


# MultiMesh Implementation
func _execute_multimesh(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_multimesh(args)
		"get_info":
			return _get_multimesh_info(args.get("path", ""))
		"set_mesh":
			return _set_multimesh_mesh(args.get("path", ""), args.get("mesh", ""))
		"set_instance_count":
			return _set_instance_count(args.get("path", ""), args.get("count", 0), args.get("use_colors", false))
		"set_transform":
			return _set_instance_transform(args)
		"set_color":
			return _set_instance_color(args)
		"set_visible_count":
			return _set_visible_count(args.get("path", ""), args.get("count", -1))
		"populate_random":
			return _populate_random(args)
		"clear":
			return _clear_multimesh(args.get("path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _create_multimesh(args: Dictionary) -> Dictionary:
	var parent_path = args.get("parent", "")
	var node_name = args.get("name", "MultiMeshInstance3D")

	if parent_path.is_empty():
		return _error("Parent path is required")

	var parent = _find_node_by_path(parent_path)
	if not parent:
		return _error("Parent not found: %s" % parent_path)

	var multi_instance = MultiMeshInstance3D.new()
	multi_instance.name = node_name

	var multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_instance.multimesh = multimesh

	parent.add_child(multi_instance)
	multi_instance.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(multi_instance),
		"name": node_name
	}, "MultiMeshInstance3D created")


func _get_multimesh_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is MultiMeshInstance3D:
		return _error("MultiMeshInstance3D not found: %s" % path)

	if not node.multimesh:
		return _error("No MultiMesh assigned")

	var mm = node.multimesh

	return _success({
		"path": path,
		"instance_count": mm.instance_count,
		"visible_instance_count": mm.visible_instance_count,
		"has_mesh": mm.mesh != null,
		"use_colors": mm.use_colors,
		"use_custom_data": mm.use_custom_data,
		"transform_format": mm.transform_format
	})


func _set_multimesh_mesh(path: String, mesh_path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is MultiMeshInstance3D:
		return _error("MultiMeshInstance3D not found: %s" % path)

	if not node.multimesh:
		node.multimesh = MultiMesh.new()

	if mesh_path.is_empty():
		node.multimesh.mesh = null
	else:
		var mesh = load(mesh_path)
		if not mesh:
			return _error("Failed to load mesh: %s" % mesh_path)
		node.multimesh.mesh = mesh

	return _success({
		"path": path,
		"mesh": mesh_path
	}, "Mesh set")


func _set_instance_count(path: String, count: int, use_colors: bool) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is MultiMeshInstance3D:
		return _error("MultiMeshInstance3D not found: %s" % path)

	if not node.multimesh:
		node.multimesh = MultiMesh.new()

	node.multimesh.use_colors = use_colors
	node.multimesh.instance_count = count

	return _success({
		"path": path,
		"instance_count": count,
		"use_colors": use_colors
	}, "Instance count set")


func _set_instance_transform(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var index = args.get("index", 0)

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is MultiMeshInstance3D or not node.multimesh:
		return _error("MultiMeshInstance3D not found: %s" % path)

	var mm = node.multimesh
	if index < 0 or index >= mm.instance_count:
		return _error("Index out of range")

	var transform = Transform3D()

	# Apply position
	if args.has("position"):
		var pos = args.get("position")
		transform.origin = Vector3(pos.get("x", 0), pos.get("y", 0), pos.get("z", 0))

	# Apply rotation
	if args.has("rotation"):
		var rot = args.get("rotation")
		transform.basis = transform.basis.rotated(Vector3.RIGHT, deg_to_rad(rot.get("x", 0)))
		transform.basis = transform.basis.rotated(Vector3.UP, deg_to_rad(rot.get("y", 0)))
		transform.basis = transform.basis.rotated(Vector3.FORWARD, deg_to_rad(rot.get("z", 0)))

	# Apply scale
	if args.has("scale"):
		var scl = args.get("scale")
		transform.basis = transform.basis.scaled(Vector3(scl.get("x", 1), scl.get("y", 1), scl.get("z", 1)))

	mm.set_instance_transform(index, transform)

	return _success({
		"path": path,
		"index": index
	}, "Instance transform set")


func _set_instance_color(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var index = args.get("index", 0)
	var color_dict = args.get("color", {})

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is MultiMeshInstance3D or not node.multimesh:
		return _error("MultiMeshInstance3D not found: %s" % path)

	var mm = node.multimesh
	if not mm.use_colors:
		return _error("MultiMesh does not use colors. Set use_colors=true when setting instance count.")

	if index < 0 or index >= mm.instance_count:
		return _error("Index out of range")

	var color = Color(
		color_dict.get("r", 1),
		color_dict.get("g", 1),
		color_dict.get("b", 1),
		color_dict.get("a", 1)
	)

	mm.set_instance_color(index, color)

	return _success({
		"path": path,
		"index": index,
		"color": _serialize_value(color)
	}, "Instance color set")


func _set_visible_count(path: String, count: int) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is MultiMeshInstance3D or not node.multimesh:
		return _error("MultiMeshInstance3D not found: %s" % path)

	node.multimesh.visible_instance_count = count

	return _success({
		"path": path,
		"visible_instance_count": count
	}, "Visible count set")


func _populate_random(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var count = args.get("count", 10)
	var bounds = args.get("bounds", {})

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is MultiMeshInstance3D or not node.multimesh:
		return _error("MultiMeshInstance3D not found: %s" % path)

	var mm = node.multimesh
	mm.instance_count = count

	var min_bounds = bounds.get("min", {"x": -10, "y": 0, "z": -10})
	var max_bounds = bounds.get("max", {"x": 10, "y": 0, "z": 10})

	for i in count:
		var transform = Transform3D()
		transform.origin = Vector3(
			randf_range(min_bounds.get("x", -10), max_bounds.get("x", 10)),
			randf_range(min_bounds.get("y", 0), max_bounds.get("y", 0)),
			randf_range(min_bounds.get("z", -10), max_bounds.get("z", 10))
		)

		# Random Y rotation
		transform.basis = transform.basis.rotated(Vector3.UP, randf() * TAU)

		mm.set_instance_transform(i, transform)

	return _success({
		"path": path,
		"count": count,
		"bounds": bounds
	}, "Instances populated randomly")


func _clear_multimesh(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node or not node is MultiMeshInstance3D or not node.multimesh:
		return _error("MultiMeshInstance3D not found: %s" % path)

	node.multimesh.instance_count = 0

	return _success({
		"path": path
	}, "MultiMesh cleared")
