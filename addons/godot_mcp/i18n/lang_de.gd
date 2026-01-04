@tool
extends RefCounted

## Deutsche Übersetzung

const TRANSLATIONS: Dictionary = {
	# Tab names
	"tab_server": "Server",
	"tab_tools": "Werkzeuge",
	"tab_config": "Konfiguration",

	# Header
	"title": "Godot MCP Server",
	"status_running": "Läuft",
	"status_stopped": "Gestoppt",

	# Server tab
	"server_status": "Serverstatus",
	"endpoint": "Endpunkt:",
	"connections": "Verbindungen:",
	"settings": "Einstellungen",
	"port": "Port:",
	"auto_start": "Autostart",
	"debug_log": "Debug-Protokoll",
	"btn_start": "Starten",
	"btn_stop": "Stoppen",

	# About section
	"about": "Über",
	"author": "Autor:",
	"wechat": "WeChat:",

	# Tools tab
	"tools_enabled": "Werkzeuge: %d/%d aktiviert",
	"btn_expand_all": "Alle aufklappen",
	"btn_collapse_all": "Alle zuklappen",
	"btn_select_all": "Alle auswählen",
	"btn_deselect_all": "Alle abwählen",

	# Tool categories - Core
	"cat_scene": "Szene",
	"cat_node": "Knoten",
	"cat_script": "Skript",
	"cat_resource": "Ressource",
	"cat_filesystem": "Dateisystem",
	"cat_project": "Projekt",
	"cat_editor": "Editor",
	"cat_debug": "Debug",
	"cat_animation": "Animation",

	# Tool categories - Visual
	"cat_material": "Material",
	"cat_shader": "Shader",
	"cat_lighting": "Beleuchtung",
	"cat_particle": "Partikel",

	# Tool categories - 2D
	"cat_tilemap": "TileMap",
	"cat_geometry": "Geometrie",

	# Tool categories - Gameplay
	"cat_physics": "Physik",
	"cat_navigation": "Navigation",
	"cat_audio": "Audio",

	# Tool categories - Utilities
	"cat_ui": "Benutzeroberfläche",
	"cat_signal": "Signal",
	"cat_group": "Gruppe",

	# Config tab - IDE section
	"ide_config": "IDE Ein-Klick-Konfiguration",
	"ide_config_desc": "Klicken Sie, um die Konfigurationsdatei automatisch zu schreiben, Client neu starten",
	"btn_one_click": "Konfigurieren",
	"btn_copy": "Kopieren",

	# Config tab - CLI section
	"cli_config": "CLI-Befehlszeilenkonfiguration",
	"cli_config_desc": "Befehl kopieren und im Terminal ausführen",
	"config_scope": "Konfigurationsbereich:",
	"scope_user": "Benutzer (global)",
	"scope_project": "Projekt (nur aktuelles)",
	"btn_copy_cmd": "Befehl kopieren",

	# Messages
	"msg_config_success": "%s erfolgreich konfiguriert!",
	"msg_config_failed": "Konfiguration fehlgeschlagen",
	"msg_copied": "%s in die Zwischenablage kopiert",
	"msg_parse_error": "Fehler beim Parsen der Konfiguration",
	"msg_dir_error": "Verzeichnis kann nicht erstellt werden: ",
	"msg_write_error": "Konfigurationsdatei kann nicht geschrieben werden",

	# Language
	"language": "Sprache:",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
