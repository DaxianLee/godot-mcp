@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Lighting tools for Godot MCP
## Provides lights, environment, and sky operations


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "light",
			"description": """LIGHTS: Create and configure light nodes.

ACTIONS:
- create: Create a light node
- get_info: Get light information
- set_color: Set light color
- set_energy: Set light energy/intensity
- set_shadow: Enable/disable shadows
- set_range: Set light range (OmniLight/SpotLight)
- set_angle: Set spot angle (SpotLight only)
- set_bake_mode: Set light bake mode
- list: List all lights in scene

LIGHT TYPES (3D):
- directional_light_3d: Sun/moon light
- omni_light_3d: Point light, emits in all directions
- spot_light_3d: Cone-shaped light

LIGHT TYPES (2D):
- directional_light_2d: Global 2D directional light
- point_light_2d: 2D point light with texture

EXAMPLES:
- Create light: {"action": "create", "type": "omni_light_3d", "parent": "/root/Scene"}
- Set color: {"action": "set_color", "path": "/root/OmniLight3D", "color": {"r": 1, "g": 0.9, "b": 0.8}}
- Set energy: {"action": "set_energy", "path": "/root/OmniLight3D", "energy": 2.0}
- Enable shadows: {"action": "set_shadow", "path": "/root/DirectionalLight3D", "enabled": true}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_color", "set_energy", "set_shadow", "set_range", "set_angle", "set_bake_mode", "list"],
						"description": "Light action"
					},
					"path": {
						"type": "string",
						"description": "Light node path"
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
						"enum": ["directional_light_3d", "omni_light_3d", "spot_light_3d", "directional_light_2d", "point_light_2d"],
						"description": "Light type"
					},
					"color": {
						"type": "object",
						"description": "Light color {r, g, b}"
					},
					"energy": {
						"type": "number",
						"description": "Light energy/intensity"
					},
					"enabled": {
						"type": "boolean",
						"description": "Shadow enabled state"
					},
					"range": {
						"type": "number",
						"description": "Light range"
					},
					"angle": {
						"type": "number",
						"description": "Spot angle in degrees"
					},
					"bake_mode": {
						"type": "string",
						"enum": ["disabled", "static", "dynamic"],
						"description": "Light bake mode"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "environment",
			"description": """ENVIRONMENT: Configure WorldEnvironment and Environment resources.

ACTIONS:
- create: Create WorldEnvironment node with Environment
- get_info: Get environment settings
- set_background: Set background mode (sky, color, canvas, camera_feed)
- set_background_color: Set background color
- set_ambient: Configure ambient light
- set_fog: Configure volumetric fog
- set_glow: Configure glow/bloom effect
- set_ssao: Configure screen-space ambient occlusion
- set_ssr: Configure screen-space reflections
- set_sdfgi: Configure signed distance field GI
- set_tonemap: Configure tonemapping
- set_adjustments: Configure color adjustments

EXAMPLES:
- Create environment: {"action": "create", "parent": "/root/Scene"}
- Set background: {"action": "set_background", "path": "/root/WorldEnvironment", "mode": "sky"}
- Set ambient: {"action": "set_ambient", "path": "/root/WorldEnvironment", "source": "sky", "energy": 1.0}
- Enable glow: {"action": "set_glow", "path": "/root/WorldEnvironment", "enabled": true, "intensity": 1.0}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_background", "set_background_color", "set_ambient", "set_fog", "set_glow", "set_ssao", "set_ssr", "set_sdfgi", "set_tonemap", "set_adjustments"],
						"description": "Environment action"
					},
					"path": {
						"type": "string",
						"description": "WorldEnvironment node path"
					},
					"parent": {
						"type": "string",
						"description": "Parent node path for creation"
					},
					"mode": {
						"type": "string",
						"description": "Background mode"
					},
					"color": {
						"type": "object",
						"description": "Color value"
					},
					"source": {
						"type": "string",
						"description": "Ambient source"
					},
					"energy": {
						"type": "number",
						"description": "Energy/intensity value"
					},
					"enabled": {
						"type": "boolean",
						"description": "Feature enabled state"
					},
					"intensity": {
						"type": "number",
						"description": "Effect intensity"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "sky",
			"description": """SKY: Configure Sky resources for environments.

ACTIONS:
- create: Create Sky resource for environment
- get_info: Get sky settings
- set_procedural: Configure ProceduralSkyMaterial
- set_physical: Configure PhysicalSkyMaterial
- set_panorama: Set panorama sky texture
- set_radiance_size: Set radiance texture size
- set_process_mode: Set sky process mode

PROCEDURAL SKY PROPERTIES:
- sky_top_color, sky_horizon_color
- ground_bottom_color, ground_horizon_color
- sun_angle_max, sun_curve

PHYSICAL SKY PROPERTIES:
- rayleigh_coefficient, mie_coefficient
- sun_disk_scale, ground_color

EXAMPLES:
- Create procedural sky: {"action": "create", "path": "/root/WorldEnvironment", "type": "procedural"}
- Set procedural colors: {"action": "set_procedural", "path": "/root/WorldEnvironment", "sky_top_color": {"r": 0.4, "g": 0.6, "b": 1.0}}
- Set panorama: {"action": "set_panorama", "path": "/root/WorldEnvironment", "texture": "res://sky.hdr"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get_info", "set_procedural", "set_physical", "set_panorama", "set_radiance_size", "set_process_mode"],
						"description": "Sky action"
					},
					"path": {
						"type": "string",
						"description": "WorldEnvironment node path"
					},
					"type": {
						"type": "string",
						"enum": ["procedural", "physical", "panorama"],
						"description": "Sky type"
					},
					"texture": {
						"type": "string",
						"description": "Panorama texture path"
					},
					"sky_top_color": {
						"type": "object",
						"description": "Sky top color"
					},
					"sky_horizon_color": {
						"type": "object",
						"description": "Sky horizon color"
					},
					"ground_bottom_color": {
						"type": "object",
						"description": "Ground bottom color"
					},
					"ground_horizon_color": {
						"type": "object",
						"description": "Ground horizon color"
					},
					"sun_angle_max": {
						"type": "number",
						"description": "Maximum sun angle"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"light":
			return _execute_light(args)
		"environment":
			return _execute_environment(args)
		"sky":
			return _execute_sky(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


func _execute_light(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_light(args)
		"get_info":
			return _get_light_info(args.get("path", ""))
		"set_color":
			return _set_light_color(args.get("path", ""), args.get("color", {}))
		"set_energy":
			return _set_light_property(args.get("path", ""), "light_energy", args.get("energy", 1.0))
		"set_shadow":
			return _set_light_property(args.get("path", ""), "shadow_enabled", args.get("enabled", true))
		"set_range":
			return _set_light_range(args.get("path", ""), args.get("range", 5.0))
		"set_angle":
			return _set_spot_angle(args.get("path", ""), args.get("angle", 45.0))
		"set_bake_mode":
			return _set_bake_mode(args.get("path", ""), args.get("bake_mode", "disabled"))
		"list":
			return _list_lights()
		_:
			return _error("Unknown action: %s" % action)


func _create_light(args: Dictionary) -> Dictionary:
	var light_type = args.get("type", "omni_light_3d")
	var parent_path = args.get("parent", "")
	var node_name = args.get("name", "")

	if parent_path.is_empty():
		return _error("Parent path is required")

	var parent = _find_node_by_path(parent_path)
	if not parent:
		return _error("Parent not found: %s" % parent_path)

	var light: Node
	match light_type:
		"directional_light_3d":
			light = DirectionalLight3D.new()
		"omni_light_3d":
			light = OmniLight3D.new()
		"spot_light_3d":
			light = SpotLight3D.new()
		"directional_light_2d":
			light = DirectionalLight2D.new()
		"point_light_2d":
			light = PointLight2D.new()
		_:
			return _error("Unknown light type: %s" % light_type)

	if node_name.is_empty():
		node_name = light_type.to_pascal_case()
	light.name = node_name

	parent.add_child(light)
	light.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(light),
		"type": light_type,
		"name": node_name
	}, "Light created")


func _get_light_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var info = {
		"path": path,
		"type": node.get_class()
	}

	if node is Light3D:
		info["color"] = _serialize_value(node.light_color)
		info["energy"] = node.light_energy
		info["shadow_enabled"] = node.shadow_enabled
		info["bake_mode"] = node.light_bake_mode

		if node is OmniLight3D:
			info["range"] = node.omni_range
			info["attenuation"] = node.omni_attenuation
		elif node is SpotLight3D:
			info["range"] = node.spot_range
			info["angle"] = node.spot_angle
			info["angle_attenuation"] = node.spot_angle_attenuation
		elif node is DirectionalLight3D:
			info["angular_distance"] = node.light_angular_distance
	elif node is Light2D:
		info["color"] = _serialize_value(node.color)
		info["energy"] = node.energy
		info["shadow_enabled"] = node.shadow_enabled

		if node is PointLight2D:
			info["texture_scale"] = node.texture_scale
	else:
		return _error("Node is not a Light")

	return _success(info)


func _set_light_color(path: String, color_dict: Dictionary) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	var color = Color(
		color_dict.get("r", 1.0),
		color_dict.get("g", 1.0),
		color_dict.get("b", 1.0),
		color_dict.get("a", 1.0)
	)

	if node is Light3D:
		node.light_color = color
	elif node is Light2D:
		node.color = color
	else:
		return _error("Node is not a Light")

	return _success({
		"path": path,
		"color": _serialize_value(color)
	}, "Light color set")


func _set_light_property(path: String, property: String, value) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	# Handle 2D light property name differences
	if node is Light2D:
		match property:
			"light_energy":
				property = "energy"
			"shadow_enabled":
				property = "shadow_enabled"

	if not property in node:
		return _error("Property not found: %s" % property)

	node.set(property, value)

	return _success({
		"path": path,
		"property": property,
		"value": value
	}, "Light property set")


func _set_light_range(path: String, range_val: float) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if node is OmniLight3D:
		node.omni_range = range_val
	elif node is SpotLight3D:
		node.spot_range = range_val
	else:
		return _error("Range is only available for OmniLight3D and SpotLight3D")

	return _success({
		"path": path,
		"range": range_val
	}, "Light range set")


func _set_spot_angle(path: String, angle: float) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is SpotLight3D:
		return _error("Angle is only available for SpotLight3D")

	node.spot_angle = angle

	return _success({
		"path": path,
		"angle": angle
	}, "Spot angle set")


func _set_bake_mode(path: String, mode: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is Light3D:
		return _error("Bake mode is only available for 3D lights")

	match mode:
		"disabled":
			node.light_bake_mode = Light3D.BAKE_DISABLED
		"static":
			node.light_bake_mode = Light3D.BAKE_STATIC
		"dynamic":
			node.light_bake_mode = Light3D.BAKE_DYNAMIC
		_:
			return _error("Unknown bake mode: %s" % mode)

	return _success({
		"path": path,
		"bake_mode": mode
	}, "Bake mode set")


func _list_lights() -> Dictionary:
	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	var lights: Array[Dictionary] = []
	_find_lights(root, lights)

	return _success({
		"count": lights.size(),
		"lights": lights
	})


func _find_lights(node: Node, result: Array[Dictionary]) -> void:
	if node is Light3D or node is Light2D:
		var info = {
			"path": _get_scene_path(node),
			"type": node.get_class()
		}
		if node is Light3D:
			info["energy"] = node.light_energy
			info["shadow_enabled"] = node.shadow_enabled
		else:
			info["energy"] = node.energy
			info["shadow_enabled"] = node.shadow_enabled
		result.append(info)

	for child in node.get_children():
		_find_lights(child, result)


func _execute_environment(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_environment(args.get("parent", ""))
		"get_info":
			return _get_environment_info(args.get("path", ""))
		"set_background":
			return _set_background_mode(args.get("path", ""), args.get("mode", ""))
		"set_background_color":
			return _set_background_color(args.get("path", ""), args.get("color", {}))
		"set_ambient":
			return _set_ambient(args)
		"set_fog":
			return _set_fog(args)
		"set_glow":
			return _set_glow(args)
		"set_ssao":
			return _set_ssao(args)
		"set_ssr":
			return _set_ssr(args)
		"set_sdfgi":
			return _set_sdfgi(args)
		"set_tonemap":
			return _set_tonemap(args)
		"set_adjustments":
			return _set_adjustments(args)
		_:
			return _error("Unknown action: %s" % action)


func _create_environment(parent_path: String) -> Dictionary:
	if parent_path.is_empty():
		return _error("Parent path is required")

	var parent = _find_node_by_path(parent_path)
	if not parent:
		return _error("Parent not found: %s" % parent_path)

	var world_env = WorldEnvironment.new()
	world_env.name = "WorldEnvironment"

	var env = Environment.new()
	env.background_mode = Environment.BG_SKY

	# Create default sky
	var sky = Sky.new()
	var sky_material = ProceduralSkyMaterial.new()
	sky.sky_material = sky_material
	env.sky = sky

	world_env.environment = env

	parent.add_child(world_env)
	world_env.owner = _get_edited_scene_root()

	return _success({
		"path": _get_scene_path(world_env)
	}, "WorldEnvironment created with default sky")


func _get_environment_info(path: String) -> Dictionary:
	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is WorldEnvironment:
		return _error("Node is not a WorldEnvironment")

	var env = node.environment
	if not env:
		return _error("No Environment resource")

	var info = {
		"path": path,
		"background_mode": env.background_mode,
		"ambient_light_source": env.ambient_light_source,
		"ambient_light_color": _serialize_value(env.ambient_light_color),
		"ambient_light_energy": env.ambient_light_energy,
		"fog_enabled": env.fog_enabled,
		"glow_enabled": env.glow_enabled,
		"ssao_enabled": env.ssao_enabled,
		"ssr_enabled": env.ssr_enabled,
		"sdfgi_enabled": env.sdfgi_enabled,
		"tonemap_mode": env.tonemap_mode,
		"has_sky": env.sky != null
	}

	return _success(info)


func _get_environment(path: String) -> Environment:
	var node = _find_node_by_path(path)
	if not node or not node is WorldEnvironment:
		return null
	return node.environment


func _set_background_mode(path: String, mode: String) -> Dictionary:
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	match mode:
		"clear_color":
			env.background_mode = Environment.BG_CLEAR_COLOR
		"color":
			env.background_mode = Environment.BG_COLOR
		"sky":
			env.background_mode = Environment.BG_SKY
		"canvas":
			env.background_mode = Environment.BG_CANVAS
		"keep":
			env.background_mode = Environment.BG_KEEP
		"camera_feed":
			env.background_mode = Environment.BG_CAMERA_FEED
		_:
			return _error("Unknown background mode: %s" % mode)

	return _success({
		"path": path,
		"background_mode": mode
	}, "Background mode set")


func _set_background_color(path: String, color_dict: Dictionary) -> Dictionary:
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	var color = Color(
		color_dict.get("r", 0.3),
		color_dict.get("g", 0.3),
		color_dict.get("b", 0.3),
		color_dict.get("a", 1.0)
	)

	env.background_color = color
	env.background_mode = Environment.BG_COLOR

	return _success({
		"path": path,
		"color": _serialize_value(color)
	}, "Background color set")


func _set_ambient(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	var source = args.get("source", "")
	if not source.is_empty():
		match source:
			"background":
				env.ambient_light_source = Environment.AMBIENT_SOURCE_BG
			"disabled":
				env.ambient_light_source = Environment.AMBIENT_SOURCE_DISABLED
			"color":
				env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
			"sky":
				env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY

	if args.has("energy"):
		env.ambient_light_energy = args.get("energy")

	if args.has("color"):
		var c = args.get("color")
		env.ambient_light_color = Color(c.get("r", 1), c.get("g", 1), c.get("b", 1))

	return _success({
		"path": path,
		"source": source,
		"energy": env.ambient_light_energy
	}, "Ambient light configured")


func _set_fog(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	if args.has("enabled"):
		env.fog_enabled = args.get("enabled")

	if args.has("density"):
		env.fog_density = args.get("density")

	if args.has("color"):
		var c = args.get("color")
		env.fog_light_color = Color(c.get("r", 0.5), c.get("g", 0.6), c.get("b", 0.7))

	if args.has("light_energy"):
		env.fog_light_energy = args.get("light_energy")

	if args.has("sun_scatter"):
		env.fog_sun_scatter = args.get("sun_scatter")

	return _success({
		"path": path,
		"fog_enabled": env.fog_enabled,
		"fog_density": env.fog_density
	}, "Fog configured")


func _set_glow(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	if args.has("enabled"):
		env.glow_enabled = args.get("enabled")

	if args.has("intensity"):
		env.glow_intensity = args.get("intensity")

	if args.has("strength"):
		env.glow_strength = args.get("strength")

	if args.has("bloom"):
		env.glow_bloom = args.get("bloom")

	if args.has("blend_mode"):
		var mode = args.get("blend_mode")
		match mode:
			"additive":
				env.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE
			"screen":
				env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SCREEN
			"softlight":
				env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SOFTLIGHT
			"replace":
				env.glow_blend_mode = Environment.GLOW_BLEND_MODE_REPLACE

	return _success({
		"path": path,
		"glow_enabled": env.glow_enabled,
		"glow_intensity": env.glow_intensity
	}, "Glow configured")


func _set_ssao(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	if args.has("enabled"):
		env.ssao_enabled = args.get("enabled")

	if args.has("radius"):
		env.ssao_radius = args.get("radius")

	if args.has("intensity"):
		env.ssao_intensity = args.get("intensity")

	if args.has("power"):
		env.ssao_power = args.get("power")

	return _success({
		"path": path,
		"ssao_enabled": env.ssao_enabled,
		"ssao_radius": env.ssao_radius
	}, "SSAO configured")


func _set_ssr(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	if args.has("enabled"):
		env.ssr_enabled = args.get("enabled")

	if args.has("max_steps"):
		env.ssr_max_steps = args.get("max_steps")

	if args.has("fade_in"):
		env.ssr_fade_in = args.get("fade_in")

	if args.has("fade_out"):
		env.ssr_fade_out = args.get("fade_out")

	return _success({
		"path": path,
		"ssr_enabled": env.ssr_enabled
	}, "SSR configured")


func _set_sdfgi(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	if args.has("enabled"):
		env.sdfgi_enabled = args.get("enabled")

	if args.has("use_occlusion"):
		env.sdfgi_use_occlusion = args.get("use_occlusion")

	if args.has("bounce_feedback"):
		env.sdfgi_bounce_feedback = args.get("bounce_feedback")

	if args.has("cascades"):
		env.sdfgi_cascades = args.get("cascades")

	if args.has("energy"):
		env.sdfgi_energy = args.get("energy")

	return _success({
		"path": path,
		"sdfgi_enabled": env.sdfgi_enabled
	}, "SDFGI configured")


func _set_tonemap(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	if args.has("mode"):
		var mode = args.get("mode")
		match mode:
			"linear":
				env.tonemap_mode = Environment.TONE_MAPPER_LINEAR
			"reinhardt":
				env.tonemap_mode = Environment.TONE_MAPPER_REINHARDT
			"filmic":
				env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
			"aces":
				env.tonemap_mode = Environment.TONE_MAPPER_ACES

	if args.has("exposure"):
		env.tonemap_exposure = args.get("exposure")

	if args.has("white"):
		env.tonemap_white = args.get("white")

	return _success({
		"path": path,
		"tonemap_mode": env.tonemap_mode,
		"tonemap_exposure": env.tonemap_exposure
	}, "Tonemap configured")


func _set_adjustments(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	if args.has("enabled"):
		env.adjustment_enabled = args.get("enabled")

	if args.has("brightness"):
		env.adjustment_brightness = args.get("brightness")

	if args.has("contrast"):
		env.adjustment_contrast = args.get("contrast")

	if args.has("saturation"):
		env.adjustment_saturation = args.get("saturation")

	return _success({
		"path": path,
		"adjustment_enabled": env.adjustment_enabled,
		"brightness": env.adjustment_brightness,
		"contrast": env.adjustment_contrast,
		"saturation": env.adjustment_saturation
	}, "Adjustments configured")


func _execute_sky(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"create":
			return _create_sky(args)
		"get_info":
			return _get_sky_info(args.get("path", ""))
		"set_procedural":
			return _set_procedural_sky(args)
		"set_physical":
			return _set_physical_sky(args)
		"set_panorama":
			return _set_panorama_sky(args)
		"set_radiance_size":
			return _set_sky_radiance(args.get("path", ""), args.get("size", 256))
		"set_process_mode":
			return _set_sky_process_mode(args.get("path", ""), args.get("mode", "automatic"))
		_:
			return _error("Unknown action: %s" % action)


func _create_sky(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var sky_type = args.get("type", "procedural")

	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	var sky = Sky.new()
	var material: Material

	match sky_type:
		"procedural":
			material = ProceduralSkyMaterial.new()
		"physical":
			material = PhysicalSkyMaterial.new()
		"panorama":
			material = PanoramaSkyMaterial.new()
		_:
			return _error("Unknown sky type: %s" % sky_type)

	sky.sky_material = material
	env.sky = sky
	env.background_mode = Environment.BG_SKY

	return _success({
		"path": path,
		"sky_type": sky_type
	}, "Sky created")


func _get_sky_info(path: String) -> Dictionary:
	var env = _get_environment(path)
	if not env:
		return _error("Environment not found")

	if not env.sky:
		return _error("No sky configured")

	var sky = env.sky
	var info = {
		"path": path,
		"radiance_size": sky.radiance_size,
		"process_mode": sky.process_mode
	}

	if sky.sky_material is ProceduralSkyMaterial:
		var mat = sky.sky_material as ProceduralSkyMaterial
		info["type"] = "procedural"
		info["sky_top_color"] = _serialize_value(mat.sky_top_color)
		info["sky_horizon_color"] = _serialize_value(mat.sky_horizon_color)
		info["ground_bottom_color"] = _serialize_value(mat.ground_bottom_color)
		info["ground_horizon_color"] = _serialize_value(mat.ground_horizon_color)
		info["sun_angle_max"] = mat.sun_angle_max
		info["sun_curve"] = mat.sun_curve
	elif sky.sky_material is PhysicalSkyMaterial:
		var mat = sky.sky_material as PhysicalSkyMaterial
		info["type"] = "physical"
		info["rayleigh_coefficient"] = mat.rayleigh_coefficient
		info["mie_coefficient"] = mat.mie_coefficient
		info["turbidity"] = mat.turbidity
		info["sun_disk_scale"] = mat.sun_disk_scale
	elif sky.sky_material is PanoramaSkyMaterial:
		info["type"] = "panorama"
		info["has_texture"] = sky.sky_material.panorama != null

	return _success(info)


func _set_procedural_sky(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env or not env.sky:
		return _error("Environment/sky not found")

	var mat = env.sky.sky_material
	if not mat is ProceduralSkyMaterial:
		mat = ProceduralSkyMaterial.new()
		env.sky.sky_material = mat

	if args.has("sky_top_color"):
		var c = args.get("sky_top_color")
		mat.sky_top_color = Color(c.get("r", 0.4), c.get("g", 0.6), c.get("b", 1.0))

	if args.has("sky_horizon_color"):
		var c = args.get("sky_horizon_color")
		mat.sky_horizon_color = Color(c.get("r", 0.6), c.get("g", 0.8), c.get("b", 1.0))

	if args.has("ground_bottom_color"):
		var c = args.get("ground_bottom_color")
		mat.ground_bottom_color = Color(c.get("r", 0.2), c.get("g", 0.17), c.get("b", 0.13))

	if args.has("ground_horizon_color"):
		var c = args.get("ground_horizon_color")
		mat.ground_horizon_color = Color(c.get("r", 0.6), c.get("g", 0.7), c.get("b", 0.9))

	if args.has("sun_angle_max"):
		mat.sun_angle_max = args.get("sun_angle_max")

	if args.has("sun_curve"):
		mat.sun_curve = args.get("sun_curve")

	return _success({
		"path": path,
		"type": "procedural"
	}, "Procedural sky configured")


func _set_physical_sky(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var env = _get_environment(path)
	if not env or not env.sky:
		return _error("Environment/sky not found")

	var mat = env.sky.sky_material
	if not mat is PhysicalSkyMaterial:
		mat = PhysicalSkyMaterial.new()
		env.sky.sky_material = mat

	if args.has("rayleigh_coefficient"):
		mat.rayleigh_coefficient = args.get("rayleigh_coefficient")

	if args.has("mie_coefficient"):
		mat.mie_coefficient = args.get("mie_coefficient")

	if args.has("turbidity"):
		mat.turbidity = args.get("turbidity")

	if args.has("sun_disk_scale"):
		mat.sun_disk_scale = args.get("sun_disk_scale")

	if args.has("ground_color"):
		var c = args.get("ground_color")
		mat.ground_color = Color(c.get("r", 0.1), c.get("g", 0.07), c.get("b", 0.03))

	return _success({
		"path": path,
		"type": "physical"
	}, "Physical sky configured")


func _set_panorama_sky(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var texture_path = args.get("texture", "")

	var env = _get_environment(path)
	if not env or not env.sky:
		return _error("Environment/sky not found")

	var mat = env.sky.sky_material
	if not mat is PanoramaSkyMaterial:
		mat = PanoramaSkyMaterial.new()
		env.sky.sky_material = mat

	if not texture_path.is_empty():
		var texture = load(texture_path)
		if texture:
			mat.panorama = texture
		else:
			return _error("Failed to load texture: %s" % texture_path)

	return _success({
		"path": path,
		"type": "panorama",
		"texture": texture_path
	}, "Panorama sky configured")


func _set_sky_radiance(path: String, size: int) -> Dictionary:
	var env = _get_environment(path)
	if not env or not env.sky:
		return _error("Environment/sky not found")

	# Valid sizes: 32, 64, 128, 256, 512, 1024, 2048
	var valid_sizes = [32, 64, 128, 256, 512, 1024, 2048]
	if not size in valid_sizes:
		return _error("Invalid radiance size. Valid: %s" % str(valid_sizes))

	env.sky.radiance_size = size

	return _success({
		"path": path,
		"radiance_size": size
	}, "Radiance size set")


func _set_sky_process_mode(path: String, mode: String) -> Dictionary:
	var env = _get_environment(path)
	if not env or not env.sky:
		return _error("Environment/sky not found")

	match mode:
		"automatic":
			env.sky.process_mode = Sky.PROCESS_MODE_AUTOMATIC
		"quality":
			env.sky.process_mode = Sky.PROCESS_MODE_QUALITY
		"incremental":
			env.sky.process_mode = Sky.PROCESS_MODE_INCREMENTAL
		"realtime":
			env.sky.process_mode = Sky.PROCESS_MODE_REALTIME
		_:
			return _error("Unknown process mode: %s" % mode)

	return _success({
		"path": path,
		"process_mode": mode
	}, "Process mode set")
