@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Animation tools for Godot MCP
## Provides animation creation, playback control, and track management


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "player",
			"description": """ANIMATION PLAYER: Control AnimationPlayer nodes.

ACTIONS:
- list: List all animations in an AnimationPlayer
- play: Play an animation
- stop: Stop current animation
- pause: Pause current animation
- seek: Seek to a specific time
- get_current: Get currently playing animation info
- set_speed: Set playback speed

EXAMPLES:
- List animations: {"action": "list", "path": "/root/Player/AnimationPlayer"}
- Play animation: {"action": "play", "path": "/root/Player/AnimationPlayer", "animation": "walk"}
- Play backwards: {"action": "play", "path": "/root/Player/AnimationPlayer", "animation": "walk", "backwards": true}
- Stop: {"action": "stop", "path": "/root/Player/AnimationPlayer"}
- Seek: {"action": "seek", "path": "/root/Player/AnimationPlayer", "time": 0.5}
- Set speed: {"action": "set_speed", "path": "/root/Player/AnimationPlayer", "speed": 2.0}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "play", "stop", "pause", "seek", "get_current", "set_speed"],
						"description": "Animation player action"
					},
					"path": {
						"type": "string",
						"description": "AnimationPlayer node path"
					},
					"animation": {
						"type": "string",
						"description": "Animation name to play"
					},
					"backwards": {
						"type": "boolean",
						"description": "Play animation backwards"
					},
					"time": {
						"type": "number",
						"description": "Time to seek to"
					},
					"speed": {
						"type": "number",
						"description": "Playback speed"
					}
				},
				"required": ["action", "path"]
			}
		},
		{
			"name": "animation",
			"description": """ANIMATION RESOURCE: Create and manage animation resources.

ACTIONS:
- create: Create a new animation
- delete: Delete an animation
- duplicate: Duplicate an animation
- rename: Rename an animation
- get_info: Get animation details (length, tracks, etc.)
- set_length: Set animation length
- set_loop: Set animation looping

EXAMPLES:
- Create animation: {"action": "create", "path": "/root/Player/AnimationPlayer", "name": "attack", "length": 1.0}
- Delete animation: {"action": "delete", "path": "/root/Player/AnimationPlayer", "name": "old_anim"}
- Rename: {"action": "rename", "path": "/root/Player/AnimationPlayer", "name": "walk", "new_name": "walk_slow"}
- Set loop: {"action": "set_loop", "path": "/root/Player/AnimationPlayer", "name": "idle", "loop": true}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "delete", "duplicate", "rename", "get_info", "set_length", "set_loop"],
						"description": "Animation action"
					},
					"path": {
						"type": "string",
						"description": "AnimationPlayer node path"
					},
					"name": {
						"type": "string",
						"description": "Animation name"
					},
					"new_name": {
						"type": "string",
						"description": "New name for rename"
					},
					"length": {
						"type": "number",
						"description": "Animation length in seconds"
					},
					"loop": {
						"type": "boolean",
						"description": "Enable/disable looping"
					}
				},
				"required": ["action", "path"]
			}
		},
		{
			"name": "track",
			"description": """ANIMATION TRACK: Manage animation tracks and keyframes.

ACTIONS:
- list: List all tracks in an animation
- add_property_track: Add a property track
- add_method_track: Add a method call track
- remove_track: Remove a track
- add_key: Add a keyframe to a track
- remove_key: Remove a keyframe

TRACK TYPES:
- Property tracks: Animate any node property
- Method tracks: Call methods at specific times

EXAMPLES:
- List tracks: {"action": "list", "path": "/root/Player/AnimationPlayer", "animation": "walk"}
- Add property track: {"action": "add_property_track", "path": "/root/Player/AnimationPlayer", "animation": "walk", "node_path": "Sprite2D:position"}
- Add key: {"action": "add_key", "path": "/root/Player/AnimationPlayer", "animation": "walk", "track": 0, "time": 0.0, "value": {"x": 0, "y": 0}}
- Add key at end: {"action": "add_key", "path": "/root/Player/AnimationPlayer", "animation": "walk", "track": 0, "time": 1.0, "value": {"x": 100, "y": 0}}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "add_property_track", "add_method_track", "remove_track", "add_key", "remove_key"],
						"description": "Track action"
					},
					"path": {
						"type": "string",
						"description": "AnimationPlayer node path"
					},
					"animation": {
						"type": "string",
						"description": "Animation name"
					},
					"node_path": {
						"type": "string",
						"description": "Node path and property (e.g., 'Sprite2D:position')"
					},
					"track": {
						"type": "integer",
						"description": "Track index"
					},
					"time": {
						"type": "number",
						"description": "Keyframe time"
					},
					"value": {
						"description": "Keyframe value"
					},
					"method": {
						"type": "string",
						"description": "Method name for method track"
					}
				},
				"required": ["action", "path"]
			}
		},
		{
			"name": "tween",
			"description": """TWEEN: Create and control tweens for procedural animations.

ACTIONS:
- create: Create a tween on a node
- property: Tween a property value
- method: Tween with method calls
- callback: Add a callback at the end
- info: Get tween documentation and common usages

EASING TYPES: LINEAR, SINE, QUAD, CUBIC, QUART, QUINT, EXPO, CIRC, ELASTIC, BACK, BOUNCE
TRANSITION TYPES: IN, OUT, IN_OUT, OUT_IN

EXAMPLES:
- Tween position: {"action": "property", "path": "/root/Player", "property": "position", "final_value": {"x": 100, "y": 200}, "duration": 1.0}
- Tween with easing: {"action": "property", "path": "/root/Player", "property": "position", "final_value": {"x": 100, "y": 200}, "duration": 1.0, "ease": "QUAD", "trans": "OUT"}
- Tween modulate: {"action": "property", "path": "/root/Sprite", "property": "modulate", "final_value": {"r": 1, "g": 0, "b": 0, "a": 1}, "duration": 0.5}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "property", "method", "callback", "info"],
						"description": "Tween action"
					},
					"path": {
						"type": "string",
						"description": "Target node path"
					},
					"property": {
						"type": "string",
						"description": "Property to tween"
					},
					"final_value": {
						"description": "Final value of the tween"
					},
					"duration": {
						"type": "number",
						"description": "Tween duration in seconds"
					},
					"ease": {
						"type": "string",
						"enum": ["LINEAR", "SINE", "QUAD", "CUBIC", "QUART", "QUINT", "EXPO", "CIRC", "ELASTIC", "BACK", "BOUNCE"],
						"description": "Easing type"
					},
					"trans": {
						"type": "string",
						"enum": ["IN", "OUT", "IN_OUT", "OUT_IN"],
						"description": "Transition type"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "animation_tree",
			"description": """ANIMATION TREE: Create and manage AnimationTree nodes for advanced animation blending.

ACTIONS:
- create: Create AnimationTree node with specified root type
- get: Get AnimationTree configuration
- set_active: Enable/disable the AnimationTree
- set_root: Set the root animation node type
- set_player: Assign AnimationPlayer to the tree
- set_parameter: Set a tree parameter value
- get_parameters: List all parameters

ROOT TYPES:
- state_machine: AnimationNodeStateMachine
- blend_tree: AnimationNodeBlendTree
- blend_space_1d: AnimationNodeBlendSpace1D
- blend_space_2d: AnimationNodeBlendSpace2D
- animation: AnimationNodeAnimation

EXAMPLES:
- Create tree: {"action": "create", "path": "/root/Player", "name": "AnimationTree", "root_type": "state_machine"}
- Set active: {"action": "set_active", "path": "/root/Player/AnimationTree", "active": true}
- Set player: {"action": "set_player", "path": "/root/Player/AnimationTree", "player": "/root/Player/AnimationPlayer"}
- Set parameter: {"action": "set_parameter", "path": "/root/Player/AnimationTree", "parameter": "parameters/blend_position", "value": 0.5}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["create", "get", "set_active", "set_root", "set_player", "set_parameter", "get_parameters"],
						"description": "AnimationTree action"
					},
					"path": {
						"type": "string",
						"description": "Node path (parent for create, tree for others)"
					},
					"name": {
						"type": "string",
						"description": "Name for new AnimationTree node"
					},
					"root_type": {
						"type": "string",
						"enum": ["state_machine", "blend_tree", "blend_space_1d", "blend_space_2d", "animation"],
						"description": "Root animation node type"
					},
					"active": {
						"type": "boolean",
						"description": "Enable/disable tree processing"
					},
					"player": {
						"type": "string",
						"description": "Path to AnimationPlayer"
					},
					"parameter": {
						"type": "string",
						"description": "Parameter path"
					},
					"value": {
						"description": "Parameter value"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "state_machine",
			"description": """STATE MACHINE: Configure AnimationNodeStateMachine for state-based animation.

ACTIONS:
- add_state: Add animation state to state machine
- remove_state: Remove a state
- add_transition: Add transition between states
- remove_transition: Remove a transition
- set_start: Set start state
- set_end: Set end state
- list_states: List all states
- list_transitions: List all transitions
- travel: Trigger travel to state (at runtime)
- get_current: Get current state

STATE TYPES:
- animation: Play a single animation
- blend_space_1d: 1D blend space
- blend_space_2d: 2D blend space
- blend_tree: Nested blend tree
- state_machine: Nested state machine

EXAMPLES:
- Add state: {"action": "add_state", "path": "/root/Player/AnimationTree", "state": "idle", "animation": "idle_anim"}
- Add blend state: {"action": "add_state", "path": "/root/Player/AnimationTree", "state": "locomotion", "type": "blend_space_2d"}
- Add transition: {"action": "add_transition", "path": "/root/Player/AnimationTree", "from": "idle", "to": "walk", "advance_mode": "auto"}
- Set start: {"action": "set_start", "path": "/root/Player/AnimationTree", "state": "idle"}
- Travel: {"action": "travel", "path": "/root/Player/AnimationTree", "state": "attack"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["add_state", "remove_state", "add_transition", "remove_transition", "set_start", "set_end", "list_states", "list_transitions", "travel", "get_current"],
						"description": "State machine action"
					},
					"path": {
						"type": "string",
						"description": "AnimationTree node path"
					},
					"state": {
						"type": "string",
						"description": "State name"
					},
					"animation": {
						"type": "string",
						"description": "Animation name for animation state"
					},
					"type": {
						"type": "string",
						"enum": ["animation", "blend_space_1d", "blend_space_2d", "blend_tree", "state_machine"],
						"description": "State node type"
					},
					"from": {
						"type": "string",
						"description": "Source state for transition"
					},
					"to": {
						"type": "string",
						"description": "Target state for transition"
					},
					"advance_mode": {
						"type": "string",
						"enum": ["auto", "enabled", "disabled"],
						"description": "Transition advance mode"
					},
					"switch_mode": {
						"type": "string",
						"enum": ["immediate", "sync", "at_end"],
						"description": "Transition switch mode"
					},
					"xfade_time": {
						"type": "number",
						"description": "Cross-fade duration"
					},
					"position": {
						"type": "object",
						"description": "State position in graph editor"
					}
				},
				"required": ["action", "path"]
			}
		},
		{
			"name": "blend_space",
			"description": """BLEND SPACE: Configure BlendSpace1D/2D for animation blending.

ACTIONS:
- add_point: Add blend point with animation
- remove_point: Remove a blend point
- set_blend_mode: Set blend mode
- get_points: List all blend points
- set_min_max: Set blend space bounds
- set_snap: Set snap value for grid
- triangulate: Re-triangulate 2D blend space

BLEND MODES (2D only):
- interpolated: Smooth interpolation
- discrete: Jump to nearest
- discrete_carry: Discrete with carry

EXAMPLES:
- Add 1D point: {"action": "add_point", "path": "/root/Player/AnimationTree", "node": "parameters/locomotion", "animation": "walk", "position": 0.5}
- Add 2D point: {"action": "add_point", "path": "/root/Player/AnimationTree", "node": "parameters/locomotion", "animation": "run_right", "position": {"x": 1, "y": 0}}
- Set bounds: {"action": "set_min_max", "path": "/root/Player/AnimationTree", "node": "parameters/locomotion", "min": -1, "max": 1}
- Set 2D bounds: {"action": "set_min_max", "path": "/root/Player/AnimationTree", "node": "parameters/locomotion", "min_x": -1, "max_x": 1, "min_y": -1, "max_y": 1}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["add_point", "remove_point", "set_blend_mode", "get_points", "set_min_max", "set_snap", "triangulate"],
						"description": "Blend space action"
					},
					"path": {
						"type": "string",
						"description": "AnimationTree node path"
					},
					"node": {
						"type": "string",
						"description": "Path to blend space node within tree"
					},
					"animation": {
						"type": "string",
						"description": "Animation name for blend point"
					},
					"position": {
						"description": "Blend position (number for 1D, {x,y} for 2D)"
					},
					"point_index": {
						"type": "integer",
						"description": "Point index to remove"
					},
					"blend_mode": {
						"type": "string",
						"enum": ["interpolated", "discrete", "discrete_carry"],
						"description": "Blend mode for 2D"
					},
					"min": {
						"type": "number",
						"description": "Minimum value (1D)"
					},
					"max": {
						"type": "number",
						"description": "Maximum value (1D)"
					},
					"min_x": {
						"type": "number",
						"description": "Minimum X value (2D)"
					},
					"max_x": {
						"type": "number",
						"description": "Maximum X value (2D)"
					},
					"min_y": {
						"type": "number",
						"description": "Minimum Y value (2D)"
					},
					"max_y": {
						"type": "number",
						"description": "Maximum Y value (2D)"
					},
					"snap": {
						"type": "number",
						"description": "Snap value for grid"
					}
				},
				"required": ["action", "path"]
			}
		},
		{
			"name": "blend_tree",
			"description": """BLEND TREE: Build AnimationNodeBlendTree for complex animation graphs.

ACTIONS:
- add_node: Add node to blend tree
- remove_node: Remove a node
- connect: Connect two nodes
- disconnect: Disconnect nodes
- set_position: Set node position in graph
- list_nodes: List all nodes and connections
- set_node_parameter: Set node-specific parameter

NODE TYPES:
- animation: AnimationNodeAnimation - plays animation
- blend2: AnimationNodeBlend2 - blend two animations
- blend3: AnimationNodeBlend3 - blend three animations
- add2: AnimationNodeAdd2 - additive blend
- add3: AnimationNodeAdd3 - additive blend 3
- one_shot: AnimationNodeOneShot - one-shot overlay
- time_scale: AnimationNodeTimeScale - speed control
- time_seek: AnimationNodeTimeSeek - seek control
- transition: AnimationNodeTransition - switch between inputs
- blend_space_1d: AnimationNodeBlendSpace1D
- blend_space_2d: AnimationNodeBlendSpace2D
- state_machine: AnimationNodeStateMachine

EXAMPLES:
- Add animation: {"action": "add_node", "path": "/root/Player/AnimationTree", "name": "idle", "type": "animation", "animation": "idle_anim"}
- Add blend: {"action": "add_node", "path": "/root/Player/AnimationTree", "name": "walk_blend", "type": "blend2"}
- Connect: {"action": "connect", "path": "/root/Player/AnimationTree", "from": "idle", "to": "walk_blend", "port": 0}
- Connect to output: {"action": "connect", "path": "/root/Player/AnimationTree", "from": "walk_blend", "to": "output"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["add_node", "remove_node", "connect", "disconnect", "set_position", "list_nodes", "set_node_parameter"],
						"description": "Blend tree action"
					},
					"path": {
						"type": "string",
						"description": "AnimationTree node path"
					},
					"name": {
						"type": "string",
						"description": "Node name in blend tree"
					},
					"type": {
						"type": "string",
						"enum": ["animation", "blend2", "blend3", "add2", "add3", "one_shot", "time_scale", "time_seek", "transition", "blend_space_1d", "blend_space_2d", "state_machine"],
						"description": "Node type to add"
					},
					"animation": {
						"type": "string",
						"description": "Animation name for animation nodes"
					},
					"from": {
						"type": "string",
						"description": "Source node name"
					},
					"to": {
						"type": "string",
						"description": "Target node name"
					},
					"port": {
						"type": "integer",
						"description": "Input port index on target node"
					},
					"position": {
						"type": "object",
						"description": "Node position {x, y}"
					},
					"parameter": {
						"type": "string",
						"description": "Parameter name for set_node_parameter"
					},
					"value": {
						"description": "Parameter value"
					}
				},
				"required": ["action", "path"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"player":
			return _execute_player(args)
		"animation":
			return _execute_animation(args)
		"track":
			return _execute_track(args)
		"tween":
			return _execute_tween(args)
		"animation_tree":
			return _execute_animation_tree(args)
		"state_machine":
			return _execute_state_machine(args)
		"blend_space":
			return _execute_blend_space(args)
		"blend_tree":
			return _execute_blend_tree(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== PLAYER ====================

func _execute_player(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is AnimationPlayer:
		return _error("Node is not an AnimationPlayer")

	var player: AnimationPlayer = node

	match action:
		"list":
			return _list_animations(player)
		"play":
			return _play_animation(player, args.get("animation", ""), args.get("backwards", false))
		"stop":
			return _stop_animation(player)
		"pause":
			return _pause_animation(player)
		"seek":
			return _seek_animation(player, args.get("time", 0.0))
		"get_current":
			return _get_current_animation(player)
		"set_speed":
			return _set_playback_speed(player, args.get("speed", 1.0))
		_:
			return _error("Unknown action: %s" % action)


func _list_animations(player: AnimationPlayer) -> Dictionary:
	var animations: Array[String] = []
	for anim_name in player.get_animation_list():
		animations.append(str(anim_name))

	return _success({
		"path": _get_scene_path(player),
		"count": animations.size(),
		"animations": animations
	})


func _play_animation(player: AnimationPlayer, anim_name: String, backwards: bool) -> Dictionary:
	if anim_name.is_empty():
		return _error("Animation name is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	if backwards:
		player.play_backwards(anim_name)
	else:
		player.play(anim_name)

	return _success({
		"path": _get_scene_path(player),
		"animation": anim_name,
		"backwards": backwards
	}, "Animation playing")


func _stop_animation(player: AnimationPlayer) -> Dictionary:
	player.stop()

	return _success({
		"path": _get_scene_path(player)
	}, "Animation stopped")


func _pause_animation(player: AnimationPlayer) -> Dictionary:
	player.pause()

	return _success({
		"path": _get_scene_path(player)
	}, "Animation paused")


func _seek_animation(player: AnimationPlayer, time: float) -> Dictionary:
	player.seek(time)

	return _success({
		"path": _get_scene_path(player),
		"time": time
	}, "Seeked to time")


func _get_current_animation(player: AnimationPlayer) -> Dictionary:
	var current = player.current_animation
	var playing = player.is_playing()

	return _success({
		"path": _get_scene_path(player),
		"current_animation": str(current),
		"is_playing": playing,
		"current_position": player.current_animation_position if playing else 0.0,
		"playback_speed": player.speed_scale
	})


func _set_playback_speed(player: AnimationPlayer, speed: float) -> Dictionary:
	player.speed_scale = speed

	return _success({
		"path": _get_scene_path(player),
		"speed": speed
	}, "Playback speed set")


# ==================== ANIMATION ====================

func _execute_animation(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is AnimationPlayer:
		return _error("Node is not an AnimationPlayer")

	var player: AnimationPlayer = node

	match action:
		"create":
			return _create_animation(player, args.get("name", ""), args.get("length", 1.0))
		"delete":
			return _delete_animation(player, args.get("name", ""))
		"duplicate":
			return _duplicate_animation(player, args.get("name", ""), args.get("new_name", ""))
		"rename":
			return _rename_animation(player, args.get("name", ""), args.get("new_name", ""))
		"get_info":
			return _get_animation_info(player, args.get("name", ""))
		"set_length":
			return _set_animation_length(player, args.get("name", ""), args.get("length", 1.0))
		"set_loop":
			return _set_animation_loop(player, args.get("name", ""), args.get("loop", true))
		_:
			return _error("Unknown action: %s" % action)


func _create_animation(player: AnimationPlayer, anim_name: String, length: float) -> Dictionary:
	if anim_name.is_empty():
		return _error("Animation name is required")

	if player.has_animation(anim_name):
		return _error("Animation already exists: %s" % anim_name)

	var anim = Animation.new()
	anim.length = length

	var library = player.get_animation_library("")
	if not library:
		library = AnimationLibrary.new()
		player.add_animation_library("", library)

	library.add_animation(anim_name, anim)

	return _success({
		"path": _get_scene_path(player),
		"name": anim_name,
		"length": length
	}, "Animation created")


func _delete_animation(player: AnimationPlayer, anim_name: String) -> Dictionary:
	if anim_name.is_empty():
		return _error("Animation name is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	var library = player.get_animation_library("")
	if library:
		library.remove_animation(anim_name)

	return _success({
		"path": _get_scene_path(player),
		"name": anim_name
	}, "Animation deleted")


func _duplicate_animation(player: AnimationPlayer, anim_name: String, new_name: String) -> Dictionary:
	if anim_name.is_empty():
		return _error("Animation name is required")
	if new_name.is_empty():
		return _error("New name is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	if player.has_animation(new_name):
		return _error("Animation already exists: %s" % new_name)

	var anim = player.get_animation(anim_name)
	var duplicate = anim.duplicate()

	var library = player.get_animation_library("")
	if not library:
		library = AnimationLibrary.new()
		player.add_animation_library("", library)

	library.add_animation(new_name, duplicate)

	return _success({
		"path": _get_scene_path(player),
		"original": anim_name,
		"duplicate": new_name
	}, "Animation duplicated")


func _rename_animation(player: AnimationPlayer, anim_name: String, new_name: String) -> Dictionary:
	if anim_name.is_empty():
		return _error("Animation name is required")
	if new_name.is_empty():
		return _error("New name is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	if player.has_animation(new_name):
		return _error("Animation already exists: %s" % new_name)

	var library = player.get_animation_library("")
	if library:
		library.rename_animation(anim_name, new_name)

	return _success({
		"path": _get_scene_path(player),
		"old_name": anim_name,
		"new_name": new_name
	}, "Animation renamed")


func _get_animation_info(player: AnimationPlayer, anim_name: String) -> Dictionary:
	if anim_name.is_empty():
		return _error("Animation name is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	var anim = player.get_animation(anim_name)

	return _success({
		"path": _get_scene_path(player),
		"name": anim_name,
		"length": anim.length,
		"loop_mode": anim.loop_mode,
		"track_count": anim.get_track_count(),
		"step": anim.step
	})


func _set_animation_length(player: AnimationPlayer, anim_name: String, length: float) -> Dictionary:
	if anim_name.is_empty():
		return _error("Animation name is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	var anim = player.get_animation(anim_name)
	anim.length = length

	return _success({
		"path": _get_scene_path(player),
		"name": anim_name,
		"length": length
	}, "Animation length set")


func _set_animation_loop(player: AnimationPlayer, anim_name: String, loop: bool) -> Dictionary:
	if anim_name.is_empty():
		return _error("Animation name is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	var anim = player.get_animation(anim_name)
	anim.loop_mode = Animation.LOOP_LINEAR if loop else Animation.LOOP_NONE

	return _success({
		"path": _get_scene_path(player),
		"name": anim_name,
		"loop": loop
	}, "Animation loop set")


# ==================== TRACK ====================

func _execute_track(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")
	var anim_name = args.get("animation", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is AnimationPlayer:
		return _error("Node is not an AnimationPlayer")

	var player: AnimationPlayer = node

	if anim_name.is_empty() and action != "list":
		return _error("Animation name is required")

	match action:
		"list":
			return _list_tracks(player, anim_name)
		"add_property_track":
			return _add_property_track(player, anim_name, args.get("node_path", ""))
		"add_method_track":
			return _add_method_track(player, anim_name, args.get("node_path", ""))
		"remove_track":
			return _remove_track(player, anim_name, args.get("track", 0))
		"add_key":
			return _add_key(player, anim_name, args.get("track", 0), args.get("time", 0.0), args.get("value"))
		"remove_key":
			return _remove_key(player, anim_name, args.get("track", 0), args.get("key", 0))
		_:
			return _error("Unknown action: %s" % action)


func _list_tracks(player: AnimationPlayer, anim_name: String) -> Dictionary:
	if anim_name.is_empty():
		return _error("Animation name is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	var anim = player.get_animation(anim_name)
	var tracks: Array[Dictionary] = []

	for i in anim.get_track_count():
		var track_info = {
			"index": i,
			"path": str(anim.track_get_path(i)),
			"type": anim.track_get_type(i),
			"key_count": anim.track_get_key_count(i)
		}
		tracks.append(track_info)

	return _success({
		"path": _get_scene_path(player),
		"animation": anim_name,
		"track_count": tracks.size(),
		"tracks": tracks
	})


func _add_property_track(player: AnimationPlayer, anim_name: String, node_path: String) -> Dictionary:
	if node_path.is_empty():
		return _error("Node path is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	var anim = player.get_animation(anim_name)
	var track_idx = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_idx, NodePath(node_path))

	return _success({
		"path": _get_scene_path(player),
		"animation": anim_name,
		"track_index": track_idx,
		"node_path": node_path
	}, "Property track added")


func _add_method_track(player: AnimationPlayer, anim_name: String, node_path: String) -> Dictionary:
	if node_path.is_empty():
		return _error("Node path is required")

	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	var anim = player.get_animation(anim_name)
	var track_idx = anim.add_track(Animation.TYPE_METHOD)
	anim.track_set_path(track_idx, NodePath(node_path))

	return _success({
		"path": _get_scene_path(player),
		"animation": anim_name,
		"track_index": track_idx,
		"node_path": node_path
	}, "Method track added")


func _remove_track(player: AnimationPlayer, anim_name: String, track_idx: int) -> Dictionary:
	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	var anim = player.get_animation(anim_name)

	if track_idx < 0 or track_idx >= anim.get_track_count():
		return _error("Track index out of range")

	anim.remove_track(track_idx)

	return _success({
		"path": _get_scene_path(player),
		"animation": anim_name,
		"removed_track": track_idx
	}, "Track removed")


func _add_key(player: AnimationPlayer, anim_name: String, track_idx: int, time: float, value) -> Dictionary:
	if not player.has_animation(anim_name):
		var available = player.get_animation_list()
		return _error("Animation not found: %s" % anim_name, null,
			["Available animations: %s" % ", ".join(available)] if available.size() > 0 else [])

	var anim = player.get_animation(anim_name)

	if track_idx < 0 or track_idx >= anim.get_track_count():
		return _error("Track index out of range: %d" % track_idx, {
			"track_count": anim.get_track_count()
		}, ["Valid track indices: 0 to %d" % (anim.get_track_count() - 1)] if anim.get_track_count() > 0 else ["Animation has no tracks. Add a track first."])

	# Validate time
	if time < 0:
		return _error("Time cannot be negative", {"provided_time": time}, ["Time must be >= 0"])
	if time > anim.length:
		return _error("Time exceeds animation length", {
			"provided_time": time,
			"animation_length": anim.length
		}, ["Maximum time for this animation: %s seconds" % anim.length])

	# Get track info for better error messages
	var track_path = anim.track_get_path(track_idx)
	var track_type = anim.track_get_type(track_idx)

	# Validate value type based on track
	if value == null:
		return _error("Value is required for keyframe", {
			"track_path": str(track_path),
			"track_type": track_type
		}, _get_value_hints_for_track(track_type, track_path))

	# Try to determine expected type from track path and existing keys
	var expected_type = _get_expected_track_value_type(player, anim, track_idx, track_path)

	# Convert value based on type
	var converted_value = _convert_track_value(value)

	# Validate converted value type matches expected
	if expected_type != TYPE_NIL:
		var converted_type = typeof(converted_value)
		if converted_type != expected_type:
			var hints = _get_value_hints_for_track(track_type, track_path)
			hints.append("Your value was interpreted as: %s" % _type_to_string(converted_type))
			return _error("Value type mismatch for track", {
				"track_path": str(track_path),
				"expected_type": _type_to_string(expected_type),
				"provided_type": _type_to_string(converted_type),
				"provided_value": value
			}, hints)

	var key_idx = anim.track_insert_key(track_idx, time, converted_value)

	# Verify the key was added correctly by checking its value
	if key_idx >= 0:
		var inserted_value = anim.track_get_key_value(track_idx, key_idx)
		var inserted_type = typeof(inserted_value)

		# Check if value type is wrong (e.g., string instead of Vector2)
		if expected_type != TYPE_NIL and inserted_type != expected_type:
			# Remove the bad key
			anim.track_remove_key(track_idx, key_idx)
			return _error("Keyframe value type invalid", {
				"track_path": str(track_path),
				"expected_type": _type_to_string(expected_type),
				"actual_type": _type_to_string(inserted_type),
				"provided_value": value
			}, _get_value_hints_for_track(track_type, track_path))

	return _success({
		"path": _get_scene_path(player),
		"animation": anim_name,
		"track": track_idx,
		"track_path": str(track_path),
		"key_index": key_idx,
		"time": time,
		"value": _serialize_value(converted_value)
	}, "Keyframe added")


func _remove_key(player: AnimationPlayer, anim_name: String, track_idx: int, key_idx: int) -> Dictionary:
	if not player.has_animation(anim_name):
		return _error("Animation not found: %s" % anim_name)

	var anim = player.get_animation(anim_name)

	if track_idx < 0 or track_idx >= anim.get_track_count():
		return _error("Track index out of range")

	if key_idx < 0 or key_idx >= anim.track_get_key_count(track_idx):
		return _error("Key index out of range")

	anim.track_remove_key(track_idx, key_idx)

	return _success({
		"path": _get_scene_path(player),
		"animation": anim_name,
		"track": track_idx,
		"removed_key": key_idx
	}, "Keyframe removed")


func _convert_track_value(value):
	# If value is a string that looks like JSON, try to parse it
	if value is String:
		var trimmed = value.strip_edges()
		if trimmed.begins_with("{") or trimmed.begins_with("["):
			var json = JSON.new()
			var err = json.parse(trimmed)
			if err == OK:
				value = json.get_data()

	if value is Dictionary:
		if value.has("x") and value.has("y"):
			if value.has("z"):
				if value.has("w"):
					return Vector4(value.get("x", 0), value.get("y", 0), value.get("z", 0), value.get("w", 0))
				return Vector3(value.get("x", 0), value.get("y", 0), value.get("z", 0))
			return Vector2(value.get("x", 0), value.get("y", 0))
		elif value.has("r") and value.has("g") and value.has("b"):
			return Color(value.get("r", 1), value.get("g", 1), value.get("b", 1), value.get("a", 1))
	return value


func _get_expected_track_value_type(player: AnimationPlayer, anim: Animation, track_idx: int, track_path: NodePath) -> int:
	"""Determine the expected value type for a track"""

	# First, check existing keys in the track
	var key_count = anim.track_get_key_count(track_idx)
	if key_count > 0:
		var existing_value = anim.track_get_key_value(track_idx, 0)
		var existing_type = typeof(existing_value)
		# If existing value is not a string (which would indicate a bad key), use its type
		if existing_type != TYPE_STRING or not str(existing_value).begins_with("{"):
			return existing_type

	# Try to get the type from the actual node property
	var path_str = str(track_path)
	var path_parts = path_str.split(":")
	if path_parts.size() >= 2:
		var node_path = path_parts[0]
		var property_name = path_parts[1]

		# Get the node relative to the AnimationPlayer's root
		var root = player.get_node_or_null(player.root_node)
		if root:
			var target_node = root.get_node_or_null(node_path)
			if target_node and property_name in target_node:
				var prop_value = target_node.get(property_name)
				return typeof(prop_value)

	# Guess from property name in track path
	if ":position" in path_str:
		return TYPE_VECTOR2  # Could be Vector3 for 3D
	elif ":rotation" in path_str:
		return TYPE_FLOAT
	elif ":scale" in path_str:
		return TYPE_VECTOR2  # Could be Vector3 for 3D
	elif ":modulate" in path_str or ":self_modulate" in path_str or ":color" in path_str:
		return TYPE_COLOR
	elif ":visible" in path_str:
		return TYPE_BOOL
	elif ":z_index" in path_str:
		return TYPE_INT

	return TYPE_NIL  # Unknown


func _get_value_hints_for_track(track_type: int, track_path: NodePath) -> Array:
	"""Get hints for what value format is expected for a track"""
	var hints: Array = []
	var path_str = str(track_path)

	# Check track type
	match track_type:
		Animation.TYPE_VALUE:
			# Guess from property name
			if ":position" in path_str:
				hints.append("For position, use: {\"x\": number, \"y\": number} or {\"x\": n, \"y\": n, \"z\": n} for 3D")
			elif ":rotation" in path_str:
				hints.append("For rotation, use a number (radians)")
			elif ":scale" in path_str:
				hints.append("For scale, use: {\"x\": number, \"y\": number}")
			elif ":modulate" in path_str or ":color" in path_str:
				hints.append("For color, use: {\"r\": 0-1, \"g\": 0-1, \"b\": 0-1, \"a\": 0-1}")
			elif ":visible" in path_str:
				hints.append("For visibility, use: true or false")
			else:
				hints.append("Value format depends on the property type")
				hints.append("Common formats: number, boolean, {\"x\": n, \"y\": n}, {\"r\": n, \"g\": n, \"b\": n, \"a\": n}")
		Animation.TYPE_METHOD:
			hints.append("For method tracks, value should be an array of arguments")
		Animation.TYPE_BEZIER:
			hints.append("For bezier tracks, value should be a number")
		Animation.TYPE_AUDIO:
			hints.append("For audio tracks, value should be an AudioStream resource path")
		Animation.TYPE_ANIMATION:
			hints.append("For animation tracks, value should be an animation name")

	return hints


# ==================== TWEEN ====================

func _execute_tween(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"info":
			return _get_tween_info()
		"property":
			return _tween_property(args)
		"create", "method", "callback":
			return _success({
				"note": "Tweens are best created via scripts. Use 'property' action for simple tweens, or add tween code to your scripts."
			}, "See info action for tween documentation")
		_:
			return _error("Unknown action: %s" % action)


func _get_tween_info() -> Dictionary:
	return _success({
		"description": "Tweens provide procedural animations for properties",
		"example_code": """
# Create tween in GDScript:
var tween = create_tween()
tween.tween_property($Sprite2D, "position", Vector2(100, 200), 1.0)
tween.tween_property($Sprite2D, "modulate", Color.RED, 0.5)

# With easing:
tween.tween_property($Sprite2D, "position", Vector2(100, 200), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

# Parallel tweens:
tween.set_parallel(true)
tween.tween_property($Sprite2D, "position", Vector2(100, 200), 1.0)
tween.tween_property($Sprite2D, "rotation", PI, 1.0)
""",
		"ease_types": ["EASE_IN", "EASE_OUT", "EASE_IN_OUT", "EASE_OUT_IN"],
		"trans_types": ["TRANS_LINEAR", "TRANS_SINE", "TRANS_QUAD", "TRANS_CUBIC", "TRANS_QUART", "TRANS_QUINT", "TRANS_EXPO", "TRANS_CIRC", "TRANS_ELASTIC", "TRANS_BACK", "TRANS_BOUNCE"]
	})


func _tween_property(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var property = args.get("property", "")
	var final_value = args.get("final_value")
	var duration = args.get("duration", 1.0)

	if path.is_empty():
		return _error("Path is required")
	if property.is_empty():
		return _error("Property is required")
	if final_value == null:
		return _error("Final value is required", null, [
			"Provide 'final_value' - the target value for the tween",
			"For Vector2: {\"x\": number, \"y\": number}",
			"For Color: {\"r\": 0-1, \"g\": 0-1, \"b\": 0-1, \"a\": 0-1}",
			"For numbers: just the number"
		])

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	# Check if property exists
	if not property in node:
		var available: Array = []
		for prop in node.get_property_list():
			var prop_name = str(prop.name)
			if prop.usage & PROPERTY_USAGE_EDITOR and not prop_name.begins_with("_"):
				if property.to_lower() in prop_name.to_lower():
					available.append(prop_name)
		return _error("Property not found: %s" % property, {"node_type": node.get_class()},
			["Similar properties: %s" % ", ".join(available.slice(0, 5))] if not available.is_empty() else [])

	# Validate duration
	if duration <= 0:
		return _error("Duration must be positive", {"provided_duration": duration})

	# Get property info for type validation
	var current_value = node.get(property)
	var expected_type = typeof(current_value)

	# Convert value
	var converted_value = _convert_track_value(final_value)

	# Validate value type matches property type
	var validation = _validate_value_type(final_value, expected_type)
	if not validation["valid"]:
		var hints = validation["hints"]
		hints.append("Property '%s' expects type: %s" % [property, _type_to_string(expected_type)])
		return _error("Invalid value type for tween", {
			"property": property,
			"expected_type": _type_to_string(expected_type),
			"provided_value": final_value
		}, hints)

	# Create tween
	var tween = node.create_tween()
	var tweener = tween.tween_property(node, property, converted_value, duration)

	# Apply easing
	var ease_type = args.get("ease", "")
	var trans_type = args.get("trans", "")

	if not ease_type.is_empty():
		var ease_enum = _get_ease_enum(ease_type)
		if ease_enum < 0:
			return _error("Invalid ease type: %s" % ease_type, null, [
				"Valid ease types: IN, OUT, IN_OUT, OUT_IN"
			])
		tweener.set_ease(ease_enum)

	if not trans_type.is_empty():
		var trans_enum = _get_trans_enum(trans_type)
		if trans_enum < 0:
			return _error("Invalid transition type: %s" % trans_type, null, [
				"Valid transition types: LINEAR, SINE, QUAD, CUBIC, QUART, QUINT, EXPO, CIRC, ELASTIC, BACK, BOUNCE"
			])
		tweener.set_trans(trans_enum)

	return _success({
		"path": path,
		"property": property,
		"start_value": _serialize_value(current_value) if current_value != null else null,
		"final_value": final_value,
		"duration": duration,
		"ease": ease_type if not ease_type.is_empty() else "default",
		"trans": trans_type if not trans_type.is_empty() else "default"
	}, "Tween started")


func _get_ease_enum(ease_name: String) -> int:
	match ease_name.to_upper():
		"IN": return Tween.EASE_IN
		"OUT": return Tween.EASE_OUT
		"IN_OUT": return Tween.EASE_IN_OUT
		"OUT_IN": return Tween.EASE_OUT_IN
	return -1


func _get_trans_enum(trans_name: String) -> int:
	match trans_name.to_upper():
		"LINEAR": return Tween.TRANS_LINEAR
		"SINE": return Tween.TRANS_SINE
		"QUAD": return Tween.TRANS_QUAD
		"CUBIC": return Tween.TRANS_CUBIC
		"QUART": return Tween.TRANS_QUART
		"QUINT": return Tween.TRANS_QUINT
		"EXPO": return Tween.TRANS_EXPO
		"CIRC": return Tween.TRANS_CIRC
		"ELASTIC": return Tween.TRANS_ELASTIC
		"BACK": return Tween.TRANS_BACK
		"BOUNCE": return Tween.TRANS_BOUNCE
	return -1


# ==================== ANIMATION TREE ====================

func _execute_animation_tree(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	match action:
		"create":
			return _create_animation_tree(args)
		"get":
			return _get_animation_tree(path)
		"set_active":
			return _set_tree_active(path, args.get("active", true))
		"set_root":
			return _set_tree_root(path, args.get("root_type", "state_machine"))
		"set_player":
			return _set_tree_player(path, args.get("player", ""))
		"set_parameter":
			return _set_tree_parameter(path, args.get("parameter", ""), args.get("value"))
		"get_parameters":
			return _get_tree_parameters(path)
		_:
			return _error("Unknown action: %s" % action)


func _create_animation_tree(args: Dictionary) -> Dictionary:
	var path = args.get("path", "")
	var name = args.get("name", "AnimationTree")
	var root_type = args.get("root_type", "state_machine")

	var parent = _find_node_by_path(path)
	if not parent:
		return _error("Parent node not found: %s" % path)

	var tree = AnimationTree.new()
	tree.name = name

	# Create root node based on type
	var root_node = _create_animation_node(root_type)
	if not root_node:
		return _error("Unknown root type: %s" % root_type)

	tree.tree_root = root_node
	parent.add_child(tree)
	tree.owner = parent.owner if parent.owner else parent

	return _success({
		"path": _get_scene_path(tree),
		"name": name,
		"root_type": root_type
	}, "AnimationTree created")


func _create_animation_node(type: String) -> AnimationRootNode:
	match type:
		"state_machine":
			return AnimationNodeStateMachine.new()
		"blend_tree":
			return AnimationNodeBlendTree.new()
		"blend_space_1d":
			return AnimationNodeBlendSpace1D.new()
		"blend_space_2d":
			return AnimationNodeBlendSpace2D.new()
		"animation":
			return AnimationNodeAnimation.new()
		_:
			return null


func _get_animation_tree(path: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is AnimationTree:
		return _error("Node is not an AnimationTree")

	var tree: AnimationTree = node
	var root_type = ""
	if tree.tree_root:
		root_type = tree.tree_root.get_class()

	return _success({
		"path": _get_scene_path(tree),
		"active": tree.active,
		"root_type": root_type,
		"anim_player": str(tree.anim_player) if tree.anim_player else "",
		"advance_expression_base_node": str(tree.advance_expression_base_node)
	})


func _set_tree_active(path: String, active: bool) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is AnimationTree:
		return _error("Node is not an AnimationTree")

	var tree: AnimationTree = node
	tree.active = active

	return _success({
		"path": _get_scene_path(tree),
		"active": active
	}, "AnimationTree %s" % ("activated" if active else "deactivated"))


func _set_tree_root(path: String, root_type: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is AnimationTree:
		return _error("Node is not an AnimationTree")

	var tree: AnimationTree = node
	var root_node = _create_animation_node(root_type)
	if not root_node:
		return _error("Unknown root type: %s" % root_type)

	tree.tree_root = root_node

	return _success({
		"path": _get_scene_path(tree),
		"root_type": root_type
	}, "Root node set")


func _set_tree_player(path: String, player_path: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is AnimationTree:
		return _error("Node is not an AnimationTree")

	var tree: AnimationTree = node

	# Convert absolute path to relative
	var player = _find_node_by_path(player_path)
	if not player:
		return _error("AnimationPlayer not found: %s" % player_path)

	if not player is AnimationPlayer:
		return _error("Node is not an AnimationPlayer: %s" % player_path)

	tree.anim_player = tree.get_path_to(player)

	return _success({
		"path": _get_scene_path(tree),
		"player": str(tree.anim_player)
	}, "AnimationPlayer assigned")


func _set_tree_parameter(path: String, parameter: String, value) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is AnimationTree:
		return _error("Node is not an AnimationTree")

	var tree: AnimationTree = node

	if parameter.is_empty():
		return _error("Parameter path is required")

	# Convert value if needed
	var converted_value = _convert_track_value(value)

	tree.set(parameter, converted_value)

	return _success({
		"path": _get_scene_path(tree),
		"parameter": parameter,
		"value": _serialize_value(converted_value)
	}, "Parameter set")


func _get_tree_parameters(path: String) -> Dictionary:
	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)

	if not node is AnimationTree:
		return _error("Node is not an AnimationTree")

	var tree: AnimationTree = node
	var params: Array[Dictionary] = []

	for prop in tree.get_property_list():
		var prop_name = str(prop.name)
		if prop_name.begins_with("parameters/"):
			params.append({
				"name": prop_name,
				"value": _serialize_value(tree.get(prop_name)),
				"type": prop.type
			})

	return _success({
		"path": _get_scene_path(tree),
		"count": params.size(),
		"parameters": params
	})


# ==================== STATE MACHINE ====================

func _execute_state_machine(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var tree = _find_node_by_path(path)
	if not tree:
		return _error("Node not found: %s" % path)

	if not tree is AnimationTree:
		return _error("Node is not an AnimationTree")

	var state_machine = tree.tree_root
	if not state_machine is AnimationNodeStateMachine:
		return _error("Tree root is not a StateMachine")

	match action:
		"add_state":
			return _add_state(tree, state_machine, args)
		"remove_state":
			return _remove_state(state_machine, args.get("state", ""))
		"add_transition":
			return _add_transition(state_machine, args)
		"remove_transition":
			return _remove_transition(state_machine, args.get("from", ""), args.get("to", ""))
		"set_start":
			return _set_start_state(state_machine, args.get("state", ""))
		"set_end":
			return _set_end_state(state_machine, args.get("state", ""))
		"list_states":
			return _list_states(state_machine)
		"list_transitions":
			return _list_transitions(state_machine)
		"travel":
			return _travel_to_state(tree, args.get("state", ""))
		"get_current":
			return _get_current_state(tree)
		_:
			return _error("Unknown action: %s" % action)


func _add_state(tree: AnimationTree, sm: AnimationNodeStateMachine, args: Dictionary) -> Dictionary:
	var state_name = args.get("state", "")
	var state_type = args.get("type", "animation")
	var animation = args.get("animation", "")
	var position = args.get("position", {})

	if state_name.is_empty():
		return _error("State name is required")

	if sm.has_node(state_name):
		return _error("State already exists: %s" % state_name)

	var state_node: AnimationRootNode

	match state_type:
		"animation":
			var anim_node = AnimationNodeAnimation.new()
			if not animation.is_empty():
				anim_node.animation = animation
			state_node = anim_node
		"blend_space_1d":
			state_node = AnimationNodeBlendSpace1D.new()
		"blend_space_2d":
			state_node = AnimationNodeBlendSpace2D.new()
		"blend_tree":
			state_node = AnimationNodeBlendTree.new()
		"state_machine":
			state_node = AnimationNodeStateMachine.new()
		_:
			return _error("Unknown state type: %s" % state_type)

	var pos = Vector2.ZERO
	if position.has("x") and position.has("y"):
		pos = Vector2(position.x, position.y)

	sm.add_node(state_name, state_node, pos)

	return _success({
		"state": state_name,
		"type": state_type,
		"animation": animation,
		"position": {"x": pos.x, "y": pos.y}
	}, "State added")


func _remove_state(sm: AnimationNodeStateMachine, state_name: String) -> Dictionary:
	if state_name.is_empty():
		return _error("State name is required")

	if not sm.has_node(state_name):
		return _error("State not found: %s" % state_name)

	sm.remove_node(state_name)

	return _success({
		"state": state_name
	}, "State removed")


func _add_transition(sm: AnimationNodeStateMachine, args: Dictionary) -> Dictionary:
	var from_state = args.get("from", "")
	var to_state = args.get("to", "")
	var advance_mode = args.get("advance_mode", "auto")
	var switch_mode = args.get("switch_mode", "immediate")
	var xfade_time = args.get("xfade_time", 0.0)

	if from_state.is_empty() or to_state.is_empty():
		return _error("Both 'from' and 'to' states are required")

	if not sm.has_node(from_state):
		return _error("Source state not found: %s" % from_state)
	if not sm.has_node(to_state):
		return _error("Target state not found: %s" % to_state)

	var transition = AnimationNodeStateMachineTransition.new()

	# Set advance mode
	match advance_mode:
		"auto":
			transition.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_AUTO
		"enabled":
			transition.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_ENABLED
		"disabled":
			transition.advance_mode = AnimationNodeStateMachineTransition.ADVANCE_MODE_DISABLED

	# Set switch mode
	match switch_mode:
		"immediate":
			transition.switch_mode = AnimationNodeStateMachineTransition.SWITCH_MODE_IMMEDIATE
		"sync":
			transition.switch_mode = AnimationNodeStateMachineTransition.SWITCH_MODE_SYNC
		"at_end":
			transition.switch_mode = AnimationNodeStateMachineTransition.SWITCH_MODE_AT_END

	transition.xfade_time = xfade_time

	sm.add_transition(from_state, to_state, transition)

	return _success({
		"from": from_state,
		"to": to_state,
		"advance_mode": advance_mode,
		"switch_mode": switch_mode,
		"xfade_time": xfade_time
	}, "Transition added")


func _remove_transition(sm: AnimationNodeStateMachine, from_state: String, to_state: String) -> Dictionary:
	if from_state.is_empty() or to_state.is_empty():
		return _error("Both 'from' and 'to' states are required")

	if sm.has_transition(from_state, to_state):
		sm.remove_transition_by_index(sm.find_transition(from_state, to_state))
		return _success({
			"from": from_state,
			"to": to_state
		}, "Transition removed")
	else:
		return _error("Transition not found: %s -> %s" % [from_state, to_state])


func _set_start_state(sm: AnimationNodeStateMachine, state_name: String) -> Dictionary:
	if state_name.is_empty():
		return _error("State name is required")

	if not sm.has_node(state_name):
		return _error("State not found: %s" % state_name)

	sm.set_graph_offset(sm.get_node_position(state_name))

	return _success({
		"start_state": state_name
	}, "Start state set")


func _set_end_state(sm: AnimationNodeStateMachine, state_name: String) -> Dictionary:
	if state_name.is_empty():
		return _error("State name is required")

	if not sm.has_node(state_name):
		return _error("State not found: %s" % state_name)

	# End state is typically handled by transitions, not a specific node
	return _success({
		"end_state": state_name,
		"note": "End states are defined by transitions with no outgoing connections"
	}, "End state noted")


func _list_states(sm: AnimationNodeStateMachine) -> Dictionary:
	var states: Array[Dictionary] = []
	var node_names: Array[StringName] = []

	# Collect all node names from transitions
	for i in range(sm.get_transition_count()):
		var from_node = sm.get_transition_from(i)
		var to_node = sm.get_transition_to(i)
		if from_node not in node_names:
			node_names.append(from_node)
		if to_node not in node_names:
			node_names.append(to_node)

	# Check for common state names that might not have transitions
	for common_name in ["Start", "End", "start", "end"]:
		if sm.has_node(common_name) and common_name not in node_names:
			node_names.append(common_name)

	# Build state info for each node
	for node_name in node_names:
		if sm.has_node(node_name):
			var node = sm.get_node(node_name)
			var pos = sm.get_node_position(node_name)
			states.append({
				"name": str(node_name),
				"type": node.get_class(),
				"position": {"x": pos.x, "y": pos.y}
			})

	return _success({
		"count": states.size(),
		"states": states
	})


func _list_transitions(sm: AnimationNodeStateMachine) -> Dictionary:
	var transitions: Array[Dictionary] = []

	for i in range(sm.get_transition_count()):
		var from_node = sm.get_transition_from(i)
		var to_node = sm.get_transition_to(i)
		var transition = sm.get_transition(i)

		transitions.append({
			"from": from_node,
			"to": to_node,
			"advance_mode": transition.advance_mode,
			"switch_mode": transition.switch_mode,
			"xfade_time": transition.xfade_time
		})

	return _success({
		"count": transitions.size(),
		"transitions": transitions
	})


func _travel_to_state(tree: AnimationTree, state_name: String) -> Dictionary:
	if state_name.is_empty():
		return _error("State name is required")

	var playback = tree.get("parameters/playback")
	if playback and playback is AnimationNodeStateMachinePlayback:
		playback.travel(state_name)
		return _success({
			"target_state": state_name
		}, "Traveling to state")
	else:
		return _error("Could not get state machine playback")


func _get_current_state(tree: AnimationTree) -> Dictionary:
	var playback = tree.get("parameters/playback")
	if playback and playback is AnimationNodeStateMachinePlayback:
		return _success({
			"current_state": playback.get_current_node(),
			"is_playing": playback.is_playing(),
			"travel_path": playback.get_travel_path()
		})
	else:
		return _error("Could not get state machine playback")


# ==================== BLEND SPACE ====================

func _execute_blend_space(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")
	var node_path = args.get("node", "")

	if path.is_empty():
		return _error("Path is required")

	var tree = _find_node_by_path(path)
	if not tree:
		return _error("Node not found: %s" % path)

	if not tree is AnimationTree:
		return _error("Node is not an AnimationTree")

	# Get blend space node
	var blend_space = _get_blend_space_from_tree(tree, node_path)
	if not blend_space:
		# Check if root is blend space
		if tree.tree_root is AnimationNodeBlendSpace1D or tree.tree_root is AnimationNodeBlendSpace2D:
			blend_space = tree.tree_root
		else:
			return _error("Blend space not found")

	var is_2d = blend_space is AnimationNodeBlendSpace2D

	match action:
		"add_point":
			return _add_blend_point(blend_space, is_2d, args)
		"remove_point":
			return _remove_blend_point(blend_space, args.get("point_index", 0))
		"set_blend_mode":
			return _set_blend_mode(blend_space, is_2d, args.get("blend_mode", "interpolated"))
		"get_points":
			return _get_blend_points(blend_space, is_2d)
		"set_min_max":
			return _set_blend_bounds(blend_space, is_2d, args)
		"set_snap":
			return _set_blend_snap(blend_space, is_2d, args.get("snap", 0.1))
		"triangulate":
			if is_2d:
				return _success({"note": "Triangulation is automatic in Godot 4"})
			else:
				return _error("Triangulate is only for 2D blend spaces")
		_:
			return _error("Unknown action: %s" % action)


func _get_blend_space_from_tree(tree: AnimationTree, node_path: String) -> AnimationRootNode:
	if node_path.is_empty():
		return null

	# Parse parameter path like "parameters/locomotion"
	var parts = node_path.split("/")
	if parts.size() < 2:
		return null

	# Navigate through the tree
	var current: AnimationRootNode = tree.tree_root
	for i in range(1, parts.size()):  # Skip "parameters"
		if current is AnimationNodeBlendTree:
			current = current.get_node(parts[i])
		elif current is AnimationNodeStateMachine:
			current = current.get_node(parts[i])
		else:
			return null

	return current


func _add_blend_point(blend_space, is_2d: bool, args: Dictionary) -> Dictionary:
	var animation = args.get("animation", "")
	var position = args.get("position")

	if animation.is_empty():
		return _error("Animation name is required")

	var anim_node = AnimationNodeAnimation.new()
	anim_node.animation = animation

	if is_2d:
		var pos = Vector2.ZERO
		if position is Dictionary:
			pos = Vector2(position.get("x", 0), position.get("y", 0))
		elif position is float or position is int:
			pos = Vector2(position, 0)

		var idx = blend_space.add_blend_point(anim_node, pos)
		return _success({
			"point_index": idx,
			"animation": animation,
			"position": {"x": pos.x, "y": pos.y}
		}, "Blend point added")
	else:
		var pos = 0.0
		if position is float or position is int:
			pos = float(position)
		elif position is Dictionary:
			pos = float(position.get("x", 0))

		var idx = blend_space.add_blend_point(anim_node, pos)
		return _success({
			"point_index": idx,
			"animation": animation,
			"position": pos
		}, "Blend point added")


func _remove_blend_point(blend_space, index: int) -> Dictionary:
	if index < 0 or index >= blend_space.get_blend_point_count():
		return _error("Point index out of range")

	blend_space.remove_blend_point(index)
	return _success({
		"removed_index": index
	}, "Blend point removed")


func _set_blend_mode(blend_space, is_2d: bool, mode: String) -> Dictionary:
	if not is_2d:
		return _error("Blend mode is only for 2D blend spaces")

	match mode:
		"interpolated":
			blend_space.blend_mode = AnimationNodeBlendSpace2D.BLEND_MODE_INTERPOLATED
		"discrete":
			blend_space.blend_mode = AnimationNodeBlendSpace2D.BLEND_MODE_DISCRETE
		"discrete_carry":
			blend_space.blend_mode = AnimationNodeBlendSpace2D.BLEND_MODE_DISCRETE_CARRY
		_:
			return _error("Unknown blend mode: %s" % mode)

	return _success({
		"blend_mode": mode
	}, "Blend mode set")


func _get_blend_points(blend_space, is_2d: bool) -> Dictionary:
	var points: Array[Dictionary] = []
	var count = blend_space.get_blend_point_count()

	for i in range(count):
		var node = blend_space.get_blend_point_node(i)
		var anim_name = ""
		if node is AnimationNodeAnimation:
			anim_name = node.animation

		if is_2d:
			var pos = blend_space.get_blend_point_position(i)
			points.append({
				"index": i,
				"animation": anim_name,
				"position": {"x": pos.x, "y": pos.y}
			})
		else:
			var pos = blend_space.get_blend_point_position(i)
			points.append({
				"index": i,
				"animation": anim_name,
				"position": pos
			})

	return _success({
		"count": count,
		"points": points
	})


func _set_blend_bounds(blend_space, is_2d: bool, args: Dictionary) -> Dictionary:
	if is_2d:
		if args.has("min_x"):
			blend_space.min_space.x = args.get("min_x", -1)
		if args.has("max_x"):
			blend_space.max_space.x = args.get("max_x", 1)
		if args.has("min_y"):
			blend_space.min_space.y = args.get("min_y", -1)
		if args.has("max_y"):
			blend_space.max_space.y = args.get("max_y", 1)

		return _success({
			"min_space": {"x": blend_space.min_space.x, "y": blend_space.min_space.y},
			"max_space": {"x": blend_space.max_space.x, "y": blend_space.max_space.y}
		}, "Bounds set")
	else:
		blend_space.min_space = args.get("min", -1)
		blend_space.max_space = args.get("max", 1)

		return _success({
			"min_space": blend_space.min_space,
			"max_space": blend_space.max_space
		}, "Bounds set")


func _set_blend_snap(blend_space, is_2d: bool, snap: float) -> Dictionary:
	if is_2d:
		blend_space.snap = Vector2(snap, snap)
	else:
		blend_space.snap = snap

	return _success({
		"snap": snap
	}, "Snap set")


# ==================== BLEND TREE ====================

func _execute_blend_tree(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var tree = _find_node_by_path(path)
	if not tree:
		return _error("Node not found: %s" % path)

	if not tree is AnimationTree:
		return _error("Node is not an AnimationTree")

	var blend_tree = tree.tree_root
	if not blend_tree is AnimationNodeBlendTree:
		return _error("Tree root is not a BlendTree")

	match action:
		"add_node":
			return _add_blend_tree_node(blend_tree, args)
		"remove_node":
			return _remove_blend_tree_node(blend_tree, args.get("name", ""))
		"connect":
			return _connect_blend_tree_nodes(blend_tree, args)
		"disconnect":
			return _disconnect_blend_tree_nodes(blend_tree, args)
		"set_position":
			return _set_blend_tree_node_position(blend_tree, args)
		"list_nodes":
			return _list_blend_tree_nodes(blend_tree)
		"set_node_parameter":
			return _set_blend_tree_node_parameter(blend_tree, args)
		_:
			return _error("Unknown action: %s" % action)


func _add_blend_tree_node(bt: AnimationNodeBlendTree, args: Dictionary) -> Dictionary:
	var node_name = args.get("name", "")
	var node_type = args.get("type", "animation")
	var animation = args.get("animation", "")
	var position = args.get("position", {})

	if node_name.is_empty():
		return _error("Node name is required")

	if bt.has_node(node_name):
		return _error("Node already exists: %s" % node_name)

	var node: AnimationNode

	match node_type:
		"animation":
			var anim_node = AnimationNodeAnimation.new()
			if not animation.is_empty():
				anim_node.animation = animation
			node = anim_node
		"blend2":
			node = AnimationNodeBlend2.new()
		"blend3":
			node = AnimationNodeBlend3.new()
		"add2":
			node = AnimationNodeAdd2.new()
		"add3":
			node = AnimationNodeAdd3.new()
		"one_shot":
			node = AnimationNodeOneShot.new()
		"time_scale":
			node = AnimationNodeTimeScale.new()
		"time_seek":
			node = AnimationNodeTimeSeek.new()
		"transition":
			node = AnimationNodeTransition.new()
		"blend_space_1d":
			node = AnimationNodeBlendSpace1D.new()
		"blend_space_2d":
			node = AnimationNodeBlendSpace2D.new()
		"state_machine":
			node = AnimationNodeStateMachine.new()
		_:
			return _error("Unknown node type: %s" % node_type)

	var pos = Vector2.ZERO
	if position.has("x") and position.has("y"):
		pos = Vector2(position.x, position.y)

	bt.add_node(node_name, node, pos)

	return _success({
		"name": node_name,
		"type": node_type,
		"animation": animation if node_type == "animation" else null,
		"position": {"x": pos.x, "y": pos.y}
	}, "Node added")


func _remove_blend_tree_node(bt: AnimationNodeBlendTree, node_name: String) -> Dictionary:
	if node_name.is_empty():
		return _error("Node name is required")

	if not bt.has_node(node_name):
		return _error("Node not found: %s" % node_name)

	bt.remove_node(node_name)

	return _success({
		"name": node_name
	}, "Node removed")


func _connect_blend_tree_nodes(bt: AnimationNodeBlendTree, args: Dictionary) -> Dictionary:
	var from_node = args.get("from", "")
	var to_node = args.get("to", "")
	var port = args.get("port", 0)

	if from_node.is_empty() or to_node.is_empty():
		return _error("Both 'from' and 'to' nodes are required")

	if from_node != "output" and not bt.has_node(from_node):
		return _error("Source node not found: %s" % from_node)
	if to_node != "output" and not bt.has_node(to_node):
		return _error("Target node not found: %s" % to_node)

	bt.connect_node(to_node, port, from_node)

	return _success({
		"from": from_node,
		"to": to_node,
		"port": port
	}, "Nodes connected")


func _disconnect_blend_tree_nodes(bt: AnimationNodeBlendTree, args: Dictionary) -> Dictionary:
	var to_node = args.get("to", "")
	var port = args.get("port", 0)

	if to_node.is_empty():
		return _error("Target node is required")

	bt.disconnect_node(to_node, port)

	return _success({
		"to": to_node,
		"port": port
	}, "Nodes disconnected")


func _set_blend_tree_node_position(bt: AnimationNodeBlendTree, args: Dictionary) -> Dictionary:
	var node_name = args.get("name", "")
	var position = args.get("position", {})

	if node_name.is_empty():
		return _error("Node name is required")

	if not bt.has_node(node_name):
		return _error("Node not found: %s" % node_name)

	var pos = Vector2.ZERO
	if position.has("x") and position.has("y"):
		pos = Vector2(position.x, position.y)

	bt.set_node_position(node_name, pos)

	return _success({
		"name": node_name,
		"position": {"x": pos.x, "y": pos.y}
	}, "Position set")


func _list_blend_tree_nodes(bt: AnimationNodeBlendTree) -> Dictionary:
	var nodes: Array[Dictionary] = []

	# Get all node names - using the connection list to find all nodes
	var node_list: Array = []

	# Check for common node names and output
	for potential_name in ["output"]:
		if bt.has_node(potential_name):
			node_list.append(potential_name)

	# Try to get node list through property iteration
	for prop in bt.get_property_list():
		var prop_name = str(prop.name)
		if prop_name.begins_with("nodes/") and prop_name.ends_with("/node"):
			var node_name = prop_name.replace("nodes/", "").replace("/node", "")
			if not node_name in node_list:
				node_list.append(node_name)

	for node_name in node_list:
		if not bt.has_node(node_name):
			continue
		var node = bt.get_node(node_name)
		var pos = bt.get_node_position(node_name)
		var info: Dictionary = {
			"name": node_name,
			"type": node.get_class(),
			"position": {"x": pos.x, "y": pos.y}
		}
		if node is AnimationNodeAnimation:
			info["animation"] = node.animation
		nodes.append(info)

	return _success({
		"count": nodes.size(),
		"nodes": nodes
	})


func _set_blend_tree_node_parameter(bt: AnimationNodeBlendTree, args: Dictionary) -> Dictionary:
	var node_name = args.get("name", "")
	var parameter = args.get("parameter", "")
	var value = args.get("value")

	if node_name.is_empty():
		return _error("Node name is required")
	if parameter.is_empty():
		return _error("Parameter name is required")

	if not bt.has_node(node_name):
		return _error("Node not found: %s" % node_name)

	var node = bt.get_node(node_name)
	if not parameter in node:
		return _error("Parameter not found: %s" % parameter)

	node.set(parameter, _convert_track_value(value))

	return _success({
		"name": node_name,
		"parameter": parameter,
		"value": _serialize_value(value)
	}, "Parameter set")
