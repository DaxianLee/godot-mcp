@tool
extends RefCounted

## English translations for MCP Server

const TRANSLATIONS: Dictionary = {
	# Tab names
	"tab_server": "Server",
	"tab_tools": "Tools",
	"tab_config": "Config",

	# Header
	"title": "Godot MCP Server",
	"status_running": "Running",
	"status_stopped": "Stopped",

	# Server tab
	"server_status": "Server Status",
	"endpoint": "Endpoint:",
	"connections": "Connections:",
	"settings": "Settings",
	"port": "Port:",
	"auto_start": "Auto Start",
	"debug_log": "Debug Log",
	"btn_start": "Start",
	"btn_stop": "Stop",

	# About section
	"about": "About",
	"author": "Author:",
	"wechat": "WeChat:",

	# Tools tab
	"tools_enabled": "Tools: %d/%d enabled",
	"btn_expand_all": "Expand All",
	"btn_collapse_all": "Collapse All",
	"btn_select_all": "Select All",
	"btn_deselect_all": "Deselect All",

	# Tool categories - Core
	"cat_scene": "Scene",
	"cat_node": "Node",
	"cat_script": "Script",
	"cat_resource": "Resource",
	"cat_filesystem": "Filesystem",
	"cat_project": "Project",
	"cat_editor": "Editor",
	"cat_debug": "Debug",
	"cat_animation": "Animation",

	# Tool categories - Visual
	"cat_material": "Material",
	"cat_shader": "Shader",
	"cat_lighting": "Lighting",
	"cat_particle": "Particle",

	# Tool categories - 2D
	"cat_tilemap": "TileMap",
	"cat_geometry": "Geometry",

	# Tool categories - Gameplay
	"cat_physics": "Physics",
	"cat_navigation": "Navigation",
	"cat_audio": "Audio",

	# Tool categories - Utilities
	"cat_ui": "UI",
	"cat_signal": "Signal",
	"cat_group": "Group",

	# Config tab - IDE section
	"ide_config": "IDE One-Click Configuration",
	"ide_config_desc": "Click to auto-write config file, restart client to take effect",
	"btn_one_click": "One-Click Config",
	"btn_copy": "Copy",

	# Config tab - CLI section
	"cli_config": "CLI Command Line Configuration",
	"cli_config_desc": "Copy command and run in terminal",
	"config_scope": "Configuration Scope:",
	"scope_user": "User (Global)",
	"scope_project": "Project (Current Only)",
	"btn_copy_cmd": "Copy Command",

	# Messages
	"msg_config_success": "%s configured successfully!",
	"msg_config_failed": "Configuration failed",
	"msg_copied": "%s copied to clipboard",
	"msg_parse_error": "Configuration parse error",
	"msg_dir_error": "Cannot create directory: ",
	"msg_write_error": "Cannot write config file",

	# Language
	"language": "Language:",

	# ==================== Tool Descriptions ====================
	# Scene tools
	"tool_scene_management_desc": "Open, save, create and manage scenes",
	"tool_scene_hierarchy_desc": "Get scene tree structure and node selection",
	"tool_scene_run_desc": "Run and test scenes in the editor",

	# Node tools
	"tool_node_query_desc": "Find and inspect nodes by name, type or pattern",
	"tool_node_lifecycle_desc": "Create, delete, duplicate and instantiate nodes",
	"tool_node_transform_desc": "Modify position, rotation and scale",
	"tool_node_property_desc": "Get and set any node property",
	"tool_node_hierarchy_desc": "Manage parent-child relationships and order",
	"tool_node_signal_desc": "Connect, disconnect and emit signals",
	"tool_node_group_desc": "Add, remove and query node groups",
	"tool_node_process_desc": "Control node processing modes",
	"tool_node_metadata_desc": "Get and set node metadata",
	"tool_node_call_desc": "Call methods on nodes dynamically",
	"tool_node_visibility_desc": "Control node visibility and layers",
	"tool_node_physics_desc": "Configure physics properties",

	# Resource tools
	"tool_resource_query_desc": "Find and inspect resources",
	"tool_resource_manage_desc": "Load, save and duplicate resources",
	"tool_resource_texture_desc": "Manage texture resources",

	# Project tools
	"tool_project_info_desc": "Get project information and paths",
	"tool_project_settings_desc": "Read and modify project settings",
	"tool_project_input_desc": "Manage input action mappings",
	"tool_project_autoload_desc": "Manage autoload singletons",

	# Script tools
	"tool_script_manage_desc": "Create, read and modify scripts",
	"tool_script_attach_desc": "Attach or detach scripts from nodes",
	"tool_script_edit_desc": "Add functions, variables and signals",
	"tool_script_open_desc": "Open scripts in the editor",

	# Editor tools
	"tool_editor_status_desc": "Get editor status and scene info",
	"tool_editor_settings_desc": "Read and modify editor settings",
	"tool_editor_undo_redo_desc": "Manage undo/redo operations",
	"tool_editor_notification_desc": "Show editor notifications and dialogs",
	"tool_editor_inspector_desc": "Control the inspector panel",
	"tool_editor_filesystem_desc": "Interact with the filesystem dock",
	"tool_editor_plugin_desc": "Query and manage editor plugins",

	# Debug tools
	"tool_debug_log_desc": "Print debug messages and errors",
	"tool_debug_performance_desc": "Monitor performance metrics",
	"tool_debug_profiler_desc": "Profile code execution",
	"tool_debug_class_db_desc": "Query Godot's class database",

	# Filesystem tools
	"tool_filesystem_directory_desc": "Create, delete and list directories",
	"tool_filesystem_file_desc": "Read, write and manage files",
	"tool_filesystem_json_desc": "Read and write JSON files",
	"tool_filesystem_search_desc": "Search files by pattern",

	# Animation tools
	"tool_animation_player_desc": "Control AnimationPlayer nodes",
	"tool_animation_animation_desc": "Create and modify animations",
	"tool_animation_track_desc": "Add and edit animation tracks",
	"tool_animation_tween_desc": "Create and control tweens",
	"tool_animation_animation_tree_desc": "Setup and configure animation trees",
	"tool_animation_state_machine_desc": "Manage animation state machines",
	"tool_animation_blend_space_desc": "Configure blend spaces",
	"tool_animation_blend_tree_desc": "Setup blend tree nodes",

	# Material tools
	"tool_material_material_desc": "Create and modify materials",
	"tool_material_mesh_desc": "Manage mesh resources",

	# Shader tools
	"tool_shader_shader_desc": "Create and edit shaders",
	"tool_shader_shader_material_desc": "Apply shaders to materials",

	# Lighting tools
	"tool_lighting_light_desc": "Create and configure lights",
	"tool_lighting_environment_desc": "Setup world environment",
	"tool_lighting_sky_desc": "Configure sky and atmosphere",

	# Particle tools
	"tool_particle_particles_desc": "Create and configure particle systems",
	"tool_particle_particle_material_desc": "Setup particle materials",

	# Tilemap tools
	"tool_tilemap_tileset_desc": "Create and edit tilesets",
	"tool_tilemap_tilemap_desc": "Edit tilemap layers and cells",

	# Geometry tools
	"tool_geometry_csg_desc": "Create CSG constructive solid geometry",
	"tool_geometry_gridmap_desc": "Edit 3D grid-based maps",
	"tool_geometry_multimesh_desc": "Setup multi-mesh instances",

	# Physics tools
	"tool_physics_physics_body_desc": "Create and configure physics bodies",
	"tool_physics_collision_shape_desc": "Add and modify collision shapes",
	"tool_physics_physics_joint_desc": "Create physics joints and constraints",
	"tool_physics_physics_query_desc": "Perform physics queries and raycasts",

	# Navigation tools
	"tool_navigation_navigation_desc": "Setup navigation meshes and agents",

	# Audio tools
	"tool_audio_bus_desc": "Manage audio buses and effects",
	"tool_audio_player_desc": "Control audio playback",

	# UI tools
	"tool_ui_theme_desc": "Create and modify UI themes",
	"tool_ui_control_desc": "Configure control nodes",

	# Signal tools
	"tool_signal_signal_desc": "Manage signal connections globally",

	# Group tools
	"tool_group_group_desc": "Query and manage node groups globally",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
