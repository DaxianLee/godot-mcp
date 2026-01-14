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

	# ==================== Descriptions des outils ====================
	# Outils de scène
	"tool_scene_management_desc": "Ouvrir, enregistrer, créer et gérer les scènes",
	"tool_scene_hierarchy_desc": "Obtenir la structure de l'arbre de scène et la sélection des nœuds",
	"tool_scene_run_desc": "Exécuter et tester les scènes dans l'éditeur",

	# Outils de nœud
	"tool_node_query_desc": "Rechercher et inspecter les nœuds par nom, type ou motif",
	"tool_node_lifecycle_desc": "Créer, supprimer, dupliquer et instancier des nœuds",
	"tool_node_transform_desc": "Modifier la position, rotation et échelle",
	"tool_node_property_desc": "Obtenir et définir toute propriété de nœud",
	"tool_node_hierarchy_desc": "Gérer les relations parent-enfant et l'ordre",
	"tool_node_signal_desc": "Connecter, déconnecter et émettre des signaux",
	"tool_node_group_desc": "Ajouter, supprimer et rechercher des groupes de nœuds",
	"tool_node_process_desc": "Contrôler les modes de traitement des nœuds",
	"tool_node_metadata_desc": "Obtenir et définir les métadonnées du nœud",
	"tool_node_call_desc": "Appeler dynamiquement des méthodes sur les nœuds",
	"tool_node_visibility_desc": "Contrôler la visibilité et les calques des nœuds",
	"tool_node_physics_desc": "Configurer les propriétés physiques",

	# Outils de ressource
	"tool_resource_query_desc": "Rechercher et inspecter les ressources",
	"tool_resource_manage_desc": "Charger, enregistrer et dupliquer les ressources",
	"tool_resource_texture_desc": "Gérer les ressources de texture",

	# Outils de projet
	"tool_project_info_desc": "Obtenir les informations et chemins du projet",
	"tool_project_settings_desc": "Lire et modifier les paramètres du projet",
	"tool_project_input_desc": "Gérer les mappages d'actions d'entrée",
	"tool_project_autoload_desc": "Gérer les singletons autoload",

	# Outils de script
	"tool_script_manage_desc": "Créer, lire et modifier des scripts",
	"tool_script_attach_desc": "Attacher ou détacher des scripts des nœuds",
	"tool_script_edit_desc": "Ajouter des fonctions, variables et signaux",
	"tool_script_open_desc": "Ouvrir des scripts dans l'éditeur",

	# Outils d'éditeur
	"tool_editor_status_desc": "Obtenir l'état de l'éditeur et les infos de scène",
	"tool_editor_settings_desc": "Lire et modifier les paramètres de l'éditeur",
	"tool_editor_undo_redo_desc": "Gérer les opérations annuler/rétablir",
	"tool_editor_notification_desc": "Afficher les notifications et dialogues de l'éditeur",
	"tool_editor_inspector_desc": "Contrôler le panneau inspecteur",
	"tool_editor_filesystem_desc": "Interagir avec le dock du système de fichiers",
	"tool_editor_plugin_desc": "Rechercher et gérer les plugins de l'éditeur",

	# Outils de débogage
	"tool_debug_log_desc": "Afficher les messages de débogage et erreurs",
	"tool_debug_performance_desc": "Surveiller les métriques de performance",
	"tool_debug_profiler_desc": "Profiler l'exécution du code",
	"tool_debug_class_db_desc": "Interroger la base de données des classes Godot",

	# Outils du système de fichiers
	"tool_filesystem_directory_desc": "Créer, supprimer et lister les répertoires",
	"tool_filesystem_file_desc": "Lire, écrire et gérer les fichiers",
	"tool_filesystem_json_desc": "Lire et écrire des fichiers JSON",
	"tool_filesystem_search_desc": "Rechercher des fichiers par motif",

	# Outils d'animation
	"tool_animation_player_desc": "Contrôler les nœuds AnimationPlayer",
	"tool_animation_animation_desc": "Créer et modifier des animations",
	"tool_animation_track_desc": "Ajouter et modifier des pistes d'animation",
	"tool_animation_tween_desc": "Créer et contrôler des tweens",
	"tool_animation_animation_tree_desc": "Configurer les arbres d'animation",
	"tool_animation_state_machine_desc": "Gérer les machines à états d'animation",
	"tool_animation_blend_space_desc": "Configurer les espaces de mélange",
	"tool_animation_blend_tree_desc": "Configurer les nœuds d'arbre de mélange",

	# Outils de matériau
	"tool_material_material_desc": "Créer et modifier des matériaux",
	"tool_material_mesh_desc": "Gérer les ressources de maillage",

	# Outils de shader
	"tool_shader_shader_desc": "Créer et modifier des shaders",
	"tool_shader_shader_material_desc": "Appliquer des shaders aux matériaux",

	# Outils d'éclairage
	"tool_lighting_light_desc": "Créer et configurer des lumières",
	"tool_lighting_environment_desc": "Configurer l'environnement mondial",
	"tool_lighting_sky_desc": "Configurer le ciel et l'atmosphère",

	# Outils de particules
	"tool_particle_particles_desc": "Créer et configurer des systèmes de particules",
	"tool_particle_particle_material_desc": "Configurer les matériaux de particules",

	# Outils de tilemap
	"tool_tilemap_tileset_desc": "Créer et modifier des tilesets",
	"tool_tilemap_tilemap_desc": "Modifier les calques et cellules du tilemap",

	# Outils de géométrie
	"tool_geometry_csg_desc": "Créer de la géométrie CSG constructive",
	"tool_geometry_gridmap_desc": "Modifier les cartes de grille 3D",
	"tool_geometry_multimesh_desc": "Configurer les instances multi-maillage",

	# Outils de physique
	"tool_physics_physics_body_desc": "Créer et configurer des corps physiques",
	"tool_physics_collision_shape_desc": "Ajouter et modifier des formes de collision",
	"tool_physics_physics_joint_desc": "Créer des joints et contraintes physiques",
	"tool_physics_physics_query_desc": "Effectuer des requêtes physiques et raycasts",

	# Outils de navigation
	"tool_navigation_navigation_desc": "Configurer les maillages et agents de navigation",

	# Outils audio
	"tool_audio_bus_desc": "Gérer les bus audio et les effets",
	"tool_audio_player_desc": "Contrôler la lecture audio",

	# Outils UI
	"tool_ui_theme_desc": "Créer et modifier des thèmes UI",
	"tool_ui_control_desc": "Configurer les nœuds de contrôle",

	# Outils de signal
	"tool_signal_signal_desc": "Gérer globalement les connexions de signaux",

	# Outils de groupe
	"tool_group_group_desc": "Rechercher et gérer globalement les groupes de nœuds",
}


static func get_translations() -> Dictionary:
	return TRANSLATIONS
