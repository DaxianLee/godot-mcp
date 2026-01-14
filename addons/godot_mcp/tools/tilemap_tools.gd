@tool
extends "res://addons/godot_mcp/tools/base_tools.gd"

## TileMap tools for Godot MCP
## Provides TileSet management and TileMap cell operations


func get_tools() -> Array[Dictionary]:
	return [
		{
			"name": "tileset",
			"description": """TILESET MANAGEMENT: Manage TileSet resources.

ACTIONS:
- get_info: Get TileSet information
- list_sources: List all sources (atlases/scenes) in TileSet
- get_source: Get details of a specific source
- list_tiles: List all tiles in a source
- get_tile_data: Get custom data for a tile

TILESET SOURCES:
- Atlas Source: Image-based tiles (TileSetAtlasSource)
- Scene Source: Scene-based tiles (TileSetScenesCollectionSource)

EXAMPLES:
- Get TileSet info: {"action": "get_info", "path": "/root/TileMap"}
- List sources: {"action": "list_sources", "path": "/root/TileMap"}
- List tiles: {"action": "list_tiles", "path": "/root/TileMap", "source_id": 0}
- Get tile data: {"action": "get_tile_data", "path": "/root/TileMap", "source_id": 0, "atlas_coords": {"x": 0, "y": 0}}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_info", "list_sources", "get_source", "list_tiles", "get_tile_data"],
						"description": "TileSet action"
					},
					"path": {
						"type": "string",
						"description": "TileMap node path"
					},
					"tileset_path": {
						"type": "string",
						"description": "TileSet resource path (res://...)"
					},
					"source_id": {
						"type": "integer",
						"description": "Source ID in the TileSet"
					},
					"atlas_coords": {
						"type": "object",
						"description": "Atlas coordinates {x, y}"
					},
					"alternative_id": {
						"type": "integer",
						"description": "Alternative tile ID (default: 0)"
					}
				},
				"required": ["action"]
			}
		},
		{
			"name": "tilemap",
			"description": """TILEMAP OPERATIONS: Manipulate TileMap cells.

ACTIONS:
- get_info: Get TileMap layer information
- get_cell: Get cell data at coordinates
- set_cell: Set a cell to a specific tile
- erase_cell: Erase a cell (remove tile)
- fill_rect: Fill a rectangular area with tiles
- clear_layer: Clear all cells in a layer
- get_used_cells: Get all used cell coordinates
- get_used_rect: Get bounding rectangle of used cells

CELL DATA:
- source_id: The TileSet source containing the tile
- atlas_coords: Position in the atlas (for atlas sources)
- alternative_id: Alternative tile variant

EXAMPLES:
- Get TileMap info: {"action": "get_info", "path": "/root/TileMap"}
- Set cell: {"action": "set_cell", "path": "/root/TileMap", "coords": {"x": 5, "y": 3}, "source_id": 0, "atlas_coords": {"x": 0, "y": 0}}
- Get cell: {"action": "get_cell", "path": "/root/TileMap", "coords": {"x": 5, "y": 3}}
- Erase cell: {"action": "erase_cell", "path": "/root/TileMap", "coords": {"x": 5, "y": 3}}
- Fill rect: {"action": "fill_rect", "path": "/root/TileMap", "rect": {"x": 0, "y": 0, "width": 10, "height": 5}, "source_id": 0, "atlas_coords": {"x": 1, "y": 0}}
- Clear layer: {"action": "clear_layer", "path": "/root/TileMap", "layer": 0}
- Get used cells: {"action": "get_used_cells", "path": "/root/TileMap", "layer": 0}""",
			"inputSchema": {
				"type": "object",
				"properties": {
					"action": {
						"type": "string",
						"enum": ["get_info", "get_cell", "set_cell", "erase_cell", "fill_rect", "clear_layer", "get_used_cells", "get_used_rect"],
						"description": "TileMap action"
					},
					"path": {
						"type": "string",
						"description": "TileMap node path"
					},
					"layer": {
						"type": "integer",
						"description": "Layer index (default: 0)"
					},
					"coords": {
						"type": "object",
						"description": "Cell coordinates {x, y}"
					},
					"rect": {
						"type": "object",
						"description": "Rectangle {x, y, width, height}"
					},
					"source_id": {
						"type": "integer",
						"description": "TileSet source ID"
					},
					"atlas_coords": {
						"type": "object",
						"description": "Atlas coordinates {x, y}"
					},
					"alternative_id": {
						"type": "integer",
						"description": "Alternative tile ID"
					}
				},
				"required": ["action", "path"]
			}
		}
	]


func execute(tool_name: String, args: Dictionary) -> Dictionary:
	match tool_name:
		"tileset":
			return _execute_tileset(args)
		"tilemap":
			return _execute_tilemap(args)
		_:
			return _error("Unknown tool: %s" % tool_name)


# ==================== TILESET ====================

func _execute_tileset(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")

	match action:
		"get_info":
			return _get_tileset_info(args)
		"list_sources":
			return _list_tileset_sources(args)
		"get_source":
			return _get_tileset_source(args)
		"list_tiles":
			return _list_tiles(args)
		"get_tile_data":
			return _get_tile_data(args)
		_:
			return _error("Unknown action: %s" % action)


func _get_tileset(args: Dictionary) -> TileSet:
	# Try to get TileSet from TileMap node
	var path = args.get("path", "")
	if not path.is_empty():
		var node = _find_node_by_path(path)
		if node and node is TileMap:
			return node.tile_set

	# Try to load TileSet from resource path
	var tileset_path = args.get("tileset_path", "")
	if not tileset_path.is_empty():
		if not tileset_path.begins_with("res://"):
			tileset_path = "res://" + tileset_path
		if ResourceLoader.exists(tileset_path):
			return load(tileset_path) as TileSet

	return null


func _get_tileset_info(args: Dictionary) -> Dictionary:
	var tileset = _get_tileset(args)
	if not tileset:
		return _error("TileSet not found. Provide 'path' (TileMap node) or 'tileset_path' (resource)")

	var info = {
		"tile_size": _serialize_value(tileset.tile_size),
		"source_count": tileset.get_source_count(),
		"physics_layers_count": tileset.get_physics_layers_count(),
		"terrain_sets_count": tileset.get_terrain_sets_count(),
		"navigation_layers_count": tileset.get_navigation_layers_count(),
		"custom_data_layers_count": tileset.get_custom_data_layers_count()
	}

	# List custom data layer names
	var custom_layers: Array[String] = []
	for i in range(tileset.get_custom_data_layers_count()):
		custom_layers.append(tileset.get_custom_data_layer_name(i))
	info["custom_data_layers"] = custom_layers

	return _success(info)


func _list_tileset_sources(args: Dictionary) -> Dictionary:
	var tileset = _get_tileset(args)
	if not tileset:
		return _error("TileSet not found")

	var sources: Array[Dictionary] = []
	for i in range(tileset.get_source_count()):
		var source_id = tileset.get_source_id(i)
		var source = tileset.get_source(source_id)
		var source_info = {
			"id": source_id,
			"type": str(source.get_class())
		}

		if source is TileSetAtlasSource:
			source_info["texture"] = str(source.texture.resource_path) if source.texture else null
			source_info["texture_region_size"] = _serialize_value(source.texture_region_size)
			source_info["tile_count"] = source.get_tiles_count()
		elif source is TileSetScenesCollectionSource:
			source_info["scene_count"] = source.get_scene_tiles_count()

		sources.append(source_info)

	return _success({
		"count": sources.size(),
		"sources": sources
	})


func _get_tileset_source(args: Dictionary) -> Dictionary:
	var tileset = _get_tileset(args)
	if not tileset:
		return _error("TileSet not found")

	var source_id = args.get("source_id", 0)
	if not tileset.has_source(source_id):
		return _error("Source not found: %d" % source_id)

	var source = tileset.get_source(source_id)
	var info = {
		"id": source_id,
		"type": str(source.get_class())
	}

	if source is TileSetAtlasSource:
		info["texture"] = str(source.texture.resource_path) if source.texture else null
		info["texture_region_size"] = _serialize_value(source.texture_region_size)
		info["separation"] = _serialize_value(source.separation)
		info["margins"] = _serialize_value(source.margins)
		info["tile_count"] = source.get_tiles_count()

		# List all atlas coordinates
		var tiles: Array[Dictionary] = []
		for j in range(source.get_tiles_count()):
			var coords = source.get_tile_id(j)
			tiles.append({
				"atlas_coords": _serialize_value(coords),
				"size_in_atlas": _serialize_value(source.get_tile_size_in_atlas(coords)),
				"alternative_count": source.get_alternative_tiles_count(coords)
			})
		info["tiles"] = tiles

	elif source is TileSetScenesCollectionSource:
		var scenes: Array[Dictionary] = []
		for j in range(source.get_scene_tiles_count()):
			var scene_id = source.get_scene_tile_id(j)
			var scene = source.get_scene_tile_scene(scene_id)
			scenes.append({
				"id": scene_id,
				"scene": str(scene.resource_path) if scene else null
			})
		info["scenes"] = scenes

	return _success(info)


func _list_tiles(args: Dictionary) -> Dictionary:
	var tileset = _get_tileset(args)
	if not tileset:
		return _error("TileSet not found")

	var source_id = args.get("source_id", 0)
	if not tileset.has_source(source_id):
		return _error("Source not found: %d" % source_id)

	var source = tileset.get_source(source_id)
	var tiles: Array[Dictionary] = []

	if source is TileSetAtlasSource:
		for i in range(source.get_tiles_count()):
			var coords = source.get_tile_id(i)
			var tile_info = {
				"atlas_coords": _serialize_value(coords),
				"size_in_atlas": _serialize_value(source.get_tile_size_in_atlas(coords))
			}

			# Get alternative tiles
			var alternatives: Array[int] = []
			for alt_idx in range(source.get_alternative_tiles_count(coords)):
				alternatives.append(source.get_alternative_tile_id(coords, alt_idx))
			tile_info["alternatives"] = alternatives

			tiles.append(tile_info)
	elif source is TileSetScenesCollectionSource:
		for i in range(source.get_scene_tiles_count()):
			var scene_id = source.get_scene_tile_id(i)
			var scene = source.get_scene_tile_scene(scene_id)
			tiles.append({
				"scene_id": scene_id,
				"scene_path": str(scene.resource_path) if scene else null
			})

	return _success({
		"source_id": source_id,
		"count": tiles.size(),
		"tiles": tiles
	})


func _get_tile_data(args: Dictionary) -> Dictionary:
	var tileset = _get_tileset(args)
	if not tileset:
		return _error("TileSet not found")

	var source_id = args.get("source_id", 0)
	if not tileset.has_source(source_id):
		return _error("Source not found: %d" % source_id)

	var source = tileset.get_source(source_id)
	if not source is TileSetAtlasSource:
		return _error("Source is not an atlas source")

	var atlas_coords_dict = args.get("atlas_coords", {"x": 0, "y": 0})
	var atlas_coords = Vector2i(int(atlas_coords_dict.get("x", 0)), int(atlas_coords_dict.get("y", 0)))
	var alternative_id = args.get("alternative_id", 0)

	if not source.has_tile(atlas_coords):
		return _error("Tile not found at coords: %s" % str(atlas_coords))

	var tile_data = source.get_tile_data(atlas_coords, alternative_id)
	if not tile_data:
		return _error("Tile data not found")

	var info = {
		"atlas_coords": _serialize_value(atlas_coords),
		"alternative_id": alternative_id,
		"texture_origin": _serialize_value(tile_data.texture_origin),
		"modulate": _serialize_value(tile_data.modulate),
		"z_index": tile_data.z_index,
		"y_sort_origin": tile_data.y_sort_origin,
		"probability": tile_data.probability
	}

	# Get custom data
	var custom_data = {}
	for i in range(tileset.get_custom_data_layers_count()):
		var layer_name = tileset.get_custom_data_layer_name(i)
		custom_data[layer_name] = tile_data.get_custom_data(layer_name)
	info["custom_data"] = custom_data

	return _success(info)


# ==================== TILEMAP ====================

func _execute_tilemap(args: Dictionary) -> Dictionary:
	var action = args.get("action", "")
	var path = args.get("path", "")

	if path.is_empty():
		return _error("Path is required")

	var node = _find_node_by_path(path)
	if not node:
		return _error("Node not found: %s" % path)
	if not node is TileMap:
		return _error("Node is not a TileMap: %s" % path)

	var tilemap = node as TileMap

	match action:
		"get_info":
			return _get_tilemap_info(tilemap)
		"get_cell":
			return _get_tilemap_cell(tilemap, args)
		"set_cell":
			return _set_tilemap_cell(tilemap, args)
		"erase_cell":
			return _erase_tilemap_cell(tilemap, args)
		"fill_rect":
			return _fill_tilemap_rect(tilemap, args)
		"clear_layer":
			return _clear_tilemap_layer(tilemap, args)
		"get_used_cells":
			return _get_used_cells(tilemap, args)
		"get_used_rect":
			return _get_used_rect(tilemap, args)
		_:
			return _error("Unknown action: %s" % action)


func _get_tilemap_info(tilemap: TileMap) -> Dictionary:
	var info = {
		"path": _get_scene_path(tilemap),
		"layers_count": tilemap.get_layers_count(),
		"has_tileset": tilemap.tile_set != null
	}

	if tilemap.tile_set:
		info["tile_size"] = _serialize_value(tilemap.tile_set.tile_size)

	# Layer info
	var layers: Array[Dictionary] = []
	for i in range(tilemap.get_layers_count()):
		layers.append({
			"index": i,
			"name": tilemap.get_layer_name(i),
			"enabled": tilemap.is_layer_enabled(i),
			"modulate": _serialize_value(tilemap.get_layer_modulate(i)),
			"y_sort_enabled": tilemap.is_layer_y_sort_enabled(i),
			"z_index": tilemap.get_layer_z_index(i)
		})
	info["layers"] = layers

	return _success(info)


func _get_tilemap_cell(tilemap: TileMap, args: Dictionary) -> Dictionary:
	var layer = args.get("layer", 0)
	var coords_dict = args.get("coords", {"x": 0, "y": 0})
	var coords = Vector2i(int(coords_dict.get("x", 0)), int(coords_dict.get("y", 0)))

	if layer < 0 or layer >= tilemap.get_layers_count():
		return _error("Invalid layer: %d" % layer)

	var source_id = tilemap.get_cell_source_id(layer, coords)
	var atlas_coords = tilemap.get_cell_atlas_coords(layer, coords)
	var alternative_id = tilemap.get_cell_alternative_tile(layer, coords)

	if source_id == -1:
		return _success({
			"coords": _serialize_value(coords),
			"layer": layer,
			"empty": true
		})

	return _success({
		"coords": _serialize_value(coords),
		"layer": layer,
		"source_id": source_id,
		"atlas_coords": _serialize_value(atlas_coords),
		"alternative_id": alternative_id,
		"empty": false
	})


func _set_tilemap_cell(tilemap: TileMap, args: Dictionary) -> Dictionary:
	var layer = args.get("layer", 0)
	var coords_dict = args.get("coords", {"x": 0, "y": 0})
	var coords = Vector2i(int(coords_dict.get("x", 0)), int(coords_dict.get("y", 0)))
	var source_id = args.get("source_id", 0)
	var atlas_coords_dict = args.get("atlas_coords", {"x": 0, "y": 0})
	var atlas_coords = Vector2i(int(atlas_coords_dict.get("x", 0)), int(atlas_coords_dict.get("y", 0)))
	var alternative_id = args.get("alternative_id", 0)

	if layer < 0 or layer >= tilemap.get_layers_count():
		return _error("Invalid layer: %d" % layer)

	tilemap.set_cell(layer, coords, source_id, atlas_coords, alternative_id)

	return _success({
		"coords": _serialize_value(coords),
		"layer": layer,
		"source_id": source_id,
		"atlas_coords": _serialize_value(atlas_coords),
		"alternative_id": alternative_id
	}, "Cell set")


func _erase_tilemap_cell(tilemap: TileMap, args: Dictionary) -> Dictionary:
	var layer = args.get("layer", 0)
	var coords_dict = args.get("coords", {"x": 0, "y": 0})
	var coords = Vector2i(int(coords_dict.get("x", 0)), int(coords_dict.get("y", 0)))

	if layer < 0 or layer >= tilemap.get_layers_count():
		return _error("Invalid layer: %d" % layer)

	tilemap.erase_cell(layer, coords)

	return _success({
		"coords": _serialize_value(coords),
		"layer": layer
	}, "Cell erased")


func _fill_tilemap_rect(tilemap: TileMap, args: Dictionary) -> Dictionary:
	var layer = args.get("layer", 0)
	var rect_dict = args.get("rect", {"x": 0, "y": 0, "width": 1, "height": 1})
	var source_id = args.get("source_id", 0)
	var atlas_coords_dict = args.get("atlas_coords", {"x": 0, "y": 0})
	var atlas_coords = Vector2i(int(atlas_coords_dict.get("x", 0)), int(atlas_coords_dict.get("y", 0)))
	var alternative_id = args.get("alternative_id", 0)

	if layer < 0 or layer >= tilemap.get_layers_count():
		return _error("Invalid layer: %d" % layer)

	var start_x = int(rect_dict.get("x", 0))
	var start_y = int(rect_dict.get("y", 0))
	var width = int(rect_dict.get("width", 1))
	var height = int(rect_dict.get("height", 1))

	var cells_set = 0
	for x in range(start_x, start_x + width):
		for y in range(start_y, start_y + height):
			tilemap.set_cell(layer, Vector2i(x, y), source_id, atlas_coords, alternative_id)
			cells_set += 1

	return _success({
		"layer": layer,
		"rect": rect_dict,
		"cells_set": cells_set,
		"source_id": source_id,
		"atlas_coords": _serialize_value(atlas_coords)
	}, "Rectangle filled with %d cells" % cells_set)


func _clear_tilemap_layer(tilemap: TileMap, args: Dictionary) -> Dictionary:
	var layer = args.get("layer", 0)

	if layer < 0 or layer >= tilemap.get_layers_count():
		return _error("Invalid layer: %d" % layer)

	tilemap.clear_layer(layer)

	return _success({
		"layer": layer
	}, "Layer %d cleared" % layer)


func _get_used_cells(tilemap: TileMap, args: Dictionary) -> Dictionary:
	var layer = args.get("layer", 0)

	if layer < 0 or layer >= tilemap.get_layers_count():
		return _error("Invalid layer: %d" % layer)

	var cells = tilemap.get_used_cells(layer)
	var cells_array: Array[Dictionary] = []

	# Limit to first 1000 cells to prevent huge responses
	var limit = mini(cells.size(), 1000)
	for i in range(limit):
		cells_array.append(_serialize_value(cells[i]))

	return _success({
		"layer": layer,
		"total_count": cells.size(),
		"returned_count": cells_array.size(),
		"cells": cells_array,
		"truncated": cells.size() > 1000
	})


func _get_used_rect(tilemap: TileMap, args: Dictionary) -> Dictionary:
	var rect = tilemap.get_used_rect()

	return _success({
		"rect": {
			"position": _serialize_value(rect.position),
			"size": _serialize_value(rect.size),
			"end": _serialize_value(rect.end)
		}
	})
