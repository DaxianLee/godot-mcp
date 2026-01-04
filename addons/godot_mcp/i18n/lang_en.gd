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
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
