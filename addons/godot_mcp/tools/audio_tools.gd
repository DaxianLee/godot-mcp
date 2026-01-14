@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## Audio tools for Godot MCP
## Provides AudioBus management and AudioStream operations


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "bus",
			"description": """AUDIO BUS: Manage audio buses.

ACTIONS:
- list: List all audio buses
- get_info: Get info about a specific bus
- add: Add a new bus
- remove: Remove a bus (except Master)
- set_volume: Set bus volume in dB
- set_mute: Mute/unmute a bus
- set_solo: Solo/unsolo a bus
- set_bypass: Bypass/unbypass effects
- add_effect: Add an effect to a bus
- remove_effect: Remove an effect from a bus
- get_effect: Get effect info
- set_effect_enabled: Enable/disable an effect

VOLUME: In decibels (dB). 0 dB = full volume, -80 dB = silent

EXAMPLES:
- List buses: {"action": "list"}
- Get Master info: {"action": "get_info", "bus": "Master"}
- Set volume: {"action": "set_volume", "bus": "Music", "volume_db": -6.0}
- Mute: {"action": "set_mute", "bus": "SFX", "mute": true}
- Add effect: {"action": "add_effect", "bus": "Master", "effect": "AudioEffectReverb"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "get_info", "add", "remove", "set_volume", "set_mute", "set_solo", "set_bypass", "add_effect", "remove_effect", "get_effect", "set_effect_enabled"],
						"description": "Bus action"
					},
					"bus": {
						"type": "string",
						"description": "Bus name or index"
					},
					"volume_db": {
						"type": "number",
						"description": "Volume in decibels"
					},
					"mute": {
						"type": "boolean",
						"description": "Mute state"
					},
					"solo": {
						"type": "boolean",
						"description": "Solo state"
					},
					"bypass": {
						"type": "boolean",
						"description": "Bypass effects"
					},
					"effect": {
						"type": "string",
						"description": "Effect class name"
					},
					"effect_index": {
						"type": "integer",
						"description": "Effect index on bus"
					},
					"enabled": {
						"type": "boolean",
						"description": "Effect enabled state"
					},
					"at_position": {
						"type": "integer",
						"description": "Position to insert effect"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "player",
			"description": """AUDIO PLAYER: Control AudioStreamPlayer nodes.

ACTIONS:
- list: List all AudioStreamPlayer nodes in scene
- get_info: Get info about an audio player
- play: Start playing
- stop: Stop playing
- pause: Pause/unpause (set stream_paused)
- seek: Seek to position
- set_volume: Set volume in dB
- set_pitch: Set pitch scale
- set_bus: Set output bus
- set_stream: Set audio stream resource

PLAYER TYPES:
- AudioStreamPlayer: Non-positional audio
- AudioStreamPlayer2D: 2D positional audio
- AudioStreamPlayer3D: 3D positional audio

EXAMPLES:
- List players: {"action": "list"}
- Play: {"action": "play", "path": "/root/MusicPlayer"}
- Stop: {"action": "stop", "path": "/root/MusicPlayer"}
- Seek: {"action": "seek", "path": "/root/MusicPlayer", "position": 30.0}
- Set volume: {"action": "set_volume", "path": "/root/MusicPlayer", "volume_db": -3.0}
- Set stream: {"action": "set_stream", "path": "/root/MusicPlayer", "stream": "res://audio/music.ogg"}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["list", "get_info", "play", "stop", "pause", "seek", "set_volume", "set_pitch", "set_bus", "set_stream"],
						"description": "Player action"
					},
					"path": {
						"type": "string",
						"description": "AudioStreamPlayer node path"
					},
					"position": {
						"type": "number",
						"description": "Playback position in seconds"
					},
					"volume_db": {
						"type": "number",
						"description": "Volume in decibels"
					},
					"pitch_scale": {
						"type": "number",
						"description": "Pitch scale (1.0 = normal)"
					},
					"bus": {
						"type": "string",
						"description": "Output bus name"
					},
					"stream": {
						"type": "string",
						"description": "AudioStream resource path"
					},
					"from_position": {
						"type": "number",
						"description": "Start position for play"
					},
					"paused": {
						"type": "boolean",
						"description": "Pause state"
					}
				},
				"required": ["action"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"bus":
			return _execute_bus(args)
		"player":
			return _execute_player(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== BUS ====================

func _execute_bus(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"list":
			return _list_buses()
		"get_info":
			return _get_bus_info(args.get("bus", "Master"))
		"add":
			return _add_bus(args.get("bus", "NewBus"))
		"remove":
			return _remove_bus(args.get("bus", ""))
		"set_volume":
			return _set_bus_volume(args.get("bus", "Master"), args.get("volume_db", 0.0))
		"set_mute":
			return _set_bus_mute(args.get("bus", "Master"), args.get("mute", false))
		"set_solo":
			return _set_bus_solo(args.get("bus", "Master"), args.get("solo", false))
		"set_bypass":
			return _set_bus_bypass(args.get("bus", "Master"), args.get("bypass", false))
		"add_effect":
			return _add_bus_effect(args.get("bus", "Master"), args.get("effect", ""), args.get("at_position", -1))
		"remove_effect":
			return _remove_bus_effect(args.get("bus", "Master"), args.get("effect_index", 0))
		"get_effect":
			return _get_bus_effect(args.get("bus", "Master"), args.get("effect_index", 0))
		"set_effect_enabled":
			return _set_effect_enabled(args.get("bus", "Master"), args.get("effect_index", 0), args.get("enabled", true))
		_:
			return _error("Unknown action: %s" % action)


func _get_bus_index(bus) -> int:
	if bus is int:
		return bus
	if bus is String:
		for i in range(AudioServer.bus_count):
			if AudioServer.get_bus_name(i) == bus:
				return i
	return -1


func _list_buses() -> Dictionary:
	var buses: Array[Dictionary] = []

	for i in range(AudioServer.bus_count):
		var bus_name = AudioServer.get_bus_name(i)
		buses.append({
			"index": i,
			"name": bus_name,
			"volume_db": AudioServer.get_bus_volume_db(i),
			"mute": AudioServer.is_bus_mute(i),
			"solo": AudioServer.is_bus_solo(i),
			"bypass": AudioServer.is_bus_bypassing_effects(i),
			"effect_count": AudioServer.get_bus_effect_count(i),
			"send": AudioServer.get_bus_send(i)
		})

	return _success({
		"count": buses.size(),
		"buses": buses
	})


func _get_bus_info(bus) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))

	var info = {
		"index": idx,
		"name": AudioServer.get_bus_name(idx),
		"volume_db": AudioServer.get_bus_volume_db(idx),
		"mute": AudioServer.is_bus_mute(idx),
		"solo": AudioServer.is_bus_solo(idx),
		"bypass": AudioServer.is_bus_bypassing_effects(idx),
		"send": AudioServer.get_bus_send(idx),
		"peak_left": AudioServer.get_bus_peak_volume_left_db(idx, 0),
		"peak_right": AudioServer.get_bus_peak_volume_right_db(idx, 0)
	}

	# List effects
	var effects: Array[Dictionary] = []
	for i in range(AudioServer.get_bus_effect_count(idx)):
		var effect = AudioServer.get_bus_effect(idx, i)
		effects.append({
			"index": i,
			"type": str(effect.get_class()) if effect else "null",
			"enabled": AudioServer.is_bus_effect_enabled(idx, i)
		})
	info["effects"] = effects

	return _success(info)


func _add_bus(bus_name: String) -> Dictionary:
	if bus_name.is_empty():
		return _error("Bus name is required")

	# Check if bus already exists
	for i in range(AudioServer.bus_count):
		if AudioServer.get_bus_name(i) == bus_name:
			return _error("Bus already exists: %s" % bus_name)

	var new_idx = AudioServer.bus_count
	AudioServer.add_bus()
	AudioServer.set_bus_name(new_idx, bus_name)

	return _success({
		"index": new_idx,
		"name": bus_name
	}, "Bus created")


func _remove_bus(bus) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))
	if idx == 0:
		return _error("Cannot remove Master bus")

	var bus_name = AudioServer.get_bus_name(idx)
	AudioServer.remove_bus(idx)

	return _success({
		"removed": bus_name
	}, "Bus removed")


func _set_bus_volume(bus, volume_db: float) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))

	AudioServer.set_bus_volume_db(idx, volume_db)

	return _success({
		"bus": AudioServer.get_bus_name(idx),
		"volume_db": volume_db
	}, "Volume set")


func _set_bus_mute(bus, mute: bool) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))

	AudioServer.set_bus_mute(idx, mute)

	return _success({
		"bus": AudioServer.get_bus_name(idx),
		"mute": mute
	}, "Mute %s" % ("enabled" if mute else "disabled"))


func _set_bus_solo(bus, solo: bool) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))

	AudioServer.set_bus_solo(idx, solo)

	return _success({
		"bus": AudioServer.get_bus_name(idx),
		"solo": solo
	}, "Solo %s" % ("enabled" if solo else "disabled"))


func _set_bus_bypass(bus, bypass: bool) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))

	AudioServer.set_bus_bypass_effects(idx, bypass)

	return _success({
		"bus": AudioServer.get_bus_name(idx),
		"bypass": bypass
	}, "Bypass %s" % ("enabled" if bypass else "disabled"))


func _add_bus_effect(bus, effect_type: String, at_position: int) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))

	if effect_type.is_empty():
		return _error("Effect type is required")

	# Create effect
	var effect = ClassDB.instantiate(effect_type)
	if not effect or not effect is AudioEffect:
		return _error("Invalid effect type: %s" % effect_type)

	if at_position < 0:
		at_position = AudioServer.get_bus_effect_count(idx)

	AudioServer.add_bus_effect(idx, effect, at_position)

	return _success({
		"bus": AudioServer.get_bus_name(idx),
		"effect": effect_type,
		"position": at_position
	}, "Effect added")


func _remove_bus_effect(bus, effect_index: int) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))

	if effect_index < 0 or effect_index >= AudioServer.get_bus_effect_count(idx):
		return _error("Invalid effect index: %d" % effect_index)

	var effect = AudioServer.get_bus_effect(idx, effect_index)
	var effect_type = str(effect.get_class()) if effect else "unknown"

	AudioServer.remove_bus_effect(idx, effect_index)

	return _success({
		"bus": AudioServer.get_bus_name(idx),
		"removed_effect": effect_type,
		"index": effect_index
	}, "Effect removed")


func _get_bus_effect(bus, effect_index: int) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))

	if effect_index < 0 or effect_index >= AudioServer.get_bus_effect_count(idx):
		return _error("Invalid effect index: %d" % effect_index)

	var effect = AudioServer.get_bus_effect(idx, effect_index)
	if not effect:
		return _error("Effect is null")

	var info = {
		"bus": AudioServer.get_bus_name(idx),
		"index": effect_index,
		"type": str(effect.get_class()),
		"enabled": AudioServer.is_bus_effect_enabled(idx, effect_index)
	}

	# Get effect properties
	var properties = {}
	for prop in effect.get_property_list():
		var prop_name = str(prop.name)
		if not prop_name.begins_with("_") and prop.usage & PROPERTY_USAGE_EDITOR:
			properties[prop_name] = effect.get(prop_name)
	info["properties"] = properties

	return _success(info)


func _set_effect_enabled(bus, effect_index: int, enabled: bool) -> Dictionary:
	var idx = _get_bus_index(bus)
	if idx < 0:
		return _error("Bus not found: %s" % str(bus))

	if effect_index < 0 or effect_index >= AudioServer.get_bus_effect_count(idx):
		return _error("Invalid effect index: %d" % effect_index)

	AudioServer.set_bus_effect_enabled(idx, effect_index, enabled)

	return _success({
		"bus": AudioServer.get_bus_name(idx),
		"effect_index": effect_index,
		"enabled": enabled
	}, "Effect %s" % ("enabled" if enabled else "disabled"))


# ==================== PLAYER ====================

func _execute_player(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"list":
			return _list_audio_players()
		"get_info":
			return _get_player_info(args.get("path", ""))
		"play":
			return _play_audio(args.get("path", ""), args.get("from_position", 0.0))
		"stop":
			return _stop_audio(args.get("path", ""))
		"pause":
			return _pause_audio(args.get("path", ""), args.get("paused", true))
		"seek":
			return _seek_audio(args.get("path", ""), args.get("position", 0.0))
		"set_volume":
			return _set_player_volume(args.get("path", ""), args.get("volume_db", 0.0))
		"set_pitch":
			return _set_player_pitch(args.get("path", ""), args.get("pitch_scale", 1.0))
		"set_bus":
			return _set_player_bus(args.get("path", ""), args.get("bus", "Master"))
		"set_stream":
			return _set_player_stream(args.get("path", ""), args.get("stream", ""))
		_:
			return _error("Unknown action: %s" % action)


func _get_audio_player(path: String):
	if path.is_empty():
		return null

	var node = _find_node_by_path(path)
	if not node:
		return null

	if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
		return node

	return null


func _list_audio_players() -> Dictionary:
	var players: Array[Dictionary] = []
	var root = _get_edited_scene_root()
	if not root:
		return _error("No scene open")

	_find_audio_players(root, players)

	return _success({
		"count": players.size(),
		"players": players
	})


func _find_audio_players(node: Node, result: Array[Dictionary]) -> void:
	if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
		var info = {
			"path": _get_scene_path(node),
			"type": str(node.get_class()),
			"playing": node.playing,
			"bus": node.bus
		}
		if node.stream:
			info["stream"] = str(node.stream.resource_path)
		result.append(info)

	for child in node.get_children():
		_find_audio_players(child, result)


func _get_player_info(path: String) -> Dictionary:
	var player = _get_audio_player(path)
	if not player:
		return _error("Audio player not found: %s" % path)

	var info = {
		"path": _get_scene_path(player),
		"type": str(player.get_class()),
		"playing": player.playing,
		"stream_paused": player.stream_paused,
		"volume_db": player.volume_db,
		"pitch_scale": player.pitch_scale,
		"bus": player.bus,
		"autoplay": player.autoplay
	}

	if player.stream:
		info["stream"] = str(player.stream.resource_path)
		info["stream_length"] = player.stream.get_length() if player.stream.has_method("get_length") else 0.0

	if player.playing:
		info["playback_position"] = player.get_playback_position()

	# Type-specific properties
	if player is AudioStreamPlayer2D:
		info["max_distance"] = player.max_distance
		info["attenuation"] = player.attenuation
	elif player is AudioStreamPlayer3D:
		info["max_db"] = player.max_db
		info["unit_size"] = player.unit_size
		info["max_distance"] = player.max_distance

	return _success(info)


func _play_audio(path: String, from_position: float) -> Dictionary:
	var player = _get_audio_player(path)
	if not player:
		return _error("Audio player not found: %s" % path)

	if not player.stream:
		return _error("No stream assigned to player")

	player.play(from_position)

	return _success({
		"path": path,
		"playing": true,
		"from_position": from_position
	}, "Playing audio")


func _stop_audio(path: String) -> Dictionary:
	var player = _get_audio_player(path)
	if not player:
		return _error("Audio player not found: %s" % path)

	player.stop()

	return _success({
		"path": path,
		"playing": false
	}, "Stopped audio")


func _pause_audio(path: String, paused: bool) -> Dictionary:
	var player = _get_audio_player(path)
	if not player:
		return _error("Audio player not found: %s" % path)

	player.stream_paused = paused

	return _success({
		"path": path,
		"paused": paused
	}, "Audio %s" % ("paused" if paused else "resumed"))


func _seek_audio(path: String, position: float) -> Dictionary:
	var player = _get_audio_player(path)
	if not player:
		return _error("Audio player not found: %s" % path)

	if not player.playing:
		return _error("Player is not playing")

	player.seek(position)

	return _success({
		"path": path,
		"position": position
	}, "Seeked to position")


func _set_player_volume(path: String, volume_db: float) -> Dictionary:
	var player = _get_audio_player(path)
	if not player:
		return _error("Audio player not found: %s" % path)

	player.volume_db = volume_db

	return _success({
		"path": path,
		"volume_db": volume_db
	}, "Volume set")


func _set_player_pitch(path: String, pitch_scale: float) -> Dictionary:
	var player = _get_audio_player(path)
	if not player:
		return _error("Audio player not found: %s" % path)

	player.pitch_scale = pitch_scale

	return _success({
		"path": path,
		"pitch_scale": pitch_scale
	}, "Pitch set")


func _set_player_bus(path: String, bus: String) -> Dictionary:
	var player = _get_audio_player(path)
	if not player:
		return _error("Audio player not found: %s" % path)

	# Verify bus exists
	var bus_idx = _get_bus_index(bus)
	if bus_idx < 0:
		return _error("Bus not found: %s" % bus)

	player.bus = bus

	return _success({
		"path": path,
		"bus": bus
	}, "Bus set")


func _set_player_stream(path: String, stream_path: String) -> Dictionary:
	var player = _get_audio_player(path)
	if not player:
		return _error("Audio player not found: %s" % path)

	if stream_path.is_empty():
		player.stream = null
		return _success({"path": path, "stream": null}, "Stream cleared")

	if not stream_path.begins_with("res://"):
		stream_path = "res://" + stream_path

	if not ResourceLoader.exists(stream_path):
		return _error("Stream not found: %s" % stream_path)

	var stream = load(stream_path)
	if not stream or not stream is AudioStream:
		return _error("Invalid audio stream: %s" % stream_path)

	player.stream = stream

	return _success({
		"path": path,
		"stream": stream_path
	}, "Stream set")
