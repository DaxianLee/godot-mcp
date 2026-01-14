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

	# ==================== Werkzeugbeschreibungen ====================
	# Szenen-Werkzeuge
	"tool_scene_management_desc": "Szenen öffnen, speichern, erstellen und verwalten",
	"tool_scene_hierarchy_desc": "Szenenbaum-Struktur und Knotenauswahl abrufen",
	"tool_scene_run_desc": "Szenen im Editor ausführen und testen",

	# Knoten-Werkzeuge
	"tool_node_query_desc": "Knoten nach Name, Typ oder Muster suchen und untersuchen",
	"tool_node_lifecycle_desc": "Knoten erstellen, löschen, duplizieren und instanziieren",
	"tool_node_transform_desc": "Position, Rotation und Skalierung ändern",
	"tool_node_property_desc": "Beliebige Knoteneigenschaften abrufen und setzen",
	"tool_node_hierarchy_desc": "Eltern-Kind-Beziehungen und Reihenfolge verwalten",
	"tool_node_signal_desc": "Signale verbinden, trennen und aussenden",
	"tool_node_group_desc": "Knotengruppen hinzufügen, entfernen und abfragen",
	"tool_node_process_desc": "Knotenverarbeitungsmodi steuern",
	"tool_node_metadata_desc": "Knoten-Metadaten abrufen und setzen",
	"tool_node_call_desc": "Methoden auf Knoten dynamisch aufrufen",
	"tool_node_visibility_desc": "Sichtbarkeit und Layer von Knoten steuern",
	"tool_node_physics_desc": "Physik-Eigenschaften konfigurieren",

	# Ressourcen-Werkzeuge
	"tool_resource_query_desc": "Ressourcen suchen und untersuchen",
	"tool_resource_manage_desc": "Ressourcen laden, speichern und duplizieren",
	"tool_resource_texture_desc": "Textur-Ressourcen verwalten",

	# Projekt-Werkzeuge
	"tool_project_info_desc": "Projektinformationen und Pfade abrufen",
	"tool_project_settings_desc": "Projekteinstellungen lesen und ändern",
	"tool_project_input_desc": "Eingabe-Aktionszuordnungen verwalten",
	"tool_project_autoload_desc": "Autoload-Singletons verwalten",

	# Skript-Werkzeuge
	"tool_script_manage_desc": "Skripte erstellen, lesen und ändern",
	"tool_script_attach_desc": "Skripte an Knoten anhängen oder lösen",
	"tool_script_edit_desc": "Funktionen, Variablen und Signale hinzufügen",
	"tool_script_open_desc": "Skripte im Editor öffnen",

	# Editor-Werkzeuge
	"tool_editor_status_desc": "Editor-Status und Szeneninformationen abrufen",
	"tool_editor_settings_desc": "Editor-Einstellungen lesen und ändern",
	"tool_editor_undo_redo_desc": "Rückgängig/Wiederholen-Operationen verwalten",
	"tool_editor_notification_desc": "Editor-Benachrichtigungen und Dialoge anzeigen",
	"tool_editor_inspector_desc": "Inspector-Panel steuern",
	"tool_editor_filesystem_desc": "Mit dem Dateisystem-Dock interagieren",
	"tool_editor_plugin_desc": "Editor-Plugins suchen und verwalten",

	# Debug-Werkzeuge
	"tool_debug_log_desc": "Debug-Nachrichten und Fehler ausgeben",
	"tool_debug_performance_desc": "Leistungsmetriken überwachen",
	"tool_debug_profiler_desc": "Code-Ausführung profilieren",
	"tool_debug_class_db_desc": "Godot-Klassendatenbank abfragen",

	# Dateisystem-Werkzeuge
	"tool_filesystem_directory_desc": "Verzeichnisse erstellen, löschen und auflisten",
	"tool_filesystem_file_desc": "Dateien lesen, schreiben und verwalten",
	"tool_filesystem_json_desc": "JSON-Dateien lesen und schreiben",
	"tool_filesystem_search_desc": "Dateien nach Muster suchen",

	# Animations-Werkzeuge
	"tool_animation_player_desc": "AnimationPlayer-Knoten steuern",
	"tool_animation_animation_desc": "Animationen erstellen und ändern",
	"tool_animation_track_desc": "Animationsspuren hinzufügen und bearbeiten",
	"tool_animation_tween_desc": "Tweens erstellen und steuern",
	"tool_animation_animation_tree_desc": "Animationsbäume einrichten und konfigurieren",
	"tool_animation_state_machine_desc": "Animations-Zustandsmaschinen verwalten",
	"tool_animation_blend_space_desc": "Blend-Spaces konfigurieren",
	"tool_animation_blend_tree_desc": "Blend-Tree-Knoten einrichten",

	# Material-Werkzeuge
	"tool_material_material_desc": "Materialien erstellen und ändern",
	"tool_material_mesh_desc": "Mesh-Ressourcen verwalten",

	# Shader-Werkzeuge
	"tool_shader_shader_desc": "Shader erstellen und bearbeiten",
	"tool_shader_shader_material_desc": "Shader auf Materialien anwenden",

	# Beleuchtungs-Werkzeuge
	"tool_lighting_light_desc": "Lichter erstellen und konfigurieren",
	"tool_lighting_environment_desc": "Weltumgebung einrichten",
	"tool_lighting_sky_desc": "Himmel und Atmosphäre konfigurieren",

	# Partikel-Werkzeuge
	"tool_particle_particles_desc": "Partikelsysteme erstellen und konfigurieren",
	"tool_particle_particle_material_desc": "Partikelmaterialien einrichten",

	# TileMap-Werkzeuge
	"tool_tilemap_tileset_desc": "Tilesets erstellen und bearbeiten",
	"tool_tilemap_tilemap_desc": "TileMap-Layer und Zellen bearbeiten",

	# Geometrie-Werkzeuge
	"tool_geometry_csg_desc": "CSG-Konstruktive Festkörpergeometrie erstellen",
	"tool_geometry_gridmap_desc": "3D-Rasterkarten bearbeiten",
	"tool_geometry_multimesh_desc": "Multi-Mesh-Instanzen einrichten",

	# Physik-Werkzeuge
	"tool_physics_physics_body_desc": "Physik-Körper erstellen und konfigurieren",
	"tool_physics_collision_shape_desc": "Kollisionsformen hinzufügen und ändern",
	"tool_physics_physics_joint_desc": "Physik-Gelenke und Constraints erstellen",
	"tool_physics_physics_query_desc": "Physik-Abfragen und Raycasts ausführen",

	# Navigations-Werkzeuge
	"tool_navigation_navigation_desc": "Navigations-Meshes und Agenten einrichten",

	# Audio-Werkzeuge
	"tool_audio_bus_desc": "Audio-Busse und Effekte verwalten",
	"tool_audio_player_desc": "Audio-Wiedergabe steuern",

	# UI-Werkzeuge
	"tool_ui_theme_desc": "UI-Themes erstellen und ändern",
	"tool_ui_control_desc": "Control-Knoten konfigurieren",

	# Signal-Werkzeuge
	"tool_signal_signal_desc": "Signal-Verbindungen global verwalten",

	# Gruppen-Werkzeuge
	"tool_group_group_desc": "Knotengruppen global suchen und verwalten",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
