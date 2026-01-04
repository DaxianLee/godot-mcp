@tool
extends RefCounted

## Traduction française

const TRANSLATIONS: Dictionary = {
	# Tab names
	"tab_server": "Serveur",
	"tab_tools": "Outils",
	"tab_config": "Config",

	# Header
	"title": "Godot MCP Server",
	"status_running": "En cours",
	"status_stopped": "Arrêté",

	# Server tab
	"server_status": "État du serveur",
	"endpoint": "Point d'accès:",
	"connections": "Connexions:",
	"settings": "Paramètres",
	"port": "Port:",
	"auto_start": "Démarrage auto",
	"debug_log": "Journal de débogage",
	"btn_start": "Démarrer",
	"btn_stop": "Arrêter",

	# About section
	"about": "À propos",
	"author": "Auteur:",
	"wechat": "WeChat:",

	# Tools tab
	"tools_enabled": "Outils: %d/%d activés",
	"btn_expand_all": "Tout déplier",
	"btn_collapse_all": "Tout replier",
	"btn_select_all": "Tout sélectionner",
	"btn_deselect_all": "Tout désélectionner",

	# Tool categories - Core
	"cat_scene": "Scène",
	"cat_node": "Nœud",
	"cat_script": "Script",
	"cat_resource": "Ressource",
	"cat_filesystem": "Système de fichiers",
	"cat_project": "Projet",
	"cat_editor": "Éditeur",
	"cat_debug": "Débogage",
	"cat_animation": "Animation",

	# Tool categories - Visual
	"cat_material": "Matériau",
	"cat_shader": "Shader",
	"cat_lighting": "Éclairage",
	"cat_particle": "Particule",

	# Tool categories - 2D
	"cat_tilemap": "TileMap",
	"cat_geometry": "Géométrie",

	# Tool categories - Gameplay
	"cat_physics": "Physique",
	"cat_navigation": "Navigation",
	"cat_audio": "Audio",

	# Tool categories - Utilities
	"cat_ui": "Interface",
	"cat_signal": "Signal",
	"cat_group": "Groupe",

	# Config tab - IDE section
	"ide_config": "Configuration IDE en un clic",
	"ide_config_desc": "Cliquez pour écrire automatiquement le fichier de config, redémarrez le client",
	"btn_one_click": "Configurer",
	"btn_copy": "Copier",

	# Config tab - CLI section
	"cli_config": "Configuration ligne de commande",
	"cli_config_desc": "Copiez la commande et exécutez dans le terminal",
	"config_scope": "Portée de la config:",
	"scope_user": "Utilisateur (global)",
	"scope_project": "Projet (actuel uniquement)",
	"btn_copy_cmd": "Copier la commande",

	# Messages
	"msg_config_success": "%s configuré avec succès!",
	"msg_config_failed": "Échec de la configuration",
	"msg_copied": "%s copié dans le presse-papiers",
	"msg_parse_error": "Erreur d'analyse de la configuration",
	"msg_dir_error": "Impossible de créer le répertoire: ",
	"msg_write_error": "Impossible d'écrire le fichier de configuration",

	# Language
	"language": "Langue:",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
