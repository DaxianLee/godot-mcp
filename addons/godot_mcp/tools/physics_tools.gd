@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Physics tools for Godot MCP
## Provides physics body, collision, joint, and query operations


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "physics_body",
			"description": """PHYSICS BODIES: Create and configure physics bodies.

ACTIONS:
- create: Create a physics body (specify 2D or 3D type explicitly)
- get_info: Get physics body information
- set_mode: Set body mode (static, kinematic, rigid, rigid_linear)
- set_mass: Set body mass
- set_gravity_scale: Set gravity scale
- set_linear_velocity: Set linear velocity
- set_angular_velocity: Set angular velocity
- apply_force: Apply force to body
- apply_impulse: Apply impulse to body
- set_layers: Set collision layer
- set_mask: Set collision mask
- freeze: Freeze/unfreeze body

BODY TYPES (3D):
- rigid_body_3d: Dynamic physics body with mass
- character_body_3d: Kinematic body for player/NPC movement
- static_body_3d: Immovable collision body (walls, floors)
- area_3d: Detection zone (triggers, no collision response)

BODY TYPES (2D):
- rigid_body_2d: Dynamic physics body with mass
- character_body_2d: Kinematic body for player/NPC movement
- static_body_2d: Immovable collision body (platforms, walls)
- area_2d: Detection zone (triggers, no collision response)

EXAMPLES (3D):
- Create RigidBody3D: {"action": "create", "type": "rigid_body_3d", "parent": "Scene", "name": "Ball"}
- Create CharacterBody3D: {"action": "create", "type": "character_body_3d", "parent": "Scene", "name": "Player"}
- Set mass: {"action": "set_mass", "path": "Ball", "mass": 5.0}
- Apply force 3D: {"action": "apply_force", "path": "Ball", "force": {"x": 0, "y": 100, "z": 0}}

EXAMPLES (2D):
- Create RigidBody2D: {"action": "create", "type": "rigid_body_2d", "parent": "Scene", "name": "Ball"}
- Create CharacterBody2D: {"action": "create", "type": "character_body_2d", "parent": "Scene", "name": "Player"}
- Apply force 2D: {"action": "apply_force", "path": "Ball", "force": {"x": 0, "y": -500}}
- Apply impulse 2D: {"action": "apply_impulse", "path": "Ball", "impulse": {"x": 100, "y": 0}}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_mode", "set_mass", "set_gravity_scale", "set_linear_velocity", "set_angular_velocity", "apply_force", "apply_impulse", "set_layers", "set_mask", "freeze"],
						"description": "Physics body action"
					},
					"path": {
						"type": "string",
						"description": "Node path of physics body"
					},
					"parent": {
						"type": "string",
						"description": "Parent node path for creation"
					},
					"name": {
						"type": "string",
						"description": "Node name for creation"
					},
					"type": {
						"type": "string",
						"enum": ["rigid_body_2d", "rigid_body_3d", "character_body_2d", "character_body_3d", "static_body_2d", "static_body_3d", "area_2d", "area_3d"],
						"description": "Body type to create"
					},
					"mode": {
						"type": "string",
						"enum": ["static", "kinematic", "rigid", "rigid_linear"],
						"description": "Body freeze mode"
					},
					"mass": {
						"type": "number",
						"description": "Body mass"
					},
					"gravity_scale": {
						"type": "number",
						"description": "Gravity scale multiplier"
					},
					"velocity": {
						"type": "object",
						"description": "Velocity vector {x, y} or {x, y, z}"
					},
					"force": {
						"type": "object",
						"description": "Force vector"
					},
					"impulse": {
						"type": "object",
						"description": "Impulse vector"
					},
					"position": {
						"type": "object",
						"description": "Position to apply force/impulse"
					},
					"layers": {
						"type": "integer",
						"description": "Collision layer bitmask"
					},
					"mask": {
						"type": "integer",
						"description": "Collision mask bitmask"
					},
					"frozen": {
						"type": "boolean",
						"description": "Freeze state"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "collision_shape",
			"description": """COLLISION SHAPES: Manage collision shapes for physics bodies.

ACTIONS:
- create: Create a collision shape (auto-detects 2D/3D based on parent)
- get_info: Get shape information
- set_shape: Set shape resource
- set_disabled: Enable/disable shape
- create_box: Create box shape (BoxShape3D or RectangleShape2D)
- create_sphere: Create sphere shape (SphereShape3D or CircleShape2D)
- create_capsule: Create capsule shape
- create_cylinder: Create cylinder shape (3D only)
- create_polygon: Create polygon shape (2D only)
- set_size: Set shape size
- make_convex_from_siblings: Create convex shape from sibling meshes

MODE DETECTION:
- Auto-detects 2D/3D based on parent node type (Node2D -> 2D, Node3D -> 3D)
- Use "mode": "2d" or "mode": "3d" to override auto-detection

SHAPE TYPES (3D):
- BoxShape3D, SphereShape3D, CapsuleShape3D, CylinderShape3D
- ConvexPolygonShape3D, ConcavePolygonShape3D, HeightMapShape3D

SHAPE TYPES (2D):
- RectangleShape2D, CircleShape2D, CapsuleShape2D
- ConvexPolygonShape2D, ConcavePolygonShape2D, SegmentShape2D

EXAMPLES (3D):
- Create 3D shape (auto): {"action": "create", "parent": "Player3D"}
- Create 3D shape (explicit): {"action": "create", "parent": "Player", "mode": "3d"}
- Create sphere 3D: {"action": "create_sphere", "path": "Ball/CollisionShape3D", "radius": 0.5}
- Create box 3D: {"action": "create_box", "path": "Box/CollisionShape3D", "size": {"x": 1, "y": 1, "z": 1}}

EXAMPLES (2D):
- Create 2D shape (auto): {"action": "create", "parent": "Player2D"}
- Create 2D shape (explicit): {"action": "create", "parent": "Player", "mode": "2d"}
- Create circle 2D: {"action": "create_sphere", "path": "Ball/CollisionShape2D", "radius": 32}
- Create rect 2D: {"action": "create_box", "path": "Box/CollisionShape2D", "size": {"x": 64, "y": 64}}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_shape", "set_disabled", "create_box", "create_sphere", "create_capsule", "create_cylinder", "create_polygon", "set_size", "make_convex_from_siblings"],
						"description": "Collision shape action"
					},
					"path": {
						"type": "string",
						"description": "CollisionShape node path"
					},
					"parent": {
						"type": "string",
						"description": "Parent node path for creation"
					},
					"name": {
						"type": "string",
						"description": "Node name"
					},
					"mode": {
						"type": "string",
						"enum": ["2d", "3d"],
						"description": "2D or 3D mode"
					},
					"radius": {
						"type": "number",
						"description": "Sphere/capsule radius"
					},
					"height": {
						"type": "number",
						"description": "Capsule/cylinder height"
					},
					"size": {
						"type": "object",
						"description": "Box size {x, y, z} or {x, y}"
					},
					"points": {
						"type": "array",
						"description": "Polygon points array"
					},
					"disabled": {
						"type": "boolean",
						"description": "Disabled state"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "physics_joint",
			"description": """PHYSICS JOINTS: Create and configure joints between physics bodies.

ACTIONS:
- create: Create a joint node (specify 2D or 3D type explicitly)
- get_info: Get joint information
- set_nodes: Set connected nodes (node_a, node_b)
- set_param: Set joint parameter
- get_param: Get joint parameter

JOINT TYPES (3D):
- pin_joint_3d: Point-to-point connection
- hinge_joint_3d: Single axis rotation (doors, wheels)
- slider_joint_3d: Linear sliding (pistons, elevators)
- cone_twist_joint_3d: Ball and socket (shoulders, hips)
- generic_6dof_joint_3d: Six degrees of freedom (full control)

JOINT TYPES (2D):
- pin_joint_2d: Point-to-point connection
- groove_joint_2d: Groove sliding (slider puzzles)
- damped_spring_joint_2d: Spring connection (bouncy platforms)

EXAMPLES (3D):
- Create hinge: {"action": "create", "type": "hinge_joint_3d", "parent": "Scene", "name": "DoorHinge"}
- Set nodes 3D: {"action": "set_nodes", "path": "DoorHinge", "node_a": "Wall", "node_b": "Door"}
- Set param: {"action": "set_param", "path": "DoorHinge", "param": "angular_limit/lower", "value": -90}

EXAMPLES (2D):
- Create pin: {"action": "create", "type": "pin_joint_2d", "parent": "Scene", "name": "Pivot"}
- Create spring: {"action": "create", "type": "damped_spring_joint_2d", "parent": "Scene", "name": "Spring"}
- Set nodes 2D: {"action": "set_nodes", "path": "Pivot", "node_a": "Anchor", "node_b": "Pendulum"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_nodes", "set_param", "get_param"],
						"description": "Joint action"
					},
					"path": {
						"type": "string",
						"description": "Joint node path"
					},
					"parent": {
						"type": "string",
						"description": "Parent node path"
					},
					"name": {
						"type": "string",
						"description": "Joint node name"
					},
					"type": {
						"type": "string",
						"enum": ["pin_joint_2d", "groove_joint_2d", "damped_spring_joint_2d", "pin_joint_3d", "hinge_joint_3d", "slider_joint_3d", "cone_twist_joint_3d", "generic_6dof_joint_3d"],
						"description": "Joint type"
					},
					"node_a": {
						"type": "string",
						"description": "First body path"
					},
					"node_b": {
						"type": "string",
						"description": "Second body path"
					},
					"param": {
						"type": "string",
						"description": "Parameter name"
					},
					"value": {
						"description": "Parameter value"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "physics_query",
			"description": """PHYSICS QUERIES: Perform raycasts, shape casts, and spatial queries.

ACTIONS:
- raycast: Cast a ray and return hit information
- shape_cast: Cast a shape and return hits
- point_check: Check what's at a point
- intersect_shape: Find all shapes overlapping with shape
- get_rest_info: Get collision rest information
- list_bodies_in_area: List all bodies in an Area node

MODE PARAMETER:
- Use "mode": "2d" for 2D physics queries
- Use "mode": "3d" for 3D physics queries (default)

QUERY OPTIONS:
- collision_mask: Filter by collision layers
- exclude: Array of RIDs or nodes to exclude
- collide_with_bodies: Include physics bodies
- collide_with_areas: Include areas

EXAMPLES (3D):
- Raycast down: {"action": "raycast", "from": {"x": 0, "y": 10, "z": 0}, "to": {"x": 0, "y": -10, "z": 0}, "mode": "3d"}
- Raycast forward: {"action": "raycast", "from": {"x": 0, "y": 1, "z": 0}, "to": {"x": 0, "y": 1, "z": 10}, "mode": "3d"}

EXAMPLES (2D):
- Raycast down: {"action": "raycast", "from": {"x": 100, "y": 0}, "to": {"x": 100, "y": 500}, "mode": "2d"}
- Point check: {"action": "point_check", "point": {"x": 200, "y": 300}, "mode": "2d"}
- Area bodies: {"action": "list_bodies_in_area", "path": "DetectionArea2D"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["raycast", "shape_cast", "point_check", "intersect_shape", "get_rest_info", "list_bodies_in_area"],
						"description": "Query action"
					},
					"mode": {
						"type": "string",
						"enum": ["2d", "3d"],
						"description": "Physics mode"
					},
					"from": {
						"type": "object",
						"description": "Ray start position"
					},
					"to": {
						"type": "object",
						"description": "Ray end position"
					},
					"point": {
						"type": "object",
						"description": "Point to check"
					},
					"path": {
						"type": "string",
						"description": "Node path (for area queries)"
					},
					"collision_mask": {
						"type": "integer",
						"description": "Collision mask filter"
					},
					"collide_with_bodies": {
						"type": "boolean",
						"description": "Include physics bodies"
					},
					"collide_with_areas": {
						"type": "boolean",
						"description": "Include areas"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"physics_body":
			return _execute_physics_body(args)
		"collision_shape":
			return _execute_collision_shape(args)
		"physics_joint":
			return _execute_physics_joint(args)
		"physics_query":
			return _execute_physics_query(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


func _detect_dimension_mode(node: Node) -> String:
	"""Auto-detect 2D or 3D mode based on node type.

	Checks the node and its ancestors to determine if we're in a 2D or 3D context.
	Returns "2d" or "3d" (defaults to "3d" if cannot determine).
	"""
	var current = node
	while current:
		# Check for 2D physics/canvas nodes
		if current is CollisionObject2D or current is Node2D or current is CanvasItem:
			return "2d"
		# Check for 3D physics/spatial nodes
		if current is CollisionObject3D or current is Node3D:
			return "3d"
		current = current.get_parent()

	# Default to 3D if cannot determine
	return "3d"


func _execute_physics_body(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_physics_body(args)
		"get_info":
			return _get_physics_body_info(args.get("path", ""))
		"set_mode":
			return _set_body_mode(args.get("path", ""), args.get("mode", ""))
		"set_mass":
			return _set_body_property(args.get("path", ""), "mass", args.get("mass", 1.0))
		"set_gravity_scale":
			return _set_body_property(args.get("path", ""), "gravity_scale", args.get("gravity_scale", 1.0))
		"set_linear_velocity":
			return _set_body_velocity(args.get("path", ""), args.get("velocity", {}), true)
		"set_angular_velocity":
			return _set_body_velocity(args.get("path", ""), args.get("velocity", {}), false)
		"apply_force":
			return _apply_body_force(args.get("path", ""), args.get("force", {}), args.get("position", {}), false)
		"apply_impulse":
			return _apply_body_force(args.get("path", ""), args.get("impulse", {}), args.get("position", {}), true)
		"set_layers":
			return _set_body_property(args.get("path", ""), "collision_layer", args.get("layers", 1))
		"set_mask":
			return _set_body_property(args.get("path", ""), "collision_mask", args.get("mask", 1))
		"freeze":
			return _set_body_property(args.get("path", ""), "freeze", args.get("frozen", true))
		_:
			return _error("Unknown action: %s" % action)


func _create_physics_body(args: Dictionary) -> Dictionary:
	var body_type = args.get("type", "")
	var parent_path = args.get("parent", "")
	var node_name = args.get("name", "")

	if body_type.is_empty():
		return _error("Body type is required")
	if parent_path.is_empty():
		return _error("Parent path is required")

	var parent = _find_node_by_path(parent_path)
	if not parent:
		return _error("Parent not found: %s" % parent_path)

	var body: Node
	match body_type:
		"rigid_body_2d":
			body = RigidBody2D.new()
		"rigid_body_3d":
			body = RigidBody3D.new()
		"character_body_2d":
			body = CharacterBody2D.new()
		"character_body_3d":
			body = CharacterBody3D.new()
		"static_body_2d":
			body = StaticBody2D.new()
		"static_body_3d":
			body = StaticBody3D.new()
		"area_2d":
			body = Area2D.new()
		"area_3d":
			body = Area3D.new()
		_:
			return _error("Unknown body type: %s" % body_type)

	if node_name.is_empty():
		node_name = body_type.to_pascal_case()
	body.name = node_name

	parent.add_child(body)
	body.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(body),
		"type": body_type,
		"name": node_name
	}, "Physics body created")


func _get_physics_body_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var info = {
		"path": path,
		"type": node.get_class(),
		"collision_layer": node.collision_layer if "collision_layer" in node else 0,
		"collision_mask": node.collision_mask if "collision_mask" in node else 0
	}

	if node is RigidBody3D:
		info["mass"] = node.mass
		info["gravity_scale"] = node.gravity_scale
		info["linear_velocity"] = _serialize_value(node.linear_velocity)
		info["angular_velocity"] = _serialize_value(node.angular_velocity)
		info["freeze"] = node.freeze
		info["freeze_mode"] = node.freeze_mode
		info["sleeping"] = node.sleeping
	elif node is RigidBody2D:
		info["mass"] = node.mass
		info["gravity_scale"] = node.gravity_scale
		info["linear_velocity"] = _serialize_value(node.linear_velocity)
		info["angular_velocity"] = node.angular_velocity
		info["freeze"] = node.freeze
		info["freeze_mode"] = node.freeze_mode
		info["sleeping"] = node.sleeping
	elif node is CharacterBody3D:
		info["velocity"] = _serialize_value(node.velocity)
		info["is_on_floor"] = node.is_on_floor()
		info["is_on_wall"] = node.is_on_wall()
		info["is_on_ceiling"] = node.is_on_ceiling()
	elif node is CharacterBody2D:
		info["velocity"] = _serialize_value(node.velocity)
		info["is_on_floor"] = node.is_on_floor()
		info["is_on_wall"] = node.is_on_wall()
		info["is_on_ceiling"] = node.is_on_ceiling()

	return _success(info)


func _set_body_mode(path: String, mode: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not (node is RigidBody2D or node is RigidBody3D):
		return _error("Node is not a RigidBody")

	var freeze_mode: int
	match mode:
		"static":
			freeze_mode = RigidBody3D.FREEZE_MODE_STATIC if node is RigidBody3D else RigidBody2D.FREEZE_MODE_STATIC
			node.freeze = true
		"kinematic":
			freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC if node is RigidBody3D else RigidBody2D.FREEZE_MODE_KINEMATIC
			node.freeze = true
		"rigid", "rigid_linear":
			node.freeze = false
		_:
			return _error("Unknown mode: %s" % mode)

	if mode in ["static", "kinematic"]:
		node.freeze_mode = freeze_mode

	return _success({
		"path": path,
		"mode": mode
	}, "Body mode set")


func _set_body_property(path: String, property: String, value) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not property in node:
		return _error("Property not found: %s" % property)

	node.set(property, value)

	return _success({
		"path": path,
		"property": property,
		"value": value
	}, "Property set")


func _set_body_velocity(path: String, velocity_dict: Dictionary, linear: bool) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is RigidBody3D:
		var vel = Vector3(velocity_dict.get("x", 0), velocity_dict.get("y", 0), velocity_dict.get("z", 0))
		if linear:
			node.linear_velocity = vel
		else:
			node.angular_velocity = vel
	elif node is RigidBody2D:
		if linear:
			var vel = Vector2(velocity_dict.get("x", 0), velocity_dict.get("y", 0))
			node.linear_velocity = vel
		else:
			node.angular_velocity = velocity_dict.get("z", velocity_dict.get("value", 0))
	else:
		return _error("Node is not a RigidBody")

	return _success({
		"path": path,
		"velocity": velocity_dict,
		"type": "linear" if linear else "angular"
	}, "Velocity set")


func _apply_body_force(path: String, force_dict: Dictionary, position_dict: Dictionary, is_impulse: bool) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is RigidBody3D:
		var force = Vector3(force_dict.get("x", 0), force_dict.get("y", 0), force_dict.get("z", 0))
		var pos = Vector3(position_dict.get("x", 0), position_dict.get("y", 0), position_dict.get("z", 0))
		if is_impulse:
			if position_dict.is_empty():
				node.apply_central_impulse(force)
			else:
				node.apply_impulse(force, pos)
		else:
			if position_dict.is_empty():
				node.apply_central_force(force)
			else:
				node.apply_force(force, pos)
	elif node is RigidBody2D:
		var force = Vector2(force_dict.get("x", 0), force_dict.get("y", 0))
		var pos = Vector2(position_dict.get("x", 0), position_dict.get("y", 0))
		if is_impulse:
			if position_dict.is_empty():
				node.apply_central_impulse(force)
			else:
				node.apply_impulse(force, pos)
		else:
			if position_dict.is_empty():
				node.apply_central_force(force)
			else:
				node.apply_force(force, pos)
	else:
		return _error("Node is not a RigidBody")

	return _success({
		"path": path,
		"force": force_dict,
		"position": position_dict,
		"type": "impulse" if is_impulse else "force"
	}, "%s applied" % ("Impulse" if is_impulse else "Force"))


func _execute_collision_shape(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_collision_shape(args)
		"get_info":
			return _get_shape_info(args.get("path", ""))
		"set_disabled":
			return _set_shape_disabled(args.get("path", ""), args.get("disabled", false))
		"create_box":
			return _create_box_shape(args)
		"create_sphere":
			return _create_sphere_shape(args)
		"create_capsule":
			return _create_capsule_shape(args)
		"create_cylinder":
			return _create_cylinder_shape(args)
		"create_polygon":
			return _create_polygon_shape(args)
		"set_size":
			return _set_shape_size(args)
		"make_convex_from_siblings":
			return _make_convex_from_siblings(args.get("path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _create_collision_shape(args: Dictionary) -> Dictionary:
	var parent_path = args.get("parent", "")
	var node_name = args.get("name", "")
	var mode = args.get("mode", "")  # Empty means auto-detect

	if parent_path.is_empty():
		return _error("Parent path is required")

	var parent = _find_node_by_path(parent_path)
	if not parent:
		return _error("Parent not found: %s" % parent_path)

	# Auto-detect mode based on parent node type if not specified
	if mode.is_empty():
		mode = _detect_dimension_mode(parent)

	var shape: Node
	if mode == "2d":
		shape = CollisionShape2D.new()
		if node_name.is_empty():
			node_name = "CollisionShape2D"
	else:
		shape = CollisionShape3D.new()
		if node_name.is_empty():
			node_name = "CollisionShape3D"

	shape.name = node_name
	parent.add_child(shape)
	shape.owner = _get_edited_scene_root()

	# Prepare shape type suggestions based on mode
	var shape_actions = []
	if mode == "2d":
		shape_actions = [
			"create_box (RectangleShape2D)",
			"create_sphere (CircleShape2D)",
			"create_capsule (CapsuleShape2D)",
			"create_polygon (ConvexPolygonShape2D)"
		]
	else:
		shape_actions = [
			"create_box (BoxShape3D)",
			"create_sphere (SphereShape3D)",
			"create_capsule (CapsuleShape3D)",
			"create_cylinder (CylinderShape3D)"
		]

	return _success({
		"path": _get_scene_path(shape),
		"mode": mode,
		"name": node_name,
		"warning": "CollisionShape has no shape! It will not detect collisions until a shape is assigned.",
		"next_step": "You MUST set a shape using one of these actions: %s" % ", ".join(shape_actions),
		"example": {"action": "create_box", "path": _get_scene_path(shape), "size": {"x": 1, "y": 1} if mode == "2d" else {"x": 1, "y": 1, "z": 1}}
	}, "Collision shape node created. WARNING: You must assign a shape resource for collision to work!")


func _get_shape_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var info = {
		"path": path,
		"type": node.get_class(),
		"disabled": node.disabled if "disabled" in node else false
	}

	if node is CollisionShape3D and node.shape:
		info["shape_type"] = node.shape.get_class()
		if node.shape is BoxShape3D:
			info["size"] = _serialize_value(node.shape.size)
		elif node.shape is SphereShape3D:
			info["radius"] = node.shape.radius
		elif node.shape is CapsuleShape3D:
			info["radius"] = node.shape.radius
			info["height"] = node.shape.height
		elif node.shape is CylinderShape3D:
			info["radius"] = node.shape.radius
			info["height"] = node.shape.height
	elif node is CollisionShape2D and node.shape:
		info["shape_type"] = node.shape.get_class()
		if node.shape is RectangleShape2D:
			info["size"] = _serialize_value(node.shape.size)
		elif node.shape is CircleShape2D:
			info["radius"] = node.shape.radius
		elif node.shape is CapsuleShape2D:
			info["radius"] = node.shape.radius
			info["height"] = node.shape.height

	return _success(info)


func _set_shape_disabled(path: String, disabled: bool) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not (node is CollisionShape2D or node is CollisionShape3D):
		return _error("Node is not a CollisionShape")

	node.disabled = disabled

	return _success({
		"path": path,
		"disabled": disabled
	}, "Shape %s" % ("disabled" if disabled else "enabled"))


func _create_box_shape(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var size_dict = args.get("size", {"x": 1, "y": 1, "z": 1})

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is CollisionShape3D:
		var shape = BoxShape3D.new()
		shape.size = Vector3(size_dict.get("x", 1), size_dict.get("y", 1), size_dict.get("z", 1))
		node.shape = shape
	elif node is CollisionShape2D:
		var shape = RectangleShape2D.new()
		shape.size = Vector2(size_dict.get("x", 1), size_dict.get("y", 1))
		node.shape = shape
	else:
		return _error("Node is not a CollisionShape")

	return _success({
		"path": path,
		"shape": "box",
		"size": size_dict
	}, "Box shape created")


func _create_sphere_shape(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var radius = args.get("radius", 0.5)

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is CollisionShape3D:
		var shape = SphereShape3D.new()
		shape.radius = radius
		node.shape = shape
	elif node is CollisionShape2D:
		var shape = CircleShape2D.new()
		shape.radius = radius
		node.shape = shape
	else:
		return _error("Node is not a CollisionShape")

	return _success({
		"path": path,
		"shape": "sphere",
		"radius": radius
	}, "Sphere shape created")


func _create_capsule_shape(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var radius = args.get("radius", 0.5)
	var height = args.get("height", 2.0)

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is CollisionShape3D:
		var shape = CapsuleShape3D.new()
		shape.radius = radius
		shape.height = height
		node.shape = shape
	elif node is CollisionShape2D:
		var shape = CapsuleShape2D.new()
		shape.radius = radius
		shape.height = height
		node.shape = shape
	else:
		return _error("Node is not a CollisionShape")

	return _success({
		"path": path,
		"shape": "capsule",
		"radius": radius,
		"height": height
	}, "Capsule shape created")


func _create_cylinder_shape(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var radius = args.get("radius", 0.5)
	var height = args.get("height", 2.0)

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is CollisionShape3D:
		return _error("Cylinder shape is only available for 3D")

	var shape = CylinderShape3D.new()
	shape.radius = radius
	shape.height = height
	node.shape = shape

	return _success({
		"path": path,
		"shape": "cylinder",
		"radius": radius,
		"height": height
	}, "Cylinder shape created")


func _create_polygon_shape(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var points = args.get("points", [])

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is CollisionShape2D:
		return _error("Polygon shape is only available for 2D")

	var shape = ConvexPolygonShape2D.new()
	var point_array: PackedVector2Array = []
	for p in points:
		point_array.append(Vector2(p.get("x", 0), p.get("y", 0)))
	shape.points = point_array
	node.shape = shape

	return _success({
		"path": path,
		"shape": "polygon",
		"point_count": points.size()
	}, "Polygon shape created")


func _set_shape_size(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not (node is CollisionShape2D or node is CollisionShape3D):
		return _error("Node is not a CollisionShape")

	if not node.shape:
		return _error("Shape has no shape resource")

	var shape = node.shape
	if shape is BoxShape3D:
		var size = args.get("size", {})
		shape.size = Vector3(size.get("x", shape.size.x), size.get("y", shape.size.y), size.get("z", shape.size.z))
	elif shape is RectangleShape2D:
		var size = args.get("size", {})
		shape.size = Vector2(size.get("x", shape.size.x), size.get("y", shape.size.y))
	elif shape is SphereShape3D or shape is CircleShape2D:
		shape.radius = args.get("radius", shape.radius)
	elif shape is CapsuleShape3D or shape is CapsuleShape2D:
		if args.has("radius"):
			shape.radius = args.get("radius")
		if args.has("height"):
			shape.height = args.get("height")
	elif shape is CylinderShape3D:
		if args.has("radius"):
			shape.radius = args.get("radius")
		if args.has("height"):
			shape.height = args.get("height")
	else:
		return _error("Unsupported shape type for resizing")

	return _success({
		"path": path,
		"shape_type": shape.get_class()
	}, "Shape size updated")


func _make_convex_from_siblings(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is CollisionShape3D:
		return _error("Only CollisionShape3D supports this operation")

	# Find sibling MeshInstance3D
	var parent = node.get_parent()
	var mesh_instance: MeshInstance3D = null

	for sibling in parent.get_children():
		if sibling is MeshInstance3D and sibling.mesh:
			mesh_instance = sibling
			break

	if not mesh_instance:
		return _error("No MeshInstance3D sibling found")

	var shape = mesh_instance.mesh.create_convex_shape()
	node.shape = shape

	return _success({
		"path": path,
		"mesh_source": _get_scene_path(mesh_instance)
	}, "Convex shape created from mesh")


func _execute_physics_joint(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_joint(args)
		"get_info":
			return _get_joint_info(args.get("path", ""))
		"set_nodes":
			return _set_joint_nodes(args.get("path", ""), args.get("node_a", ""), args.get("node_b", ""))
		"set_param":
			return _set_joint_param(args.get("path", ""), args.get("param", ""), args.get("value"))
		"get_param":
			return _get_joint_param(args.get("path", ""), args.get("param", ""))
		_:
			return _error("Unknown action: %s" % action)


func _create_joint(args: Dictionary) -> Dictionary:
	var joint_type = args.get("type", "")
	var parent_path = args.get("parent", "")
	var node_name = args.get("name", "")

	if joint_type.is_empty():
		return _error("Joint type is required")
	if parent_path.is_empty():
		return _error("Parent path is required")

	var parent = _find_node_by_path(parent_path)
	if not parent:
		return _error("Parent not found: %s" % parent_path)

	var joint: Node
	match joint_type:
		"pin_joint_2d":
			joint = PinJoint2D.new()
		"groove_joint_2d":
			joint = GrooveJoint2D.new()
		"damped_spring_joint_2d":
			joint = DampedSpringJoint2D.new()
		"pin_joint_3d":
			joint = PinJoint3D.new()
		"hinge_joint_3d":
			joint = HingeJoint3D.new()
		"slider_joint_3d":
			joint = SliderJoint3D.new()
		"cone_twist_joint_3d":
			joint = ConeTwistJoint3D.new()
		"generic_6dof_joint_3d":
			joint = Generic6DOFJoint3D.new()
		_:
			return _error("Unknown joint type: %s" % joint_type)

	if node_name.is_empty():
		node_name = joint_type.to_pascal_case()
	joint.name = node_name

	parent.add_child(joint)
	joint.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(joint),
		"type": joint_type,
		"name": node_name
	}, "Joint created")


func _get_joint_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var info = {
		"path": path,
		"type": node.get_class()
	}

	if node is Joint2D:
		info["node_a"] = str(node.node_a) if node.node_a else ""
		info["node_b"] = str(node.node_b) if node.node_b else ""
		info["bias"] = node.bias
		info["disable_collision"] = node.disable_collision
	elif node is Joint3D:
		info["node_a"] = str(node.node_a) if node.node_a else ""
		info["node_b"] = str(node.node_b) if node.node_b else ""
		info["exclude_from_collision"] = node.exclude_nodes_from_collision

	return _success(info)


func _set_joint_nodes(path: String, node_a_path: String, node_b_path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not (node is Joint2D or node is Joint3D):
		return _error("Node is not a Joint")

	if not node_a_path.is_empty():
		node.node_a = NodePath(node_a_path)
	if not node_b_path.is_empty():
		node.node_b = NodePath(node_b_path)

	return _success({
		"path": path,
		"node_a": node_a_path,
		"node_b": node_b_path
	}, "Joint nodes set")


func _set_joint_param(path: String, param: String, value) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if param.is_empty():
		return _error("Parameter name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	# Convert path-style param to property
	var prop_name = param.replace("/", "_")

	if not prop_name in node:
		return _error("Parameter not found: %s" % param)

	node.set(prop_name, value)

	return _success({
		"path": path,
		"param": param,
		"value": value
	}, "Joint parameter set")


func _get_joint_param(path: String, param: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")
	if param.is_empty():
		return _error("Parameter name is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var prop_name = param.replace("/", "_")

	if not prop_name in node:
		return _error("Parameter not found: %s" % param)

	return _success({
		"path": path,
		"param": param,
		"value": node.get(prop_name)
	})


func _execute_physics_query(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"raycast":
			return _do_raycast(args)
		"point_check":
			return _do_point_check(args)
		"list_bodies_in_area":
			return _list_bodies_in_area(args.get("path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _do_raycast(args: Dictionary) -> Dictionary:
	var mode = args.get("mode", "3d")
	var from_dict = args.get("from", {})
	var to_dict = args.get("to", {})
	var collision_mask = args.get("collision_mask", 0xFFFFFFFF)

	if from_dict.is_empty() or to_dict.is_empty():
		return _error("Both 'from' and 'to' positions are required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	if mode == "3d":
		var from = Vector3(from_dict.get("x", 0), from_dict.get("y", 0), from_dict.get("z", 0))
		var to = Vector3(to_dict.get("x", 0), to_dict.get("y", 0), to_dict.get("z", 0))

		var space_state = root.get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
		query.collide_with_bodies = args.get("collide_with_bodies", true)
		query.collide_with_areas = args.get("collide_with_areas", false)

		var result = space_state.intersect_ray(query)

		if result.is_empty():
			return _success({
				"hit": false,
				"from": _serialize_value(from),
				"to": _serialize_value(to)
			})

		return _success({
			"hit": true,
			"from": _serialize_value(from),
			"to": _serialize_value(to),
			"position": _serialize_value(result.position),
			"normal": _serialize_value(result.normal),
			"collider": _get_scene_path(result.collider) if result.collider else "",
			"collider_id": result.collider_id
		})
	else:
		var from = Vector2(from_dict.get("x", 0), from_dict.get("y", 0))
		var to = Vector2(to_dict.get("x", 0), to_dict.get("y", 0))

		var space_state = root.get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(from, to, collision_mask)
		query.collide_with_bodies = args.get("collide_with_bodies", true)
		query.collide_with_areas = args.get("collide_with_areas", false)

		var result = space_state.intersect_ray(query)

		if result.is_empty():
			return _success({
				"hit": false,
				"from": _serialize_value(from),
				"to": _serialize_value(to)
			})

		return _success({
			"hit": true,
			"from": _serialize_value(from),
			"to": _serialize_value(to),
			"position": _serialize_value(result.position),
			"normal": _serialize_value(result.normal),
			"collider": _get_scene_path(result.collider) if result.collider else "",
			"collider_id": result.collider_id
		})


func _do_point_check(args: Dictionary) -> Dictionary:
	var mode = args.get("mode", "2d")
	var point_dict = args.get("point", {})
	var collision_mask = args.get("collision_mask", 0xFFFFFFFF)

	if point_dict.is_empty():
		return _error("Point is required")

	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	if mode == "2d":
		var point = Vector2(point_dict.get("x", 0), point_dict.get("y", 0))
		var space_state = root.get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = point
		query.collision_mask = collision_mask
		query.collide_with_bodies = args.get("collide_with_bodies", true)
		query.collide_with_areas = args.get("collide_with_areas", false)

		var results = space_state.intersect_point(query, 32)
		var hits: Array[Dictionary] = []

		for r in results:
			hits.append({
				"collider": _get_scene_path(r.collider) if r.collider else "",
				"collider_id": r.collider_id,
				"shape": r.shape
			})

		return _success({
			"point": _serialize_value(point),
			"hit_count": hits.size(),
			"hits": hits
		})
	else:
		return _error("Point check is only available for 2D. Use raycast for 3D.")


func _list_bodies_in_area(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not (node is Area2D or node is Area3D):
		return _error("Node is not an Area")

	var bodies: Array[Dictionary] = []

	if node is Area3D:
		for body in node.get_overlapping_bodies():
			bodies.append({
				"path": _get_scene_path(body),
				"type": body.get_class()
			})
	else:
		for body in node.get_overlapping_bodies():
			bodies.append({
				"path": _get_scene_path(body),
				"type": body.get_class()
			})

	return _success({
		"path": path,
		"body_count": bodies.size(),
		"bodies": bodies
	})
