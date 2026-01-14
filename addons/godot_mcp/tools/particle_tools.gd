@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Particle tools for Godot MCP
## Provides GPUParticles and CPUParticles operations


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "particles",
			"description": """PARTICLE EMITTERS: Create and control particle systems.

ACTIONS:
- create: Create a particle emitter node
- get_info: Get emitter information
- set_emitting: Start/stop emission
- restart: Restart emission
- set_amount: Set particle count
- set_lifetime: Set particle lifetime
- set_one_shot: Set one-shot mode
- set_explosiveness: Set explosiveness ratio
- set_randomness: Set randomness ratio
- set_speed_scale: Set speed scale
- set_process_material: Assign ParticleProcessMaterial
- set_draw_order: Set particle draw order
- convert_to_cpu: Convert GPU particles to CPU particles

EMITTER TYPES:
- gpu_particles_2d: GPU-accelerated 2D particles
- gpu_particles_3d: GPU-accelerated 3D particles
- cpu_particles_2d: CPU-based 2D particles
- cpu_particles_3d: CPU-based 3D particles

EXAMPLES:
- Create emitter: {"action": "create", "type": "gpu_particles_3d", "parent": "/root/Scene"}
- Start emitting: {"action": "set_emitting", "path": "/root/GPUParticles3D", "emitting": true}
- Set amount: {"action": "set_amount", "path": "/root/GPUParticles3D", "amount": 100}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_emitting", "restart", "set_amount", "set_lifetime", "set_one_shot", "set_explosiveness", "set_randomness", "set_speed_scale", "set_process_material", "set_draw_order", "convert_to_cpu"],
						"description": "Particle action"
					},
					"path": {
						"type": "string",
						"description": "Particle emitter node path"
					},
					"parent": {
						"type": "string",
						"description": "Parent node path for creation"
					},
					"name": {
						"type": "string",
						"description": "Node name"
					},
					"type": {
						"type": "string",
						"enum": ["gpu_particles_2d", "gpu_particles_3d", "cpu_particles_2d", "cpu_particles_3d"],
						"description": "Emitter type"
					},
					"emitting": {
						"type": "boolean",
						"description": "Emission state"
					},
					"amount": {
						"type": "integer",
						"description": "Number of particles"
					},
					"lifetime": {
						"type": "number",
						"description": "Particle lifetime in seconds"
					},
					"one_shot": {
						"type": "boolean",
						"description": "One-shot mode"
					},
					"explosiveness": {
						"type": "number",
						"description": "Explosiveness ratio (0-1)"
					},
					"randomness": {
						"type": "number",
						"description": "Randomness ratio (0-1)"
					},
					"speed_scale": {
						"type": "number",
						"description": "Speed scale multiplier"
					},
					"draw_order": {
						"type": "string",
						"enum": ["index", "lifetime", "reverse_lifetime", "view_depth"],
						"description": "Draw order mode"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "particle_material",
			"description": """PARTICLE MATERIAL: Configure ParticleProcessMaterial properties.

ACTIONS:
- create: Create and assign a new ParticleProcessMaterial
- get_info: Get material properties
- set_direction: Set emission direction
- set_spread: Set spread angle
- set_gravity: Set gravity vector
- set_velocity: Set initial velocity (min/max)
- set_angular_velocity: Set angular velocity
- set_orbit_velocity: Set orbit velocity
- set_linear_accel: Set linear acceleration
- set_radial_accel: Set radial acceleration
- set_tangential_accel: Set tangential acceleration
- set_damping: Set damping
- set_scale: Set particle scale (min/max)
- set_color: Set particle color
- set_color_ramp: Set color gradient
- set_emission_shape: Set emission shape
- set_emission_sphere: Set sphere emission radius
- set_emission_box: Set box emission extents

EXAMPLES:
- Create material: {"action": "create", "path": "/root/GPUParticles3D"}
- Set gravity: {"action": "set_gravity", "path": "/root/GPUParticles3D", "gravity": {"x": 0, "y": -9.8, "z": 0}}
- Set velocity: {"action": "set_velocity", "path": "/root/GPUParticles3D", "min": 5, "max": 10}
- Set scale: {"action": "set_scale", "path": "/root/GPUParticles3D", "min": 0.5, "max": 1.5}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_direction", "set_spread", "set_gravity", "set_velocity", "set_angular_velocity", "set_orbit_velocity", "set_linear_accel", "set_radial_accel", "set_tangential_accel", "set_damping", "set_scale", "set_color", "set_color_ramp", "set_emission_shape", "set_emission_sphere", "set_emission_box"],
						"description": "Material action"
					},
					"path": {
						"type": "string",
						"description": "Particle emitter path"
					},
					"direction": {
						"type": "object",
						"description": "Direction vector"
					},
					"spread": {
						"type": "number",
						"description": "Spread angle in degrees"
					},
					"gravity": {
						"type": "object",
						"description": "Gravity vector"
					},
					"min": {
						"type": "number",
						"description": "Minimum value"
					},
					"max": {
						"type": "number",
						"description": "Maximum value"
					},
					"color": {
						"type": "object",
						"description": "Color {r, g, b, a}"
					},
					"shape": {
						"type": "string",
						"enum": ["point", "sphere", "sphere_surface", "box", "ring"],
						"description": "Emission shape"
					},
					"radius": {
						"type": "number",
						"description": "Sphere radius"
					},
					"extents": {
						"type": "object",
						"description": "Box extents {x, y, z}"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"particles":
			return _execute_particles(args)
		"particle_material":
			return _execute_particle_material(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


func _execute_particles(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_particles(args)
		"get_info":
			return _get_particles_info(args.get("path", ""))
		"set_emitting":
			return _set_particle_property(args.get("path", ""), "emitting", args.get("emitting", true))
		"restart":
			return _restart_particles(args.get("path", ""))
		"set_amount":
			return _set_particle_property(args.get("path", ""), "amount", args.get("amount", 8))
		"set_lifetime":
			return _set_particle_property(args.get("path", ""), "lifetime", args.get("lifetime", 1.0))
		"set_one_shot":
			return _set_particle_property(args.get("path", ""), "one_shot", args.get("one_shot", false))
		"set_explosiveness":
			return _set_particle_property(args.get("path", ""), "explosiveness", args.get("explosiveness", 0.0))
		"set_randomness":
			return _set_particle_property(args.get("path", ""), "randomness", args.get("randomness", 0.0))
		"set_speed_scale":
			return _set_particle_property(args.get("path", ""), "speed_scale", args.get("speed_scale", 1.0))
		"set_draw_order":
			return _set_draw_order(args.get("path", ""), args.get("draw_order", "index"))
		"convert_to_cpu":
			return _convert_to_cpu(args.get("path", ""))
		_:
			return _error("Unknown action: %s" % action)


func _create_particles(args: Dictionary) -> Dictionary:
	var particle_type = args.get("type", "gpu_particles_3d")
	var parent_path = args.get("parent", "")
	var node_name = args.get("name", "")

	if parent_path.is_empty():
		return _error("Parent path is required")

	var parent = _find_node_by_path(parent_path)
	if not parent:
		return _error("Parent not found: %s" % parent_path)

	var particles: Node
	match particle_type:
		"gpu_particles_2d":
			particles = GPUParticles2D.new()
		"gpu_particles_3d":
			particles = GPUParticles3D.new()
		"cpu_particles_2d":
			particles = CPUParticles2D.new()
		"cpu_particles_3d":
			particles = CPUParticles3D.new()
		_:
			return _error("Unknown particle type: %s" % particle_type)

	if node_name.is_empty():
		node_name = particle_type.to_pascal_case()
	particles.name = node_name

	# Create default material for GPU particles
	if particles is GPUParticles2D or particles is GPUParticles3D:
		var material = ParticleProcessMaterial.new()
		material.direction = Vector3(0, 1, 0) if particles is GPUParticles3D else Vector3(0, -1, 0)
		material.gravity = Vector3(0, -9.8, 0) if particles is GPUParticles3D else Vector3(0, 98, 0)
		particles.process_material = material

	parent.add_child(particles)
	particles.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(particles),
		"type": particle_type,
		"name": node_name
	}, "Particle emitter created")


func _get_particles_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var info = {
		"path": path,
		"type": node.get_class()
	}

	if node is GPUParticles2D or node is GPUParticles3D:
		info["emitting"] = node.emitting
		info["amount"] = node.amount
		info["lifetime"] = node.lifetime
		info["one_shot"] = node.one_shot
		info["preprocess"] = node.preprocess
		info["speed_scale"] = node.speed_scale
		info["explosiveness"] = node.explosiveness
		info["randomness"] = node.randomness
		info["fixed_fps"] = node.fixed_fps
		info["interpolate"] = node.interpolate
		info["has_process_material"] = node.process_material != null
		info["has_draw_passes"] = node.draw_passes > 0 if node is GPUParticles3D else (node.texture != null)
	elif node is CPUParticles2D or node is CPUParticles3D:
		info["emitting"] = node.emitting
		info["amount"] = node.amount
		info["lifetime"] = node.lifetime
		info["one_shot"] = node.one_shot
		info["preprocess"] = node.preprocess
		info["speed_scale"] = node.speed_scale
		info["explosiveness"] = node.explosiveness
		info["randomness"] = node.randomness
		info["direction"] = _serialize_value(node.direction)
		info["spread"] = node.spread
		info["gravity"] = _serialize_value(node.gravity)
	else:
		return _error("Node is not a particle emitter")

	return _success(info)


func _set_particle_property(path: String, property: String, value) -> Dictionary:
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


func _restart_particles(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is GPUParticles2D or node is GPUParticles3D or node is CPUParticles2D or node is CPUParticles3D:
		node.restart()
		return _success({"path": path}, "Particles restarted")

	return _error("Node is not a particle emitter")


func _set_draw_order(path: String, order: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is GPUParticles3D:
		match order:
			"index":
				node.draw_order = GPUParticles3D.DRAW_ORDER_INDEX
			"lifetime":
				node.draw_order = GPUParticles3D.DRAW_ORDER_LIFETIME
			"reverse_lifetime":
				node.draw_order = GPUParticles3D.DRAW_ORDER_REVERSE_LIFETIME
			"view_depth":
				node.draw_order = GPUParticles3D.DRAW_ORDER_VIEW_DEPTH
	elif node is GPUParticles2D:
		match order:
			"index":
				node.draw_order = GPUParticles2D.DRAW_ORDER_INDEX
			"lifetime":
				node.draw_order = GPUParticles2D.DRAW_ORDER_LIFETIME
			"reverse_lifetime":
				node.draw_order = GPUParticles2D.DRAW_ORDER_REVERSE_LIFETIME
	else:
		return _error("Draw order only available for GPUParticles")

	return _success({
		"path": path,
		"draw_order": order
	}, "Draw order set")


func _convert_to_cpu(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is GPUParticles3D:
		var cpu = CPUParticles3D.new()
		cpu.name = node.name + "_CPU"
		cpu.convert_from_particles(node)
		node.get_parent().add_child(cpu)
		cpu.owner = _get_edited_scene_root()
		cpu.global_transform = node.global_transform
		return _success({
			"original": path,
			"cpu_path": _get_scene_path(cpu)
		}, "Converted to CPUParticles3D")
	elif node is GPUParticles2D:
		var cpu = CPUParticles2D.new()
		cpu.name = node.name + "_CPU"
		cpu.convert_from_particles(node)
		node.get_parent().add_child(cpu)
		cpu.owner = _get_edited_scene_root()
		cpu.global_transform = node.global_transform
		return _success({
			"original": path,
			"cpu_path": _get_scene_path(cpu)
		}, "Converted to CPUParticles2D")

	return _error("Node is not a GPUParticles node")


func _execute_particle_material(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_particle_material(args.get("path", ""))
		"get_info":
			return _get_material_info(args.get("path", ""))
		"set_direction":
			return _set_material_direction(args.get("path", ""), args.get("direction", {}))
		"set_spread":
			return _set_material_property(args.get("path", ""), "spread", args.get("spread", 45.0))
		"set_gravity":
			return _set_material_gravity(args.get("path", ""), args.get("gravity", {}))
		"set_velocity":
			return _set_material_velocity(args.get("path", ""), args.get("min", 0), args.get("max", 0))
		"set_angular_velocity":
			return _set_material_range(args.get("path", ""), "angular_velocity", args.get("min", 0), args.get("max", 0))
		"set_orbit_velocity":
			return _set_material_range(args.get("path", ""), "orbit_velocity", args.get("min", 0), args.get("max", 0))
		"set_linear_accel":
			return _set_material_range(args.get("path", ""), "linear_accel", args.get("min", 0), args.get("max", 0))
		"set_radial_accel":
			return _set_material_range(args.get("path", ""), "radial_accel", args.get("min", 0), args.get("max", 0))
		"set_tangential_accel":
			return _set_material_range(args.get("path", ""), "tangential_accel", args.get("min", 0), args.get("max", 0))
		"set_damping":
			return _set_material_range(args.get("path", ""), "damping", args.get("min", 0), args.get("max", 0))
		"set_scale":
			return _set_material_range(args.get("path", ""), "scale", args.get("min", 1), args.get("max", 1))
		"set_color":
			return _set_material_color(args.get("path", ""), args.get("color", {}))
		"set_emission_shape":
			return _set_emission_shape(args.get("path", ""), args.get("shape", "point"))
		"set_emission_sphere":
			return _set_emission_sphere(args.get("path", ""), args.get("radius", 1.0))
		"set_emission_box":
			return _set_emission_box(args.get("path", ""), args.get("extents", {}))
		_:
			return _error("Unknown action: %s" % action)


func _get_process_material(path: String):
	var node = _find_node_by_path(path)
	if not node:
		return null

	if node is GPUParticles2D or node is GPUParticles3D:
		return node.process_material
	return null


func _create_particle_material(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not (node is GPUParticles2D or node is GPUParticles3D):
		return _error("Node is not a GPUParticles node")

	var material = ParticleProcessMaterial.new()
	node.process_material = material

	return _success({
		"path": path,
		"material_type": "ParticleProcessMaterial"
	}, "Particle material created")


func _get_material_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var material = _get_process_material(path)
	if not material:
		# Check if it's a CPUParticles node
		var node = _find_node_by_path(path)
		if node is CPUParticles2D or node is CPUParticles3D:
			return _success({
				"path": path,
				"type": "CPUParticles (no separate material)",
				"direction": _serialize_value(node.direction),
				"spread": node.spread,
				"gravity": _serialize_value(node.gravity),
				"initial_velocity_min": node.initial_velocity_min,
				"initial_velocity_max": node.initial_velocity_max,
				"scale_amount_min": node.scale_amount_min,
				"scale_amount_max": node.scale_amount_max,
				"color": _serialize_value(node.color)
			})
		return _error("No process material found")

	return _success({
		"path": path,
		"type": "ParticleProcessMaterial",
		"direction": _serialize_value(material.direction),
		"spread": material.spread,
		"flatness": material.flatness,
		"gravity": _serialize_value(material.gravity),
		"initial_velocity_min": material.initial_velocity_min,
		"initial_velocity_max": material.initial_velocity_max,
		"angular_velocity_min": material.angular_velocity_min,
		"angular_velocity_max": material.angular_velocity_max,
		"scale_min": material.scale_min,
		"scale_max": material.scale_max,
		"color": _serialize_value(material.color),
		"emission_shape": material.emission_shape
	})


func _set_material_direction(path: String, direction: Dictionary) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var dir = Vector3(direction.get("x", 0), direction.get("y", 1), direction.get("z", 0))

	if node is GPUParticles2D or node is GPUParticles3D:
		if node.process_material:
			node.process_material.direction = dir
	elif node is CPUParticles2D or node is CPUParticles3D:
		node.direction = dir
	else:
		return _error("Node is not a particle emitter")

	return _success({
		"path": path,
		"direction": _serialize_value(dir)
	}, "Direction set")


func _set_material_property(path: String, property: String, value) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is GPUParticles2D or node is GPUParticles3D:
		if node.process_material and property in node.process_material:
			node.process_material.set(property, value)
		else:
			return _error("Property not found in material: %s" % property)
	elif node is CPUParticles2D or node is CPUParticles3D:
		if property in node:
			node.set(property, value)
		else:
			return _error("Property not found: %s" % property)
	else:
		return _error("Node is not a particle emitter")

	return _success({
		"path": path,
		"property": property,
		"value": value
	}, "Property set")


func _set_material_gravity(path: String, gravity: Dictionary) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var grav = Vector3(gravity.get("x", 0), gravity.get("y", -9.8), gravity.get("z", 0))

	if node is GPUParticles2D or node is GPUParticles3D:
		if node.process_material:
			node.process_material.gravity = grav
	elif node is CPUParticles2D or node is CPUParticles3D:
		node.gravity = grav
	else:
		return _error("Node is not a particle emitter")

	return _success({
		"path": path,
		"gravity": _serialize_value(grav)
	}, "Gravity set")


func _set_material_velocity(path: String, min_val: float, max_val: float) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is GPUParticles2D or node is GPUParticles3D:
		if node.process_material:
			node.process_material.initial_velocity_min = min_val
			node.process_material.initial_velocity_max = max_val
	elif node is CPUParticles2D or node is CPUParticles3D:
		node.initial_velocity_min = min_val
		node.initial_velocity_max = max_val
	else:
		return _error("Node is not a particle emitter")

	return _success({
		"path": path,
		"velocity_min": min_val,
		"velocity_max": max_val
	}, "Velocity set")


func _set_material_range(path: String, property: String, min_val: float, max_val: float) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var min_prop = property + "_min"
	var max_prop = property + "_max"

	# Handle scale special case
	if property == "scale":
		min_prop = "scale_amount_min" if (node is CPUParticles2D or node is CPUParticles3D) else "scale_min"
		max_prop = "scale_amount_max" if (node is CPUParticles2D or node is CPUParticles3D) else "scale_max"

	if node is GPUParticles2D or node is GPUParticles3D:
		if node.process_material:
			if min_prop in node.process_material:
				node.process_material.set(min_prop, min_val)
				node.process_material.set(max_prop, max_val)
			else:
				return _error("Property not found: %s" % property)
	elif node is CPUParticles2D or node is CPUParticles3D:
		if min_prop in node:
			node.set(min_prop, min_val)
			node.set(max_prop, max_val)
		else:
			return _error("Property not found: %s" % property)
	else:
		return _error("Node is not a particle emitter")

	return _success({
		"path": path,
		"property": property,
		"min": min_val,
		"max": max_val
	}, "%s range set" % property.capitalize())


func _set_material_color(path: String, color_dict: Dictionary) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var color = Color(
		color_dict.get("r", 1.0),
		color_dict.get("g", 1.0),
		color_dict.get("b", 1.0),
		color_dict.get("a", 1.0)
	)

	if node is GPUParticles2D or node is GPUParticles3D:
		if node.process_material:
			node.process_material.color = color
	elif node is CPUParticles2D or node is CPUParticles3D:
		node.color = color
	else:
		return _error("Node is not a particle emitter")

	return _success({
		"path": path,
		"color": _serialize_value(color)
	}, "Color set")


func _set_emission_shape(path: String, shape: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var shape_enum: int

	if node is GPUParticles2D or node is GPUParticles3D:
		if not node.process_material:
			return _error("No process material")

		match shape:
			"point":
				shape_enum = ParticleProcessMaterial.EMISSION_SHAPE_POINT
			"sphere":
				shape_enum = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
			"sphere_surface":
				shape_enum = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE_SURFACE
			"box":
				shape_enum = ParticleProcessMaterial.EMISSION_SHAPE_BOX
			"ring":
				shape_enum = ParticleProcessMaterial.EMISSION_SHAPE_RING
			_:
				return _error("Unknown shape: %s" % shape)

		node.process_material.emission_shape = shape_enum
	elif node is CPUParticles2D or node is CPUParticles3D:
		match shape:
			"point":
				shape_enum = CPUParticles3D.EMISSION_SHAPE_POINT if node is CPUParticles3D else CPUParticles2D.EMISSION_SHAPE_POINT
			"sphere":
				shape_enum = CPUParticles3D.EMISSION_SHAPE_SPHERE if node is CPUParticles3D else CPUParticles2D.EMISSION_SHAPE_SPHERE
			"sphere_surface":
				shape_enum = CPUParticles3D.EMISSION_SHAPE_SPHERE_SURFACE if node is CPUParticles3D else CPUParticles2D.EMISSION_SHAPE_SPHERE_SURFACE
			"box":
				shape_enum = CPUParticles3D.EMISSION_SHAPE_BOX if node is CPUParticles3D else CPUParticles2D.EMISSION_SHAPE_RECTANGLE
			"ring":
				shape_enum = CPUParticles3D.EMISSION_SHAPE_RING if node is CPUParticles3D else CPUParticles2D.EMISSION_SHAPE_POINTS
			_:
				return _error("Unknown shape: %s" % shape)

		node.emission_shape = shape_enum
	else:
		return _error("Node is not a particle emitter")

	return _success({
		"path": path,
		"shape": shape
	}, "Emission shape set")


func _set_emission_sphere(path: String, radius: float) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is GPUParticles2D or node is GPUParticles3D:
		if not node.process_material:
			return _error("No process material")
		node.process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
		node.process_material.emission_sphere_radius = radius
	elif node is CPUParticles2D or node is CPUParticles3D:
		if node is CPUParticles3D:
			node.emission_shape = CPUParticles3D.EMISSION_SHAPE_SPHERE
		else:
			node.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
		node.emission_sphere_radius = radius
	else:
		return _error("Node is not a particle emitter")

	return _success({
		"path": path,
		"shape": "sphere",
		"radius": radius
	}, "Sphere emission set")


func _set_emission_box(path: String, extents: Dictionary) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var ext = Vector3(extents.get("x", 1), extents.get("y", 1), extents.get("z", 1))

	if node is GPUParticles2D or node is GPUParticles3D:
		if not node.process_material:
			return _error("No process material")
		node.process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
		node.process_material.emission_box_extents = ext
	elif node is CPUParticles3D:
		node.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
		node.emission_box_extents = ext
	elif node is CPUParticles2D:
		node.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		node.emission_rect_extents = Vector2(ext.x, ext.y)
	else:
		return _error("Node is not a particle emitter")

	return _success({
		"path": path,
		"shape": "box",
		"extents": _serialize_value(ext)
	}, "Box emission set")
